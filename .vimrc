execute pathogen#infect()
set rtp+=~/vimfiles/bundle/Vundle.vim
set foldmethod=marker

" 1. STARTUP SETTINGS {{{1
" ====================================================================================
set columns=240
set lines=48
set shiftwidth=4
set tabstop=4
set title
set number
set nocompatible
set nowrap
let mapleader=","

autocmd! bufwritepost .vimrc source %
set clipboard=unnamed
" -------------------------------------------------------------- }}}1 STARTUP SETTINGS

" 2. SYNTAX AND UI {{{1
" ====================================================================================
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if has("gui_running")
	set background=dark
  	colorscheme solarized
"  set guifont=DejaVu_Sans_Mono_for_Powerline:h9
   set guifont=Consolas:h10
"  set guifont=Ubuntu_Mono_derivative_Powerlin:h10
endif

set autoindent		" always set autoindenting on
set colorcolumn=120

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif

autocmd BufWrite * mkview
autocmd BufRead * silent loadview

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
au!

" For all text files set 'textwidth' to 120 characters.
autocmd FileType text setlocal textwidth=120

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

augroup END


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

fu! SeeTab()
  if !exists("g:SeeTabEnabled")
    let g:SeeTabEnabled = 0
  end
  if g:SeeTabEnabled==0
    syn match leadspace /^\s\+/ contains=syntab
    exe "syn match syntab /\\s\\{" . &sw . "}/hs=s,he=s+1 contained"
    hi syntab guibg=Grey
    let g:SeeTabEnabled=1
  else
    syn clear leadspace
    syn clear syntab
    let g:SeeTabEnabled=0
  end
endfunc
com! -nargs=0 SeeTab :call SeeTab()
" -------------------------------------------------------------- }}}1 SYNTAX AND UI

" 3. PLUGINS - VUNDLE {{{1
" ====================================================================================
call vundle#begin('~/vimfiles/bundle')
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'Shougo/neocomplete.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'xolox/vim-easytags'
Plugin 'xolox/vim-misc'
Plugin 'tpope/vim-sensible'
Plugin 'altercation/vim-colors-solarized'

" Python plugins
Plugin 'Yggdroot/indentLine'
Plugin 'jaredly/vim-debug'
Plugin 'davidhalter/jedi-vim'
Plugin 'klen/python-mode'
call vundle#end()
" -------------------------------------------------------------- }}}1 

" 4. MAPPINGS {{{1
" ====================================================================================
" move lines up and down
nnoremap <a-k> :m .-2<CR>== 
nnoremap <a-j> :m .+1<CR>==
inoremap <a-j> <Esc>:m .+1<CR>==gi
inoremap <a-k> <Esc>:m .-2<CR>==gi
vnoremap <a-j> :m '>+1<CR>gv=gv
vnoremap <a-k> :m '<-2<CR>gv=gv

" open vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" python specific
autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>
autocmd FileType vim nnoremap <buffer> <localleader>c I"<esc>

" movement
map <leader>n <esc>:tabprevious<cr>
map <leader>m <esc>:tabnext<cr>
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-h> <c-w>h
map <c-l> <c-w>l

" indentation
vnoremap < <gv
vnoremap > >gv
" -------------------------------------------------------------- }}}1 MAPPINGS

" CTRL-P {{{1
" ====================================================================================
let g:ctrlp_max_files=0
set wildignore+=\\tmp*
set wildignore+=*\\target\\*
set wildignore+=*\\juice-site-ui\\*
set wildignore+=*\\config\\*
set wildignore+=*\\apps\\*
set wildignore+=*\\downloads\\*
set wildignore+=*\\sandbox\\*
set wildignore+=*\\scratchpad\\*
set wildignore+=*\\eclipse\\*
set wildignore+=*\\.m2\\*
set wildignore+=*zip,*exe,*iml,*log,*jar,*jobs,*story,*launch,*epf,*war,*txt,*bat,*sh,*js,*fla,*json,*class,*lck,*applescript,*css,*pdf,*pyc,*html,*jar,*md5,*sha1,*h
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
set smartcase
" -------------------------------------------------------------- }}}1 

" EASYTAGS {{{1
" ====================================================================================
:set tags=./tags;
:let g:easytags_dynamic_files = 1
" -------------------------------------------------------------- }}}1 

" JEDI-VIM {{{1
let g:jedi#popup_select_first = 0
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_definitions_command = ""
let g:jedi#rename_command = '<leader>jr'
let g:jedi#usages_command = ""
" -------------------------------------------------------------- }}}1 

" PYTHON-MODE {{{1
" ====================================================================================
" Python-mode
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)
let g:pymode_run_bind = '<leader>r'

let g:pymode_rope = 1
let g:pymode_rope_completion = 0

" Documentation
let g:pymode_doc = 0
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
" Auto check on save
let g:pymode_lint_write = 1

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0
" -------------------------------------------------------------- }}}1 

" OMNICOMPLETE {{{1
" ====================================================================================
set omnifunc=syntaxcomplete#Complete
setlocal omnifunc=javacomplete#Complete
let g:neocomplcache_enable_at_startup=1
let g:neocomplcache_enable_fuzzy_completion=1
let g:neocomplcache_auto_completion_start_length=1
" -------------------------------------------------------------- }}}1 

" NERDTREE {{{1
" ====================================================================================
silent! map <F3> :NERDTreeFind<CR>
let g:NERDTreeMapActivateNode="<F3>"
let g:NERDTreeDirArrows=1
" -------------------------------------------------------------- }}}1 

" LIGHTLINE {{{1
" ====================================================================================
let g:lightline = {
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"⭤":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}'
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' },
	  \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \   'ctrlpmark': 'CtrlPMark',
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ }

function! MyModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! MyFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ' '  " edit here for cool mark
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 120 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 120 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 120 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0"
" -------------------------------------------------------------- }}}2 

