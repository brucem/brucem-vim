set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set smartcase
nnoremap <F6> <C-W>w
nnoremap <S-F6> <C-W>W
nnoremap <C-N> :next<CR>
"nnoremap <C-P> :prev<CR>
vnoremap <C-T> >
vnoremap <C-D> <LT>
vmap <Tab> <C-T>
vmap <S-Tab> <C-D>
syn on 


augroup mdown
    autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:>
augroup END

source ~/.vim/php-doc.vim
imap <C-o> :set paste<CR>:exe PhpDoc()<CR>:set nopaste<CR>i

inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR> 

iab phpb exit("<hr>Debug     ");
iab phpv echo "<hr><pre>";var_dump($a);exit("debug ");
iab phpbb exit("<hr>Debug <C-R>a  ");
iab phpvv echo "<hr><pre>";var_dump(<C-R>a);exit("debug "); 

iab phpd print '<pre>';<CR>print_r($this);<CR>print '</pre>';<CR>
iab ezd  eZDebug::writeDebug(  );<CR>

" * Spelling

" define `Ispell' language and personal dictionary, used in several places
" below:
let IspellLang = 'british'
let PersonalDict = '~/.ispell_' . IspellLang

" try to avoid misspelling words in the first place -- have the insert mode
" <Ctrl>+N/<Ctrl>+P keys perform completion on partially-typed words by
" checking the Linux word list and the personal `Ispell' dictionary; sort out
" case sensibly (so that words at starts of sentences can still be completed
" with words that are in the dictionary all in lower case):
execute 'set dictionary+=' . PersonalDict
set dictionary+=/usr/dict/words
set complete=.,w,k
set infercase

" correct my common typos without me even noticing them:
abbreviate teh the
abbreviate spolier spoiler
abbreviate Comny Conmy
abbreviate atmoic atomic

" Spell checking operations are defined next.  They are all set to normal mode
" keystrokes beginning \s but function keys are also mapped to the most common
" ones.  The functions referred to are defined at the end of this .vimrc.

" \si ("spelling interactive") saves the current file then spell checks it
" interactively through `Ispell' and reloads the corrected version:
execute 'nnoremap \si :w<CR>:!ispell -x -d ' . IspellLang . ' %<CR>:e<CR><CR>'

" \sl ("spelling list") lists all spelling mistakes in the current buffer,
" but excludes any in news/mail headers or in ("> ") quoted text:
execute 'nnoremap \sl :w ! grep -v "^>" <Bar> grep -E -v "^[[:alpha:]-]+: " ' .
  \ '<Bar> ispell -l -d ' . IspellLang . ' <Bar> sort <Bar> uniq<CR>'

" \sh ("spelling highlight") highlights (in red) all misspelt words in the
" current buffer, and also excluding the possessive forms of any valid words
" (EG "Lizzy's" won't be highlighted if "Lizzy" is in the dictionary); with
" mail and news messages it ignores headers and quoted text; for HTML it
" ignores tags and only checks words that will appear, and turns off other
" syntax highlighting to make the errors more apparent [function at end of
" file]:
nnoremap \sh :call HighlightSpellingErrors()<CR><CR>
nmap <F9> \sh

" \sc ("spelling clear") clears all highlighted misspellings; for HTML it
" restores regular syntax highlighting:
nnoremap \sc :if &ft == 'html' <Bar> sy on <Bar>
  \ else <Bar> :sy clear SpellError <Bar> endif<CR>
nmap <F10> \sc

" \sa ("spelling add") adds the word at the cursor position to the personal
" dictionary (but for possessives adds the base word, so that when the cursor
" is on "Ceri's" only "Ceri" gets added to the dictionary), and stops
" highlighting that word as an error (if appropriate) [function at end of
" file]:
nnoremap \sa :call AddWordToDictionary()<CR><CR>
nmap <F8> \sa


" * Keystrokes -- Moving Around

" have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do
" by default), and ~ covert case over line breaks; also have the cursor keys
" wrap in insert mode:
set whichwrap=h,l,~,[,]

" page down with <Space> (like in `Lynx', `Mutt', `Pine', `Netscape Navigator',
" `SLRN', `Less', and `More'); page up with - (like in `Lynx', `Mutt', `Pine'),
" or <BkSpc> (like in `Netscape Navigator'):
" noremap <Space> <PageDown>
noremap <BS> <PageUp>
noremap - <PageUp>
" [<Space> by default is like l, <BkSpc> like h, and - like k.]

" scroll the window (but leaving the cursor in the same place) by a couple of
" lines up/down with <Ins>/<Del> (like in `Lynx'):
noremap <Ins> 2<C-Y>
noremap <Del> 2<C-E>
" [<Ins> by default is like i, and <Del> like x.]

" use <F6> to cycle through split windows (and <Shift>+<F6> to cycle backwards,
" where possible):
nnoremap <F6> <C-W>w
nnoremap <S-F6> <C-W>W

" use <Ctrl>+N/<Ctrl>+P to cycle through files:
nnoremap <C-N> :next<CR>
nnoremap <C-P> :prev<CR>
" [<Ctrl>+N by default is like j, and <Ctrl>+P like k.]

" have % bounce between angled brackets, as well as t'other kinds:
set matchpairs+=<:>

" have <F1> prompt for a help topic, rather than displaying the introduction
" page, and have it do this from any mode:
nnoremap <F1> :help<Space>
vmap <F1> <C-C><F1>
omap <F1> <C-C><F1>
map! <F1> <C-C><F1>


" * Keystrokes -- Formatting

" have Q reformat the current paragraph (or selected text if there is any):
nnoremap Q gqap
vnoremap Q gq

" have the usual indentation keystrokes still work in visual mode:
vnoremap <C-T> >
vnoremap <C-D> <LT>
vmap <Tab> <C-T>
vmap <S-Tab> <C-D>

" have Y behave analogously to D and C rather than to dd and cc (which is
" already done by yy):
noremap Y y$


function! HighlightSpellingErrors()
" highlights spelling errors in the current window; used for the \sh operation
" defined above;
" requires the ispell, sort, and uniq commands to be in the path;
" requires the global variable IspellLang to be defined above, and to contain
" the preferred `Ispell' language;
" for mail/news messages, requires the grep command to be in the path;
" for HTML documents, saves the file to disk and requires the lynx command to
" be in the path
"
" by Smylers  http://www.stripey.com/vim/
" (inspired by Krishna Gadepalli and Neil Schemenauer's vimspell.sh)
" 
" 2000 Jun 1: for `Vim' 5.6

  " for HTML files, remove all current syntax highlighting (so that
  " misspellings show up clearly), and note it's HTML for future reference:
  if &filetype == 'html'
    let HTML = 1
    syntax clear

  " for everything else, simply remove any previously-identified spelling
  " errors (and corrections):
  else
    let HTML = 0
    if hlexists('SpellError')
      syntax clear SpellError
    endif
    if hlexists('Normal')
      syntax clear Normal
    endif
  endif

  " form a command that has the text to be checked piping through standard
  " output; for HTML files this involves saving the current file and processing
  " it with `Lynx'; for everything else, use all the buffer except quoted text
  " and mail/news headers:
  if HTML
    write
    let PipeCmd = '! lynx --dump --nolist % |'
  else
    let PipeCmd = 'write !'
    if &filetype == 'mail'
      let PipeCmd = PipeCmd . ' grep -v "^> " | grep -E -v "^[[:alpha:]-]+:" |'
    endif
  endif

  " execute that command, then generate a unique list of misspelt words and
  " store it in a temporary file:
  let ErrorsFile = tempname()
  execute PipeCmd . ' ispell -l -d '. g:IspellLang .
    \ ' | sort | uniq > ' . ErrorsFile

  " open that list of words in another window:
  execute 'split ' . ErrorsFile

  " for every word in that list ending with "'s", check if the root form
  " without the "'s" is in the dictionary, and if so remove the word from the
  " list:
  global /'s$/ execute 'read ! echo ' . expand('<cword>') .
    \ ' | ispell -l -d ' . g:IspellLang | delete
  " (If the root form is in the dictionary, ispell -l will have no output so
  " nothing will be read in, the cursor will remain in the same place and the
  " :delete will delete the word from the list.  If the root form is not in the
  " dictionary, then ispell -l will output it and it will be read on to a new
  " line; the delete command will then remove that misspelt root form, leaving
  " the original possessive form in the list!)

  " only do anything if there are some misspellings:
  if strlen(getline('.')) > 0

    " if (previously noted as) HTML, replace each non-alphanum char with a
    " regexp that matches either that char or a &...; entity:
    if HTML
      % substitute /\W/\\(&\\|\&\\(#\\d\\{2,4}\\|\w\\{2,8}\\);\\)/e
    endif

    " turn each mistake into a `Vim' command to place it in the SpellError
    " syntax highlighting group:
    % substitute /^/syntax match SpellError !\\</
    % substitute /$/\\>!/
  endif

  " save and close that file (so switch back to the one being checked):
  exit

  " make syntax highlighting case-sensitive, then execute all the match
  " commands that have just been set up in that temporary file, delete it, and
  " highlight all those words in red:
  syntax case match
  execute 'source ' . ErrorsFile
  call delete(ErrorsFile)
  highlight SpellError term=reverse ctermfg=DarkRed guifg=Red

  " with HTML, don't mark any errors in e-mail addresses or URLs, and ignore
  " anything marked in a fix-width font (as being computer code):
  if HTML
    syntax case ignore
    syntax match Normal !\<[[:alnum:]._-]\+@[[:alnum:]._-]\+\.\a\+\>!
    syntax match Normal
      \ !\<\(ht\|f\)tp://[-[:alnum:].]\+\a\(/[-_.[:alnum:]/#&=,]*\)\=\>!
    syntax region Normal start=!<Pre>! end=!</Pre>!
    syntax region Normal start=!<Code>! end=!</Code>!
    syntax region Normal start=!<Kbd>! end=!</Kbd>!
  endif

endfunction " HighlightSpellingErrors()

set nocompatible      " We're running Vim, not Vi!
syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
compiler ruby         " Enable compiler support for ruby

function! RunEztlint()
    let l:output=system('phpcs --standard=eZPublish '.bufname("%"))

    cexpr l:output
    cwindow
endfunction

set errorformat+="%f",%l,%c,%e,"%m"
command! Eztlint execute RunEztlint()

map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
set wmh=0
call pathogen#infect()
colorscheme solarized
if &diff
" vimdiff color scheme
  colorscheme jellybeans
  highlight DiffChange cterm=none ctermfg=black ctermbg=LightGreen gui=none guifg=bg guibg=LightGreen
  highlight DiffText cterm=none ctermfg=black ctermbg=Red gui=none guifg=bg guibg=Red
endif

