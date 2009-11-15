" SpacklePlugin 	Load a quickfix file via the Vim remote interface
" URL:						http://github.com/rleemorlang/spackle
"
"

if &cp || (exists("g:loaded_spackle") && g:loaded_spackle)
  finish
endif
let g:loaded_spackle = 1


function! LoadSpackleQuickfix(path)
  execute "cgetfile " a:path  
  echon "Loaded quickfix from '" a:path "'"
  cw
endfunction

