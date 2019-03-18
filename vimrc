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
set clipboard^=unnamed,unnamedplus                                    " yank and paste with the system clipboard
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
set colorcolumn=80
silent! colorscheme seoul256

filetype plugin indent on

" gui settings
if has("mac")
    set guifont=Monaco:h14
elseif has("win32")
    set guifont=Consolas:h12
elseif has("unix")
    set guifont=Monospace\ 11
endif

set guioptions-=m
set guioptions-=T

" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:ctrlp_lazy_update = 1
let g:ctrlp_show_hidden = 1
let g:NERDSpaceDelims=1
let g:gitgutter_enabled = 1
let g:gitgutter_grep = 'grep'
let g:go_fmt_command = "goimports"
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_autosave = 1

" fdoc is yaml
autocmd BufRead,BufNewFile *.fdoc set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
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
nnoremap <leader>z :FZF<CR>
nnoremap <leader>m :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
nnoremap <leader>] :TagbarToggle<CR>
nnoremap <leader><space> :call whitespace#strip_trailing()<CR>
nnoremap <leader>g :GitGutterToggle<CR>
nnoremap <leader>. :cd %:p:h<CR>:pwd<CR>

" vim-go specific
nnoremap <leader>c :GoDoc<CR>
nnoremap <leader>G :Goyo<CR>
autocmd FileType go nmap <silent> <Leader>d <Plug>(go-def-tab)
autocmd FileType go nmap <leader>b  <Plug>(go-build)

nnoremap <leader>J :%!python -c "import json, sys, collections; print json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), indent=4)"<CR>
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
inoremap jj <ESC>

" vim-go shortcuts
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" in case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %

" format sql line
nnoremap <leader>q :%!sqlformat --reindent --keywords upper --identifiers lower -<CR>

" markdown preview
let g:previm_open_cmd = 'open -a Google\ Chrome'
let g:previm_enable_realtime = 1
