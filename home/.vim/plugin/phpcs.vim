" "/var/www/ezpublish-4.1.3/extension/phplist/datatypes/phplistsubscribe/phplistsubscribetype.php",237,1,error,"Spaces must be used to indent lines; tabs are not allowed",Generic.WhiteSpace.DisallowTabIndentSniff
function! RunPhpcs()
    let l:filename=@%
    let l:phpcs_output=system('phpcs --report=csv --standard=/home/brucem/ezcodesniffer/Codesniffer/Standards/eZPublish/ '.l:filename . '|uniq|sed s/\"//g|sed s/,warning,/,w,/|sed s/,error,/,e,/g' )
"    echo l:phpcs_output
    let l:phpcs_list=split(l:phpcs_output, "\n")
    unlet l:phpcs_list[0]
    unlet l:phpcs_list[1]
    cexpr l:phpcs_list
    cwindow
endfunction

set errorformat+=%f\\,%l\\,%c\\,%t\\,%m
command! Phpcs execute RunPhpcs()
