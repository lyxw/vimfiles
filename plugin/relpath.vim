" Experimental path manipulation
" ------------------------------
" (not runtime, see `:h path`, `:h path` and `:h suffixesadd`)
"
" It's all about getting the :find and `gf` mapping to work with relative
" dependencies, such as in an AMD or node (commonjs style) project. It's not
" strictly related to .js files though, any file extension is treated the
" same. `.coffee` script files should work. As long as the file below the
" cursor refers to a file relative to the current buffer, this should work.

" This update the `path` option to include both the working directory (as :pwd
" returns) and the relative to the current buffer working directory.
function! s:updatePath()
  " dirname of the current buffer
  let bufpath = expand('%:h')

  " add the current buffer dirname
  let &path = join([&path, bufpath . '/'], ',')
  
  " and the actual current working directory
  let &path = join([&path, getcwd() . '/'], ',')
endfunction

" udpate the suffixesadd option (:h 'suffixesadd') to include the current
" buffer extension, whatever it is.
function! s:updateSuffixAdd()
  " get the current buffer extension
  let ext = '.' . expand('%:e')

  " when no extensions (case of scripts with shebang), try to guess
  " extension from filetype
  if ext == '.'
    let ft = &filetype
    if ft == 'javascript'
      let ext = '.js'
    else
      let ext = '.' . &filetype
    endif
  endif

  " first make sure we don't add extensions twice
  " remove the ext, from the path option, if it was added before
  let &suffixesadd = substitute(&suffixesadd, "," . ext, '', '')
  " and add the new one
  let &suffixesadd = join([&suffixesadd, ext], ',')
endfunction

augroup updatepath
  autocmd!
  autocmd BufNewFile,BufEnter  * call s:updatePath()
  autocmd BufNewFile,BufEnter  * call s:updateSuffixAdd()
augroup END