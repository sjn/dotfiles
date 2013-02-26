
"""" Only do stuff if we have a recent version of vim
if version >= 700

"""" Load pathogen
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
filetype on
filetype plugin on
filetype indent on

"""" Tab navigation
map <C-S-]> gt
map <C-S-[> gT
map <C-1> 1gt
map <C-2> 2gt
map <C-3> 3gt
map <C-4> 4gt
map <C-5> 5gt
map <C-6> 6gt
map <C-7> 7gt
map <C-8> 8gt
map <C-9> 9gt
map <C-0> :tablast<CR>


"""" Basic settings
set copyindent
set expandtab
set exrc  "for Vroom::Vroom"
set modeline
set nocursorcolumn
set nocursorline
set paste
set preserveindent
"set shiftwidth=2
set shiftwidth=4
set shiftround
set showcmd
set smartindent
set softtabstop=0
"set tabstop=2
set tabstop=4
set textwidth=76
"set whichwrap=<,>,h,l,[,]
set ww=<,>,[,],h,l,b,s,~


"""" Turn on display of certain invisible characters
set list!
set listchars=trail:.,tab:\ \ ,nbsp:%

""""" Titlebar
set title " Turn on titlebar support

"""" Searching and Patterns
set ignorecase " Default to using case insensitive searches,
set smartcase " unless uppercase letters are used in the regex.
set infercase " Handle case in a smart way in autocompletes
set hlsearch " Highlight searches by default.
set incsearch " Incrementally search while typing a /regex
set showfulltag " Show full tag completions
set complete=.,w,b,u,U,d,k,t " Better completion, full tags last, no ',i'

"""" Suffixes that get lower priority when doing tab completion for
"""" filenames. These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,CVS/,tags

"""" Status line
set statusline=%<%f\ %y[%{&ff}]%m%r%w%a\ %=%l/%L,%c%V\ %P

"""" Moving Around/Editing
set nostartofline " Avoid moving cursor to BOL when jumping around
set whichwrap=b,s,h,l,<,> " <BS> <Space> h l <Left> <Right> can change lines
set virtualedit=block " Let cursor move past the last char in <C-v> mode
set scrolloff=3 " Keep 3 context lines above and below the cursor
set backspace=indent,eol,start
set showmatch " Briefly jump to a paren once it's balanced
set matchtime=2 " (for only .2 seconds).
set ss=1
set siso=9

"""" Cursor keys use screen lines
map <up> gk
imap <up> <c-o>gk
map <down> gj
imap <down> <c-o>gj

"""" Easy wrap, line numbers & list mode toggle
map <F4> :setlocal wrap!<CR>
imap <F4> <c-o>:setlocal wrap!<CR>
map <F5> :setlocal list!<CR>
imap <F5> <c-o>:setlocal list!<CR>
map <F6> :setlocal nu!<CR>
imap <F6> <c-o>:setlocal nu!<CR>
map <F1> :b #<CR>
imap <F1> <c-o>:b #<CR>

"""" Use * and # in visual mode
vmap <silent> * :<C-U>let old_reg=@"<cr>gvy/<C-R>"<cr>:let @"=old_reg<cr><C-L>
vmap <silent> # :<C-U>let old_reg=@"<cr>gvy?<C-R>"<cr>:let @"=old_reg<cr><C-L>

"""" Wildmenu
set wildmenu              " Wild menu!
set wildmode=longest,full " First match the longest common string, then full
set wildignore=*.bak,*.o,*.e,*~

"""" Status bar
set laststatus=2 " Always show status bar

"""" Mouse, Keyboard, Terminal
set mouse=a         " Allow mouse use in normal and visual mode.
set ttymouse=xterm2 " Most terminals send modern xterm mouse reporting
                    " but this isn't always detected in GNU Screen.
set timeoutlen=2000 " Wait 2 seconds before timing out a mapping
set ttimeoutlen=100 " and only 100 ms before timing out on a keypress.
set lazyredraw      " Avoid redrawing the screen mid-command.
set ttyscroll=3     " Prefer redraw to scrolling for more than 3 lines


""""" Titlebar
set title " Turn on titlebar support


""""" Encoding/Multibyte
if has('multi_byte') " If multibyte support is available and
    if &enc !~? 'utf-\=8' " the current encoding is not Unicode,
        if empty(&tenc) " default to
            let &tenc = &enc " using the current encoding for terminal output
        endif " unless another terminal encoding was already set
        set enc=utf-8 " but use utf-8 for all data internally
    endif
endif


"""" When on an UTF-8 display, use fancyer characters
if &enc =~ '^u\(tf\|cs\)' " When running in a Unicode environment,
    set list " visually represent certain invisible characters:
    let s:arr = nr2char(9655) " using U+25B7 (▷) for an arrow, and
    let s:dot = nr2char(8901) " using U+22C5 (⋅) for a very light dot,
    " display tabs as an arrow followed by some dots (▷⋅⋅⋅⋅⋅⋅⋅),
    exe "set listchars=tab:" . s:arr . s:dot
    " and display trailing and non-breaking spaces as U+22C5 (⋅).
    exe "set listchars+=trail:" . s:dot
    exe "set listchars+=nbsp:" . s:dot
endif


"""" Some Emacs bindings for the command window
cnoremap <C-A> <Home>
cnoremap <ESC>b <S-Left>
cnoremap <ESC>f <S-Right>
cnoremap <ESC><BS> <C-W>

"""" Makefile stuff
autocmd FileType make setlocal listchars+=tab:\ \ 
autocmd FileType make setlocal noexpandtab
"autocmd FileType make

"""" Perl stuff
autocmd FileType perl set autoindent
autocmd FileType perl set equalprg=perltidy
autocmd FileType perl set expandtab
autocmd FileType perl set number
autocmd FileType perl set shiftwidth=4
autocmd FileType perl set showmatch
autocmd FileType perl set smartindent
autocmd FileType perl set softtabstop=0
"autocmd FileType perl set softtabstop=4
autocmd FileType perl set tabstop=4
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
autocmd FileType perl let g:nerdtree_tabs_open_on_console_startup=1
map <F2> <plug>NERDTreeTabsToggle<CR>
" check perl code with :make
autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite

"""" perlomni key-combo is annoying when using screen -e ^Oo
"autocmd FileType perl nnoremap <C-x><C-o> <C-x>-


"highlight OverLength ctermbg=red ctermfg=white guibg=#FFD9D9
"match OverLength /\>%79v.\+/

if exists('+colorcolumn')
    set colorcolumn=76
endif


"""" Treat *.conf files as Apache config files
autocmd BufNewFile,BufRead *.conf set filetype=apache
autocmd BufNewFile,BufRead *.tpl set filetype=tt2
autocmd BufNewFile,BufRead *.ttml set filetype=tt2html
autocmd BufNewFile,BufRead *.conf.tpl set filetype=tt2.apache


" paste mode - this will avoid unexpected effects when you
" cut or copy some text from one window and paste it in Vim.
set pastetoggle=<F9>
" comment/uncomment blocks of code (in vmode)
vmap _c :s/^/#/<Enter>
vmap _C :s/^#//<Enter>
" my perl includes pod
let perl_include_pod = 1
" syntax color complex things like @{${"foo"}}
let perl_extended_vars = 1
" Tidy selected lines (or entire file) with _t:
nnoremap <silent> _t :%!perltidy -q<Enter>
vnoremap <silent> _t :!perltidy -q<Enter>
" Deparse obfuscated code
nnoremap <silent> _d :.!perl -MO=Deparse 2>/dev/null<cr>
vnoremap <silent> _d :!perl -MO=Deparse 2>/dev/null<cr>
let perl_include_pod = 1 "include pod.vim syntax file with perl.vim"
let perl_extended_vars = 1 "highlight complex expressions such as @{[$x, $y]}"
let perl_sync_dist = 250 "use more context for highlighting"


"""" supertab
"let g:SuperTabDefaultCompletionType = "context"

"""" closetag
autocmd FileType html,ep,tt2 let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,conf,ep,tt2 source ~/.vim/bundle/closetag/plugin/closetag.vim

"""" tagbar
nnoremap <F3> :TagbarToggle<CR>
let g:tagbar_usearrows = 1
let TE_Ctags_Path = 'exuberant-ctags'
nnoremap <silent> <F7> :TagExplorer<CR>
nnoremap <silent> <F8> :Tlist<CR>

set tags=./tags,../tags


"""" solarized
set background=dark
let g:solarized_termtrans=1
let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_visibility="high"
let g:solarized_degrade=1
let g:solarized_bold=1
let g:solarized_underline=1
let g:solarized_italic=1
colorscheme solarized

"""" delimitmate
let delimitMate_autoclose=1

let g:use_zen_complete_tag=1

"""" Vim history
set history=512     " Set history size
set viminfo='10,\"100,:20,%,n~/.viminfo
set showcmd         " Show (partial) command in status line.
set sm              " Show matching parens
set title


"""" Tab Wrapper stuff from https://github.com/yanick/environment/blob/master/vim/vimrc
function InsertTabWrapper()
   let col = col('.') - 1
   if !col || getline('.')[col - 1] !~ '\k'
       return "\<tab>"
   else
       return "\<c-p>"
   endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper()<cr>
" cute ai toggle
map ,<TAB> :set ai!<CR>:set ai?<CR>


" Fast switching between buffers
" The current buffer will be saved before switching to the next one.
map  <silent> <s-tab> <Esc>:if &modifiable && !&readonly &&
     \ &modified <CR> :write<CR> :endif<CR>:bnext<CR>
imap <silent> <s-tab> <Esc>:if &modifiable && !&readonly &&
     \ &modified <CR> :write<CR> :endif<CR>:bnext<CR>



" insert mode : autocomplete brackets and braces
imap ( ()<Left>
imap [ []<Left>
imap { {}<Left>


" visual mode : frame a selection with brackets and braces
vmap ( d<Esc>i(<Esc>p
vmap [ d<Esc>i[<Esc>p
vmap { d<Esc>i{<Esc>p

"""" End of vim 7.0 block
endif

