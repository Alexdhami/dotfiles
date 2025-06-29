" --------------------------- Auto-install vim-plug ---------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent! !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" --------------------------- Plugin Section ---------------------------
call plug#begin('~/.vim/plugged')

" 1. Auto pairs (for brackets, quotes, etc.)
Plug 'jiangmiao/auto-pairs'

" Install  Themes 



" Jedi-Vim: Python autocompletion, go-to-definition, and code analysis with Jedi.
"Plug 'davidhalter/jedi-vim'

" 2. Auto-completion with CoC (Language Server Protocol support)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Note: Run :CocInstall coc-pyright for Python support

call plug#end()

" --------------------------- Plugin Configs ---------------------------
" Enable auto-completion in coc.nvim
autocmd FileType python setlocal completeopt=menuone,noinsert,noselect
let g:coc_global_extensions = ['coc-pyright']

" Enable auto-trigger of completion as you type
let g:coc_config_home = expand('~/.config/coc')

" ❗ Fix conflict: Disable Auto-Pairs handling <CR> so CoC can use it
let g:AutoPairsMapCR = 0


" Auto-Pairs config

let g:AutoPairs = {'(':')', '[':']', '{':'}', "'":"'", '"':'"'}
let g:AutoPairsMapQuote = 1
let g:AutoPairsMapBS = 1
let g:AutoPairsMapCh = 1


" Use Python 3 from the current virtual environment (myenv)
" {Use which python3 to check your directory Where it is located }
let g:python3_host_prog = '/home/alex2/Documents/Python/myenv/bin/python3'



" Theme Set
set background=dark


" --------------------------- Editor UI Settings ---------------------------

" Show line numbers
set number
set relativenumber

" Fast key timeout for mappings
set timeoutlen=300

" --------------------------- Custom Keybindings ---------------------------

" Quick escape from insert mode using 'jj' or 'kk'
inoremap jj <Esc>
inoremap kk <Esc>
" Ctrl+Backspace to delete previous word
inoremap <C-BS> <C-W>

"Ctrl F  to replace words:
" Those three lefts are used to shift your cursor 3 times left 
inoremap <C-F> <Esc>:%s///g<Left><Left><Left>

" Press Enter to confirm CoC completion if popup is visible, otherwise insert newline
inoremap <silent><expr> <CR> pumvisible() ? coc#pum#confirm() : "\<CR>"

" Ctrl+Enter in normal mode: save and run Python file
nnoremap <C-CR> :w<CR>:!python3 %<CR>

" Tab / Shift-Tab for navigating completion menu
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

