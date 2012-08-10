if exists("did\_load\_filetypes")
    finish
endif

augroup filetypedetect
au BufNewFile,BufRead *.xt  setf xt
augroup ENDA


augroup markdown
au! BufRead,BufNewFile *.mdown   setfiletype mdown
augroup END


