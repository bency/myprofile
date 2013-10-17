" Last Update:2013/10/17 12:11:09
set bg=dark

set et

set nowrap

syntax on

set bs=2

set nowrap

set cursorline

set hlsearch

set ruler

set modeline

set autoindent

set enc=utf-8

"set showtabline=2

set tabpagemax=25

let g:cssColorVimDoNotMessMyUpdatetime = 1

if has("autocmd")

  " Drupal *.mod and *.inc and *.module and *.install files.

  augroup module

    autocmd BufRead,BufNewFile *.php    set filetype=php

    autocmd BufRead,BufNewFile *.module set filetype=php

    autocmd BufRead,BufNewFile *.mod    set filetype=php

    autocmd BufRead,BufNewFile *.inc    set filetype=php

    autocmd BufRead,BufNewFile *.install set filetype=php

    autocmd BufRead,BufNewFile *.test   set filetype=php

    autocmd BufRead,BufNewFile *.xaml   set filetype=xml

    autocmd BufRead,BufNewFile *.css    set shiftwidth=2

    autocmd BufRead,BufNewFile *.html   set shiftwidth=2

  augroup END

endif

highlight User1 ctermfg=red

highlight User2 term=underline cterm=underline ctermfg=green

highlight User3 term=underline cterm=underline ctermfg=yellow

highlight User4 term=underline cterm=underline ctermfg=white

highlight User5 ctermfg=cyan

highlight User6 ctermfg=white

function! AutoUpdateTheLastUpdateInfo()

    let s:original_pos = getpos(".")

    let s:regexp = "^\\s*\\([#\\\"\\*]\\|\\/\\/\\)\\s\\?[lL]ast \\([uU]pdate\\|[cC]hange\\):"

    let s:lu = search(s:regexp)

    if s:lu != 0

        let s:update_str = matchstr(getline(s:lu), s:regexp)

        call setline(s:lu, s:update_str . strftime("%Y/%m/%d %H:%M:%S"))

        call setpos(".", s:original_pos)

    endif

endfunction

autocmd BufWritePre * call AutoUpdateTheLastUpdateInfo()

"replace the current word in all opened buffers

fun! Replace()

    let s:word = input("Replace " . expand('<cword>') . " with:")

    :exe 'bufdo! %s/\<' . expand('<cword>') . '\>/' . s:word . '/ge'                                                            
    :unlet! s:word

endfun

map <leader>r :call Replace()<CR>

" --- move around splits {

" move to and maximize the below split

map <C-J> <C-W>j<C-W>_

" move to and maximize the above split

map <C-K> <C-W>k<C-W>_

" move to and maximize the left split

nmap <c-h> <c-w>h<c-w><bar>

" move to and maximize the right split 

nmap <c-l> <c-w>l<c-w><bar>

set wmw=0                     " set the min width of a window to 0 so we can maximize others

set wmh=0                     " set the min height of a window to 0 so we can maximize others

" }

" C/C++ specific settings

autocmd FileType c,cpp,cc  set cindent comments=sr:/*,mb:*,el:*/,:// cino=>s,e0,n0,f0,{0,}0,^-1s,:0,=s,g0,h1s,p2,t0,+2,(2,)20,*30



"Restore cursor to file position in previous editing session

set viminfo='10,\"100,:20,%,n~/.viminfo

au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" auto reload vimrc when editing it

autocmd! bufwritepost .vimrc source ~/.vimrc

set autoread        " auto read when file is changed from outside

set wildchar=<TAB>  " start wild expansion in the command line using <TAB>

set wildmenu        " wild char completion menu

set autoindent      " auto indentation

set incsearch       " incremental search

set nobackup        " no *~ backup files

set noswapfile      " no *.swp file

set copyindent      " copy the previous indentation on autoindenting

set ignorecase      " ignore case when searching

set smartcase       " ignore case if search pattern is all lowercase,case-sensitive otherwise

set smarttab        " insert tabs on the start of a line according to context

" move around tabs. conflict with the original screen top/bottom

" comment them out if you want the original H/L

" go to prev tab

map <S-H> gT

" go to next tab

map <S-L> gt

" new tab

"map <C-t><C-t> :tabnew<CR>

" close tab

"map <C-t><C-w> :tabclose<CR>

nnoremap <silent> <C-t><S-H> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>

nnoremap <silent> <C-t><S-L> :execute 'silent! tabmove ' . tabpagenr()<CR>

" :cd. change working directory to that of the current file

cmap cd. lcd %:p:h

colo desert

set t_Co=256

set ts=4 sw=4 st=4

let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size  = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=gray
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=darkgray

" status bar

set laststatus=2

set statusline=%2*%m

set statusline+=%4*%<\%5*[%{&encoding}, " encoding

set statusline+=%{&fileformat}] " file format

set statusline+=%4*\ %1*[%F]

set statusline+=%4*%=\ %6*%y%4*\ %3*%l%4*,\ %3*%c%4*\ \<\ %2*%P%4*\ \>

" auto git pull and reload files in current vim procedure

fun! PullAndRefresh()
    set noconfirm
    !git pull
    bufdo e!
    set confirm
    endfun

nmap <leader>gr call PullAndRefresh()
