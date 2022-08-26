function! ft#go#GoToDefinition()
  let l:line = getline('.')
  let l:word=expand("<cword>")
  echom l:line
  echom l:word
  " If we have a . before the word
  if l:line =~ '\.' . l:word
    " case: time.Time(), where cursor is on Time
    " Either a function 'Time' defined on a struct 'time'
    " or a function 'Time' in the package 'time'
    " We can easily ascertain whether it's a package by checking the imports
    " (assuming we've saved an goimport'd the file, it should be present)
    if l:line =~ '[ ]\w*\.' . l:word
      let l:package = getline('1')
      if l:package =~ '^package\ \w*$'
        let package_name = matchstr(l:package, 'package\ \(\)')
      endif
      return
    endif

    " case: this.that.Other(), where cursor is on Other
    " so you want to be taken to the function Other, which is defined on a
    " struct called that
    if l:line =~ '\.\w*\.' . l:word
      echom " dot before dot"
    endif
    " let l:before_period = matchstr(l:line, '.*[\ \.]')
  endif
  exe "silent grep --exclude-dir=vendor '^type \\b" . word . "\\b' ."

" nnoremap <Leader>gf :silent grep --exclude-dir=vendor '^\t*\b\b' .<left><left><left><left><left><c-r><c-w><cr>
endfunction

function! ft#go#MyGrep(...)
  let l:cmd_type="grep"
  let l:cmd="grep -n -R"
  let l:excludes = "--exclude='*.tar.gz'
        \ --exclude='*.tar'
        \ --exclude=tags
        \ --exclude-dir=.git
        \ --exclude-dir=vendor
        \ --exclude-dir=node_modules"

  " If we have rg, use it
  call system('test -x "$(which rg)"')
  if !v:shell_error 
    let l:cmd_type="rg"
    let l:cmd="rg --vimgrep"
    let l:excludes = "--iglob='!*.tar.gz'
          \ --iglob=!'*.tar'
          \ --iglob=!tags
          \ --iglob='!.git/*'
          \ --iglob='!vendor/*'
          \ --iglob='!node_modules/*'"
  endif

  call setqflist([], 'r')
  let l:grep_cmd = l:cmd . ' ' . l:excludes . " '" . join(a:000) . "' ."
  let l:results = split(system(l:grep_cmd), '\n')

  if len(l:results) > 50000
    echom "Truncating results to 50000"
    let l:results = l:results[:50000-1]
  endif

  for i in l:results
    let l:dict = {}
    let l:res_arr = split(i, ':')
    " Check the length is at least the minimum we require, if the result
    " has ':' in it, we end up with more elements in l:res_arr
    if l:cmd_type == "grep" && len(l:res_arr) >= 3
      let l:dict.filename = l:res_arr[0]
      let l:dict.lnum = l:res_arr[1]
      let l:dict.text = join(l:res_arr[2:], ':')
    elseif l:cmd_type == "rg" && len(l:res_arr) >= 4
      let l:dict.filename = l:res_arr[0]
      let l:dict.lnum = l:res_arr[1]
      let l:dict.col = l:res_arr[2]
      let l:dict.text = join(l:res_arr[3:], ':')
    endif

    call setqflist([l:dict], 'a')
  endfor

  copen
endfunction
command -nargs=* Grep call MyGrep(<f-args>)

function! ft#go#MyFormat(args)
  " detect language
  " run appropriate formatters
  echom "works"
endfunction
command -nargs=* MyFormat call MyFormat(<f-args>)
nnoremap <Leader>li :Format<CR>

function! ft#go#IsError(errorList)
  if len(a:errorList) > 3 && a:errorList[1] =~ '^\d\+$' && a:errorList[2] =~ '^\d\+$'
    return 1
  endif

  return 0
endfunction

function! ft#go#MyLint()
  write

  let l:founderr = 0
  call setqflist([], 'r')

  let l:ft = &ft
  if l:ft == "go"
    call functions#LintGo()
  elseif l:ft = "sh"

  endif

  if len(getqflist()) > 0
    copen
  else
    cclose
  endif
endfunction

function! ft#go#GoToDef()
  " try to use lsp if we have it
  "
  " otherwise fall back to tags
  let l:cursorWord = expand("<cword>")
  exe "tag " . l:cursorWord

  " if we don't have a tags file, try to generate one
  " if that fails then just grep for usages and populate qf list
  
endfunction

function! ft#go#LintGo()
  " Run goimports first just to check for errors
  let l:errs = split(system('goimports ' . expand('%')), '\n')

  " if we have a line, and that line has at least 3 entries, where indexes 1
  " and 2 are digits, then we probably got errors back, rather than
  " the formatted buffer
  for i in l:errs
    let l:res_arr = split(i, ':')
    if IsError(l:res_arr)
      let l:founderr = 1
      let l:dict = {}
      let l:dict.filename = l:res_arr[0]
      let l:dict.lnum = l:res_arr[1]
      let l:dict.col = l:res_arr[2]
      let l:dict.text = join(l:res_arr[3:], ':')

      call setqflist([l:dict], 'a')
    endif
  endfor

  " If after calling gofmt, we didn't find any lines that look like errors in the result, then we got back a formatted buffer, so simply replace the current buffer with that one
  " TODO this screws up the undo command, find a better way to do this
  if !l:founderr
    let b:winview = winsaveview()
    norm ggdG
    0put =l:errs
    call winrestview(b:winview)
    write
  endif

  " If this is a main file, have a go at compiling it
  if expand('%:t') == "main.go"
    let l:errs = split(system('go build -o /tmp/build ' . expand('%')), '\n')
    for i in l:errs
      let l:res_arr = split(i, ':')
      if IsError(l:res_arr)
        let l:founderr = 1
        let l:dict = {}
        let l:dict.filename = l:res_arr[0]
        let l:dict.lnum = l:res_arr[1]
        let l:dict.col = l:res_arr[2]
        let l:dict.text = join(l:res_arr[3:], ':')

        call setqflist([l:dict], 'a')
      endif
    endfor
  endif
endfunction
