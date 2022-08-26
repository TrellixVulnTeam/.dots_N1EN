
function! statusline#GetColumnNumber()
  return col(".")
endfunction

function statusline#active()
  setlocal statusline=
  setlocal statusline+=%1*\ %f:%l:
  setlocal statusline+=%{statusline#GetColumnNumber()}
  setlocal statusline+=%M\ %0*
  setlocal statusline+=%2*\ %=
  setlocal statusline+=%=
  setlocal statusline+=%1*
  setlocal statusline+=\ %{pathshorten(getcwd())}
  setlocal statusline+=\ %y
endfunction

function! statusline#insert()
  setlocal statusline=
  setlocal statusline+=%3*
  setlocal statusline+=%3*\ %f:%l:
  setlocal statusline+=%{statusline#GetColumnNumber()}
  setlocal statusline+=%M\ %0*
  setlocal statusline+=%2*\ %=
  setlocal statusline+=%=
  setlocal statusline+=%3*
  setlocal statusline+=\ %{pathshorten(getcwd())}
  setlocal statusline+=\ %y
endfunction

function! statusline#inactive()
  setlocal statusline=
  setlocal statusline+=\ %f:%l:
  setlocal statusline+=%{statusline#GetColumnNumber()}
  setlocal statusline+=%M
  setlocal statusline+=%=
  setlocal statusline+=%=
  setlocal statusline+=\ %{pathshorten(getcwd())}
  setlocal statusline+=\ %y
endfunction
