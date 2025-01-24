" Default config file settings ---------------------- {{{
" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
set nobackup		" do not keep a backup file, use versions instead
else
set backup		" keep a backup file (restore to previous version)
if has('persistent_undo')
  set undofile	" keep an undo file (undo changes after closing)
endif
endif

if &t_Co > 2 || has("gui_running")
" Switch on highlighting the last used search pattern.
set nohlsearch
endif
" }}}

" Set various preferences ---------------------- {{{
set foldlevelstart=1
set laststatus=2
set ruler
set number
set hidden
set nocp
set wrap
set colorcolumn=80
filetype plugin indent on
set smartindent expandtab tabstop=4 shiftwidth=4
set ignorecase smartcase
set wildmode=longest,list,full
set wildmenu
" }}}

" Vimscript file settings ---------------------- {{{
augroup filetype_vim
autocmd!
autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Text file settings ---------------------- {{{
" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
autocmd!
autocmd FileType text setlocal textwidth=78
augroup END
" }}}

" Optional packages ---------------------- {{{
" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
packadd! matchit
endif
" }}}

" Plugin settings ---------------------- {{{
" Load plugins
call plug#begin()
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/vader.vim'
Plug 'Vimjas/vint'
"Plug 'vim-airline/vim-airline'
"Plug 'lambdalisue/battery.vim'
call plug#end()
" }}}

" Hotkey settings ---------------------- {{{
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <C-s> :Files<CR>
nnoremap <silent> <Leader>f :Rg<CR>
nnoremap <silent> <Leader>/ :BLines<CR>
nnoremap <silent> <Leader>' :Marks<CR>
nnoremap <silent> <Leader>g :Commits<CR>
nnoremap <silent> <Leader>H :Helptags<CR>
nnoremap <silent> <Leader>hh :History<CR>
nnoremap <silent> <Leader>h: :History:<CR>
nnoremap <silent> <Leader>h/ :History/<CR>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <silent> <Leader>[ :execute "! ~/sh/bat_info.sh"<cr>
" }}}

" Exercism vimscript test settings ---------------------- {{{
" Function to execute Exercism vimscript tests with :Test
function! s:exercism_tests()
if expand('%:e') == 'vim'
  let testfile = printf('%s/%s.vader', expand('%:p:h'),
        \ tr(expand('%:p:h:t'), '-', '_'))
  if !filereadable(testfile)
    echoerr 'File does not exist: '. testfile
    return
  endif
  source %
  execute 'Vader' testfile
else
  let sourcefile = printf('%s/%s.vim', expand('%:p:h'),
        \ tr(expand('%:p:h:t'), '-', '_'))
  if !filereadable(sourcefile)
    echoerr 'File does not exist: '. sourcefile
    return
  endif
  execute 'source' sourcefile
  Vader
endif
endfunction
augroup vader
autocmd!
autocmd BufRead *.{vader,vim}
    \ command! -buffer Test call s:exercism_tests()
augroup END
" }}}

" Statusline settings ---------------------- {{{
" Add battery to statusline
"let g:battery#update_statusline = 1
"let g:airline#extensions#battery#enabled = 1
" }}}

" Displays a friendly ASCII-art cat
"redraw | echo ">^.^<"
