if exists("g:current_compiler")
  finish
endif
let g:current_compiler = "golangcilint"

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:save_cpo = &cpo
set cpo-=C

CompilerSet makeprg=make\ lint
CompilerSet errorformat =%f:%l:%c:\ %m " matches filename:linenum:colnum <message>
CompilerSet errorformat+=%C%*\\s%m     " multiline continuations are indented
CompilerSet errorformat+=%-G%.%#       " discard any lines that don't match the above

let &cpo = s:save_cpo
unlet s:save_cpo
