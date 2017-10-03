" don't bother with vi compatibility
set nocompatible

" enable syntax highlighting
syntax enable

" install Plug bundles
if filereadable(expand("~/.vimrc.plugs"))
  source ~/.vimrc.plugs
endif

set autoindent
set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                                              " Fix broken backspace in some setups
set backupcopy=yes
set clipboard=unnamedplus                                    " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab                                                " expand tabs to spaces
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:·,precedes:←,extends:→
set number                                                   " show line numbers
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set shiftwidth=4                                             " normal mode indentation commands use 2 spaces
set showcmd
set smartcase                                                " case-sensitive search if any caps
set softtabstop=4                                            " insert mode tab and backspace use 2 spaces
set tabstop=4                                                " actual tabs occupy 4 characters
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list,full
set nocursorline
set hlsearch
set tabpagemax=100
set nohidden
set ttyfast
set secure
set showmatch
set t_Co=256
silent! colorscheme seoul256

filetype plugin indent on

" gvim settings
set guifont=Monospace\ 11
set guioptions-=m
set guioptions-=T

" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:ctrlp_lazy_update = 1
let g:ctrlp_show_hidden = 1
let g:NERDSpaceDelims=1
let g:gitgutter_enabled = 0
let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 1
let g:syntastic_go_checkers = ["go"]

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" --hidden --ignore "\.git$\|\.hg$\|\.svn|\.pyc$"'
  let g:ctrlp_use_caching = 0
endif

" fdoc is yaml
autocmd BufRead,BufNewFile *.fdoc set filetype=yaml
" md is markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.md set spell

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" limit commit message to 72 characters
autocmd Filetype gitcommit setlocal spell textwidth=72

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

" Shortcuts
let mapleader = ','
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <leader>l :Align
nnoremap <leader>a :Ag<space>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
nnoremap <leader>] :TagbarToggle<CR>
nnoremap <leader><space> :call whitespace#strip_trailing()<CR>
nnoremap <leader>g :GitGutterToggle<CR>
nnoremap <leader>. :cd %:p:h<CR>:pwd<CR>
nnoremap <leader>c :GoDoc<CR>
nnoremap <leader>G :Goyo<CR>
nnoremap <leader>J :%!python -c "import json, sys, collections; print json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), indent=4)"<CR>
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
inoremap jj <ESC>

" in case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %
