"""" Basic settings

" Source the vimrc file after saving it
"if has("autocmd")
"  autocmd bufwritepost .vimrc source $MYVIMRC
"endif

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


"""" Vroom

set copyindent
set expandtab
set exrc
set nocursorcolumn
set nocursorline
set paste
set preserveindent
set shiftwidth=4
set showcmd
set smartindent
set softtabstop=0
set tabstop=4
set textwidth=76
set whichwrap=<,>,h,l,[,]
set modeline

"""" Turn on display of certain invisible characters
set list!
set listchars=trail:.,nbsp:%

""""" Titlebar
set title " Turn on titlebar support


"""" Searching and Patterns
set ignorecase " Default to using case insensitive searches,
set smartcase " unless uppercase letters are used in the regex.
set hlsearch " Highlight searches by default.
set incsearch " Incrementally search while typing a /regex

"""" Have 3 lines of offset (or buffer) when scrolling
set scrolloff=3

"""" Moving Around/Editing
set nostartofline " Avoid moving cursor to BOL when jumping around
set whichwrap=b,s,h,l,<,> " <BS> <Space> h l <Left> <Right> can change lines
set virtualedit=block " Let cursor move past the last char in <C-v> mode
set scrolloff=3 " Keep 3 context lines above and below the cursor
set backspace=2 " Allow backspacing over autoindent, EOL, and BOL
set showmatch " Briefly jump to a paren once it's balanced
set matchtime=2 " (for only .2 seconds).

""""" Encoding/Multibyte
if has('multi_byte') " If multibyte support is available and
  if &enc !~? 'utf-\=8' " the current encoding is not Unicode,
    if empty(&tenc) " default to
      let &tenc = &enc " using the current encoding for terminal output
    endif " unless another terminal encoding was already set
    set enc=utf-8 " but use utf-8 for all data internally
  endif
endif


"""" Display
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




"""" Perl stuff
" check perl code with :make
autocmd FileType perl set autoindent
autocmd FileType perl set autowrite
autocmd FileType perl set equalprg=perltidy
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set expandtab
autocmd FileType perl set makeprg=perl\ -c\ %\ $*
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

"""" perlomni key-combo is annoying when using screen -e ^Oo
"autocmd FileType perl nnoremap <C-x><C-o> <C-x>-


highlight OverLength ctermbg=red ctermfg=white guibg=#FFD9D9
match OverLength /\>%79v.\+/

if exists('+colorcolumn')
  set colorcolumn=78
else
  autocmd BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>79v.\+', -1)
endif


"""" Treat *.conf files as Apache config files
autocmd BufNewFile,BufRead *.conf set filetype=apache
autocmd BufNewFile,BufRead *.tpl set filetype=tt2
autocmd BufNewFile,BufRead *.ttml set filetype=tt2html
autocmd BufNewFile,BufRead *.conf.tpl set filetype=tt2.apache



"""" Mouse stuff
:set mouse=a


" make tab in v mode ident code
vmap <tab> >gv
vmap <s-tab> <gv
" make tab in normal mode ident code
nmap <tab> I<tab><esc>
nmap <s-tab> ^i<bs><esc>
" paste mode - this will avoid unexpected effects when you
" cut or copy some text from one window and paste it in Vim.
set pastetoggle=<F9>
" comment/uncomment blocks of code (in vmode)
vmap _c :s/^/#/gi<Enter>
vmap _C :s/^#//gi<Enter>
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
let perl_include_pod   = 1   "include pod.vim syntax file with perl.vim"
let perl_extended_vars = 1   "highlight complex expressions such as @{[$x, $y]}"
let perl_sync_dist     = 250 "use more context for highlighting"


"""" supertab
let g:SuperTabDefaultCompletionType = "context"

"""" closetag
autocmd FileType html,ep,tt2 let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,conf,ep,tt2 source ~/.vim/bundle/closetag/plugin/closetag.vim

"""" tagbar
let g:tagbar_usearrows = 1
nnoremap <F3> :TagbarToggle<CR>

set tags=./tags,../tags


"""" solarized
set background=dark
set bg=dark
let g:solarized_termtrans=1
let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_visibility="normal"
let g:solarized_degrade=1
let g:solarized_bold=1
let g:solarized_underline=1
let g:solarized_italic=1
colorscheme solarized


"""" delimitmate
let delimitMate_autoclose = 1

