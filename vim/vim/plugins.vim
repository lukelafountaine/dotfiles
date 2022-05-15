" Automatically install plug.vim if it's not already installed.
let data_dir = '~/.vim'

if empty(glob(data_dir . '/autoload/plug.vim'))
   silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'junegunn/fzf'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'lukelafountaine/shades-of-purple.vim'
Plug 'vim-airline/vim-airline'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Automatically install plugins if they aren't installed already.
autocmd VimEnter *
   \ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
   \ |   PlugInstall --sync | q
   \ | endif

" Plugin settings

" Git Gutter
set signcolumn=yes

" Theme settings
colorscheme shades_of_purple

if (has("termguicolors"))
   set termguicolors
endif

" Code support settings
let g:coc_global_extensions = ['coc-tsserver']

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> grn <Plug>(coc-rename)
nnoremap <silent> gh :call <SID>show_documentation()<CR>
inoremap <silent><expr> <NUL> coc#refresh()
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

function! s:show_documentation()
   if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
   elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
   else
      execute '!' . &keywordprg . " " . expand('<cword>')
   endif
endfunction

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Finder settings
nmap <C-P> :FZF<CR>
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.4, 'relative': v:true, 'yoffset': 1.0 } }

" Status line settings
set showtabline=0
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline_exclude_preview = 1
let g:shades_of_purple_airline = 1
let g:airline_theme='shades_of_purple'
