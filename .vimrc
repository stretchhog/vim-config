execute pathogen#infect()
set rtp+=~/.vim/bundle/Vundle.vim
set foldmethod=marker

" startup settings {{{1
set columns=240
set lines=48
set shiftwidth=4
set tabstop=4
set title
set number
set nocompatible
set visualbell

let mapleader=","

set clipboard=unnamed
"}}}1 
" syntax and ui {{{1
syntax on
set hlsearch
set autoindent		" always set autoindenting on
colorscheme solarized
set guifont=Sauce\ Code\ Pro\ Nerd\ Font\ Complete:h12
if strftime("%H") < 17 && strftime("%H") > 8
	set background=light
else
	set background=dark
endif

set t_Co=256

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  set fileencodings=ucs-bom,utf-8,latin1
endif

autocmd BufWrite * mkview
autocmd BufRead * silent loadview


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
"}}}1 
" mappings {{{1

" move lines up and down
nnoremap <a-k> :m .-2<CR>== 
nnoremap <a-j> :m .+1<CR>==
inoremap <a-j> <Esc>:m .+1<CR>==gi
inoremap <a-k> <Esc>:m .-2<CR>==gi
vnoremap <a-j> :m '>+1<CR>gv=gv
vnoremap <a-k> :m '<-2<CR>gv=gv

" open vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" movement
map <leader>n <esc>:tabprevious<cr>
map <leader>m <esc>:tabnext<cr>
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-h> <c-w>h
map <c-l> <c-w>l

" beginning en end of line
nnoremap H ^
nnoremap L $
nnoremap <c-S> :so %<cr>

" space to toggle folds
nnoremap <space> za
vnoremap <space> za

" indentation
vnoremap < <gv
vnoremap > >gv

nmap <F8> :TagbarToggle<CR>

nnoremap <silent> <leader>l :nohl<CR>
"}}}1 
" plugins - vundle {{{1
" ====================================================================================
filetype plugin indent off
call vundle#begin('~/.vim/bundle')
Plugin 'gmarik/Vundle.vim'

" Basics
Plugin 'myusuf3/numbers.vim'
Plugin 'xolox/vim-misc'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'

" Git
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Workflow
Plugin 'vim-airline/vim-airline'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
"Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'scrooloose/nerdcommenter'
Plugin 'ryanoasis/vim-devicons'
Plugin 'xolox/vim-notes'
Plugin 'vimwiki/vimwiki'
Plugin 'godlygeek/tabular'

" Code
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'Shougo/neocomplete.vim' 
Plugin 'scrooloose/syntastic'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

" Scala
Plugin 'derekwyatt/vim-scala'

" Python
Plugin 'davidhalter/jedi-vim'

" Markdown
Plugin 'suan/vim-instant-markdown'
Plugin 'Rykka/riv.vim'
Plugin 'Rykka/InstantRst'

call vundle#end()
filetype plugin indent on
" -------------------------------------------------------------- }}}1 
" plugin settings {{{1

" ctrl-p {{{2
let g:ctrlp_max_files=0
set wildignore+=*\\target\\*
set wildignore+=*zip,*exe,*iml,*log,*jar,*jobs,*story,*launch,*epf,*war,*bat,*fla,*class,*lck,*applescript,*pdf,*pyc,*jar,*md5,*sha1,*h
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
set smartcase
"}}}2 
" nerdtree {{{2
silent! map <F3> :NERDTreeFind<CR>
let g:NERDTreeToggle="<F3>"
let g:NERDTreeDirArrows=1


"}}}2 
" easytags {{{2
:set tags=./tags;
:let g:easytags_dynamic_files = 1
"}}}2 
" airline {{{2
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 2
"}}}2 
" ultisnips {{{2
let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsSnippetDirectories=["~/UltiSnips"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"}}}2
" neocomplete {{{2
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 2
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<tab>"
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.cs = '.*[^=\);]'
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
"}}}2
" InstantRst {{{2
let g:instant_rst_browser="chrome"
"}}}
" nerdcommenter {{{2
" Add spaces after comment delimiters by default
 let g:NERDSpaceDelims = 1

 " Use compact syntax for prettified multi-line comments
 let g:NERDCompactSexyComs = 1

 " Align line-wise comment delimiters flush left instead of following code
 " indentation
 let g:NERDDefaultAlign = 'left'

 " Set a language to use its alternate delimiters by default
 let g:NERDAltDelims_java = 1

 " Add your own custom formats or override the defaults
 let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

 " Allow commenting and inverting empty lines (useful when commenting a
 " region)
 let g:NERDCommentEmptyLines = 1

 " Enable trimming of trailing whitespace when uncommenting
 let g:NERDTrimTrailingWhitespace = 1
 "}}}2
" syntasic {{{2
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

augroup filetype_sbt
  autocmd!
  autocmd BufNewFile,BufRead *.sbt set filetype=sbt
  autocmd FileType sbt setlocal syntax=scala
augroup END

let g:syntastic_javascript_checkers = ['jshint']
nmap <F2> :lnext<CR>

"}}}2
" omnisharp {{{2
let g:OmniSharp_selector_ui = 'ctrlp' 
augroup omnisharp_commands
    autocmd!

    "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

    " Synchronous build (blocks Vim)
    "autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
    " Builds can also run asynchronously with vim-dispatch installed
    autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
    " automatic syntax check on events (TextChanged requires Vim 7.4)
    autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

    " Automatically add new cs files to the nearest project on save
    autocmd BufWritePost *.cs call OmniSharp#AddToProject()

    "show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    "The following commands are contextual, based on the current cursor position.

    autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
    autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
    autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
    autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
    autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
    "finds members in the current buffer
    autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
    " cursor can be anywhere on the line containing an issue
    autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
    autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
    autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
    autocmd FileType cs nnoremap <leader>d :OmniSharpDocumentation<cr>

augroup END
"2}}}

let g:nerdtree_tabs_open_on_console_startup=0
"}}}1 
" Filetype specific {{{1
:autocmd FileType python,html,htmldjango,scala setlocal foldmethod=indent
:autocmd FileType python,html,htmldjango,scala normal zR
"}}}1
