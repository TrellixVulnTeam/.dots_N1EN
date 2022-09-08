setlocal path=/usr/local/go/src/**/*.,**,$GOROOT/src
setlocal tags+=/usr/local/go/src/tags
setlocal suffixesadd=.go,/
setlocal include=^\\t\\%(\\w\\+\\s\\+\\)\\=\"\\zs[^\"]*\\ze\"$
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal noexpandtab
setlocal autoindent
setlocal smartindent

augroup goAugroup
  autocmd!
  autocmd BufWritePost *.go call LintOnSave()
augroup END

function! LintOnSave()
  " let cwd=getcwd()

  " " Build
  " let b:package_name = GetPackageName()
  " compiler gobuild
  " exec "silent make " . b:package_name
  " if !HandleErrors()
  "   return
  " endif

  " redraw | echo "Built package" 

  " " Lint using golangci-lint
  " compiler golangcilint
  " silent make
  " if !HandleErrors()
  "   return
  " endif

  " redraw | echo "Linted with golangci-lint" 

  " Run tests for package
  " let cwd=getcwd()
  " call CdToPackage()
  " compiler gosshtest
  " exec "silent make " . b:package_name
  " exec "lcd " . cwd
  " if !HandleErrors()
  "   return
  " endif
  
  " redraw | echo "Linting and tests passed." 
endfunction

function! HandleErrors()
  if len(getqflist()) > 0
    cope
    return 0
  endif

  cclo
  return 1
endfunction

function! GetParentDirectory()
  return expand("%:p:h")
endfunction

function! CdToPackage()
  let parent_dir=GetParentDirectory()
  exec "lcd " . parent_dir
endfunction

function! GetPackageName()
  let cwd=getcwd()

  call CdToPackage()

  let package_name = trim(system("go list"))

  exec "lcd " . cwd
  return package_name
endfunction

nnoremap <Leader>gd <cmd>call ft#go#GoToDefinition()<cr>
nnoremap <Leader>gf :silent grep --exclude-dir=vendor '^\t*\b\b' .<left><left><left><left><left><c-r><c-w><cr>

" Use treesitter for folds
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
