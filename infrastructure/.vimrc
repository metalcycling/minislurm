" Metalcycling's VIM Look
set nohlsearch
set number
set backspace=indent,eol,start
syntax enable
syntax on

colorscheme codedark

filetype plugin on

if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Set tab size
filetype indent on
set tabstop=4
set shiftwidth=4
set expandtab

" Remap 'jump to line' to 'jump to marker' 
nnoremap ' `

" Slime configuration 
let g:slime_target = 'screen'
let g:slime_python_ipython = 1
let g:slime_dont_ask_default = 1
let b:slime_config = { 'sessionname': $STY, 'windowname': 0 }

" IPython-cell configuration
nnoremap <Leader>s :SlimeSend1 ipython<CR>
nnoremap <Leader>d :SlimeSend1 %debug<CR>
nnoremap <Leader>q :SlimeSend1 exit<CR>
nnoremap <Leader>r :IPythonCellRun<CR>
nnoremap <Leader>R :IPythonCellRunTime<CR>
nnoremap <Leader>c :IPythonCellExecuteCell<CR>
nnoremap <Leader>C :IPythonCellExecuteCellJump<CR>
nnoremap <Leader>l :IPythonCellClear<CR>
nnoremap <Leader>x :IPythonCellClose<CR>

" Run compilation and run script
nnoremap <silent> <F6> :w<CR>:!clear; bash %;<CR>
nnoremap <silent> <F9> :w<CR>:!clear; bash run.sh;<CR>
nnoremap <silent> <F8> :w<CR>:!clear; python3 %;<CR>
nnoremap <silent> <F7> :w<CR>:!clear; bash ~/run.sh;<CR>
nnoremap <silent> <F5> :e!<CR>

" Nek5000
syntax on
filetype on
au BufNewFile,BufRead *.usr set filetype=fortran

" OCCA
syntax on
filetype on
au BufNewFile,BufRead *.okl set filetype=cpp

" C++
syntax on
filetype on
au BufNewFile,BufRead *.tpp set filetype=cpp

" NekRS
syntax on
filetype on
au BufNewFile,BufRead *.udf set filetype=cpp

syntax on
filetype on
au BufNewFile,BufRead *.oudf set filetype=cpp

" Charm++
syntax on
filetype on
au BufNewFile,BufRead *.ci set filetype=ci

" Folding Options
set foldmethod=manual
set foldnestmax=1
set nofoldenable
set foldlevel=1

augroup AutoSaveFolds
    autocmd!
    autocmd BufWinLeave * mkview
    autocmd BufWinEnter * silent loadview
augroup END
