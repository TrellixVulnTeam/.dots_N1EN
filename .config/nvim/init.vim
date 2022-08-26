" Settings {{{
colorscheme mine
set nocompatible " Don't try to imitate vi
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
set directory^=$HOME/.vim/swap// " Put swapfiles in one place
set noswapfile
set foldmethod=syntax " Default to folding based on syntax
set autoread " source file changes
set background=dark
set hidden " change buffers without saving
set history=10000 " remember : commands
set ignorecase " ignore case in searching
set smartcase " if we use caps in search, turn off ignore case
set infercase " smarter completion
set mouse=a
set inccommand=nosplit " show replacements in place
set clipboard=unnamedplus " copy to system clipboard always
set shortmess+=I
set tabpagemax=50
set path=.,,
set laststatus=2
set viewoptions=folds,cursor " dont save locally modified options, or changed dir
set sessionoptions-=options
set lazyredraw " dont update screen during macros
set linebreak " dont break in the middle of words
set wildcharm=<tab>
set wildmenu
set sidescrolloff=5
set dictionary=/usr/share/dict/words
set completeopt=menuone " suggested settings for completion
set shiftwidth=2 " spaces to indent by
set tabstop=2 " no. of space <Tab> counts for
set softtabstop=2 " spaces <Tab> counts for when editing
set expandtab " expand tabs into spaces
set autowrite " :make writes the buffer if changed, useful for compiling with autocmds
set maxmempattern=2000000 " increase max memory to show syntax highlighting for large files
set nocursorline
set display+=lastline
set autoindent
set smartindent
set splitbelow
set splitright
set undofile
set browsedir=buffer
set timeoutlen=700 " reduce time to complete mapping slightly
set wildignore=*.tar.gz
set runtimepath+=~/.fzf
set backspace=indent,eol,start " Make backspace work like normal
set complete-=i " Don't scan included files for completion
set smarttab " <tab> inserts whitespace at start of line
set nrformats-=octal " Don't consider numbers beginning with 0 to be octal
set incsearch
set breakindent

" If we're using vimR, we're writing notes
if has("gui_vimr")
  e ~/wiki/notes.txt
endif

" Disable syntax highlighting if we're diffing
if &diff
  syntax off
endif

set grepprg=grep\ -nP\ $*\ --binary-files=without-match\ --exclude-dir=.git\ --exclude-dir=node_modules\ --exclude='*.tar.gz'\ --exclude='tags'\ -R\ /dev/null

let mapleader = "\<Space>"

" Variables {{{1
let g:sh_fold_enabled = 7
let g:javaScript_fold = 1
let g:is_bash	= 1

let g:netrw_banner = 0
let g:netrw_list_hide = '^\.\.\/$,^\.\/$' " Hide current and parent directory 

" Autocmds {{{1
augroup myAugroup
  autocmd!
  autocmd BufWritePost init.vim source <afile>

  autocmd BufNewFile,BufRead .gitconfig_shared set ft=gitconfig
  autocmd BufNewFile *.sh 0r ~/.config/nvim/templates/skeleton.sh

  " https://vi.stackexchange.com/questions/13864/bufwinleave-mkview-with-unnamed-file-error-32
  " view files are about 500 bytes
  " bufleave but not bufwinleave captures closing 2nd tab
  " nested is needed by bufwrite* (if triggered via other autocmd)
  " BufHidden for compatibility with `set hidden`
  autocmd BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview

  autocmd BufRead,BufNewFile profile_extra,aliases,*.shlib set filetype=sh
  autocmd WinEnter,BufEnter * call statusline#active()
  autocmd WinLeave,BufLeave * call statusline#inactive()
  autocmd InsertEnter * call statusline#insert()
  autocmd InsertLeave * call statusline#active()
  autocmd CursorHold * checktime  

  autocmd FileType c,cpp setlocal path+=/usr/include include&
  autocmd FileType vim,text setlocal foldmethod=marker
augroup END


" User commands {{{1
command! TestPackage make .
command! Recent vnew | wincmd H | vert res 50 | set nowrap | exec '0r!ls -ct' | norm gg
command! Tree vnew | wincmd H | vert res 50 | set nowrap | exec '0r!tree -f -I node_modules' | set ft=tree | norm gg
command! Notes e ~/wiki/notes.txt

" User mappings {{{1

" Find files
nnoremap <Leader>fi :find **/*
" Find files from directory of current file
nnoremap <Leader>fc :find <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
" Same as above but split the file to the right
nnoremap <Leader>fv :vert sfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>

" Edit file from directory of current file
nnoremap <Leader>ec :e <C-R>=fnameescape(expand('%:p:h'))<CR>
" Same as above but split the file to the right
nnoremap <Leader>ev :vert sp <C-R>=fnameescape(expand('%:p:h'))<CR>

" Grep 
nnoremap <Leader>ge :GrepExactWord<space>
command! -nargs=* GrepExactWord call GrepExactWord(<f-args>)
function! GrepExactWord(...)
  exec ":silent grep --exclude-dir=vendor '\\b" . join(a:000, " ") . "\\b' ."
  redraw!
  cope
endfunction

nnoremap <Leader>gf :GrepExactWordMatchFiletype<space>
command! -nargs=* GrepExactWordMatchFiletype call GrepExactWordMatchFiletype(<f-args>)
function! GrepExactWordMatchFiletype(...)
  let l:ft = &ft
  echo l:ft
  exec ":silent grep --include='*." . l:ft . "' --exclude-dir=vendor '\\b" . join(a:000, " ") . "\\b' ."
  redraw!
  cope
endfunction

nnoremap <Leader>gr :Grep<space>
command! -nargs=* Grep call Grep(<f-args>)
function! Grep(...)
  exec ":silent grep -i --exclude-dir=vendor '" . join(a:000, " ") . "' ."
  redraw!
  cope
endfunction

" Grep word under cursor
nnoremap <Leader>gw :Grep<space><c-r><c-w><cr>
" Grep word under cursor, also look in vendor
nnoremap <Leader>gW :exec "silent grep '\\b\\b' ."<left><left><left><left><left><left><left><left><c-r><c-w><c-e> \| :cope<cr>
" Grep word under cursor, ONLY look in vendor
nnoremap <Leader>GW :exec "silent grep '\\b\\b' <left><left><left><left><left><c-r><c-w><c-e>vendor" \| :cope<cr>

nnoremap <Leader>ss :mksession! ~/.local/share/nvim/sessions/
nnoremap <Leader>so :source ~/.local/share/nvim/sessions/

nnoremap <Leader>bo :bro ol<CR>

" LSP/Treesitter
nnoremap gW :Telescope lsp_dynamic_workspace_symbols<CR>
nnoremap gb :Telescope buffers<CR>
nnoremap gl :Telescope find_files<CR>
nnoremap <Leader>gr :Telescope live_grep<CR>
nnoremap gS :SymbolsOutline<CR>

" Git
nnoremap <Leader>gs :vert Git<CR>
nnoremap <Leader>gb :GBrowse<CR>

" Vim
nnoremap <Leader>vi <cmd>e $MYVIMRC<cr>
nnoremap <Leader>vl <cmd>e $HOME/.config/nvim/lua/config.lua<cr>
nnoremap <Leader>vr <cmd>source $MYVIMRC<cr>
nnoremap <Leader>vc <cmd>e $HOME/.config/nvim/colors/mine.vim<cr>

" Markdown
nnoremap <Leader>ml a[]()<esc>hhi
command! MarkdownCreate e <cfile>
command! MarkdownNavigate vimgrep '^#' % | cope

" Tmux
nnoremap <Leader>ts :lua tmux_send_markdown_code_block()<CR>
nnoremap <Leader>td :lua tmux_send_line("C-d", true)<CR>
nnoremap <Leader>tc :lua tmux_send_line("C-c", true)<CR>
nnoremap <Leader>te :lua tmux_dispatch_filetype()<CR>

" Go
nnoremap <Leader>ga :GoTest ./...<CR>
nnoremap <Leader>gp :GoTest<CR>
nnoremap <Leader>gt :GoTestFunc<CR>

" Utils
command! SingleSpaces %s/\s\+/\ /g
nnoremap <Leader>um :!mkdir -p %:h<CR> " Make the directory for which the current file should be in

nnoremap <c-x><c-m> :term terminal-menu.sh<cr>

" Terminal
tnoremap <Esc> <C-\><C-n>

" Fix open in browser
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<CR>

lua require('config')
