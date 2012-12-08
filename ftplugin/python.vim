" Special definitions for python files

set omnifunc=pythoncomplete#Complete


let s:py_version = system("python --version")
let s:py_version = strpart(s:py_version, 7) " Remove 'Python '
let s:py_version = strpart(s:py_version, 0, 3) " Keep only the major version

let s:py_path="/usr/lib/python" . s:py_version .
    \ "," . "/usr/lib/python" . s:py_version . "/site-packages"

let &path=&path . "," . s:py_path

" This is incredibly helpful...
abbreviate <buffer> sefl self
abbreviate <buffer> slef self

" To use quickfix with python programs:
if executable("pyflakes")
  setlocal makeprg=pyflakes\ %
endif


" Indent with 4 spaces
setlocal expandtab
setlocal smarttab
setlocal shiftwidth=4
setlocal tabstop=4
setlocal softtabstop=4


""
" Using custom python plugins in plugins/py.*.vim

" Add an "import" line using work under cursor
nmap <leader>I :call AddMissingImport('<C-R><C-W>') <CR>

" Run pytest
nmap <leader>k :call vimpytest#run()<CR>

" Switch between test and production code
command! -nargs=0 A :call vimpytest#alternate()
