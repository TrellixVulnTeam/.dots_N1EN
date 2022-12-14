if exists("g:current_compiler")
  finish
endif
let g:current_compiler = "gosshtest"

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:save_cpo = &cpo
set cpo-=C

CompilerSet makeprg=go\ test

" Stolen from vim-go:
" -------------------
CompilerSet errorformat =%-G#\ %.%#                                 " Ignore lines beginning with '#' ('# command-line-arguments' line sometimes appears?)
CompilerSet errorformat+=%-G%.%#panic:\ %m                          " Ignore lines containing 'panic: message'
CompilerSet errorformat+=%Ecan\'t\ load\ package:\ %m               " Start of multiline error string is 'can\'t load package'
CompilerSet errorformat+=%A%\\%%(%[%^:]%\\+:\ %\\)%\\?%f:%l:%c:\ %m " Start of multiline unspecified string is 'filename:linenumber:columnnumber:'
CompilerSet errorformat+=%A%\\%%(%[%^:]%\\+:\ %\\)%\\?%f:%l:\ %m    " Start of multiline unspecified string is 'filename:linenumber:'
CompilerSet errorformat+=%C%*\\s%m                                  " Continuation of multiline error message is indented
CompilerSet errorformat+=%-G%.%#                                    " All lines not matching any of the above patterns are ignored

let &cpo = s:save_cpo
unlet s:save_cpo
