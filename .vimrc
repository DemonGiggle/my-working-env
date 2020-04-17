filetype plugin indent on
au BufNewFile,BufRead *.cpp set syntax=cpp11
set smartindent
set shiftwidth=2
set tabstop=2
set expandtab ts=2 sw=2 ai
set hlsearch
set backspace=indent,eol,start
set number
syntax on

highlight Folded ctermbg=0 ctermfg=230

" ----- Fuzzy Finder ----
" nmap ,f :FufCoverageFile<CR>
" nmap ,b :FufBuffer<CR>
" nmap ,,f :FufFileWithCurrentBufferDir<CR>
" nmap ,l :FufLine<CR>
"nmap ,t :FufTaggedFile<CR>

" ------ Unite ---------
nmap ,f :Unite -start-insert directory file_rec<CR> <Plug>(unite_redraw)
nmap ,b :Unite -start-insert buffer<CR>

" ------ Vim go --------
" nmap ,d :GoDef<CR>
" nmap ,e :GoDoc<CR>

map sa :exec "/\\(".getreg('/')."\\)\\\\|".expand("<cword>")<CR>
" map ,c :Tlist<CR>
nmap ,t :TagbarToggle<CR>

"Buffer surf back and force
"map K :BufSurfForward<CR>
"map J ::BufSurfBack<CR>

cabbrev grep <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Grep' : 'grep')<CR>
cabbrev find <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Find' : 'find')<CR>
"cabbrev git <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Git' : 'git')<CR>
"cabbrev gitstatus <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'GitStatus' : 'gitstatus')<CR>
"cabbrev gitadd <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'GitAdd' : 'gitadd')<CR>
"cabbrev gitcommit <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'GitCommit' : 'gitcommit')<CR>
"cabbrev gitlog <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'GitLog' : 'gitlog')<CR>
"cabbrev gitcheckout <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'GitCheckout' : 'gitcheckout')<CR>
"cabbrev gitdiff <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'GitDiff' : 'gitdiff')<CR>
"cabbrev gitpull <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'GitPull' : 'gitpull')<CR>
"cabbrev gitpush <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'GitPush' : 'gitpush')<CR>
"cabbrev gitblame <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'GitBlame' : 'gitblame')<CR>

"map ,s :execute " grep -srnw --exclude=tags --exclude-dir=framework_addon --exclude-dir=network_addon --exclude-dir=runtime_addon --exclude-dir=build --exclude-dir=bin --exclude-dir=.svn --binary-files=without-match --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=.repo . -e " . expand("<cword>") . " " <bar>cwindow<CR>
"Set ctags looking path
set tags=tags;/
"set tags+=~/ctags/boost.tags

set laststatus=2
set statusline=%{GitBranch()}\ [%t:%l:%c\ --\ %p%%]\ %m%r

"Something about undo
set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes tha can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

" --- EasyMotion ---
let g:EasyMotion_do_mapping = 0 " Disable default mappings
" Jump to anywhere you want with minimal keystrokes, with just one key
" binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)

autocmd BufWritePre * %s/\s\+$//e

" --- OmniCppComplete ---
" -- required --
"set nocp " non vi compatible mode
"filetype plugin on " enable plugins
"" -- optional --
"" auto close options when exiting insert mode
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif
"set completeopt=menu,menuone
"" -- configs --
"let OmniCpp_LocalSearchDecl = 0
"let OmniCpp_MayCompleteDot = 1 " autocomplete with .
"let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
"let OmniCpp_MayCompleteScope = 1 " autocomplete with ::
"let OmniCpp_SelectFirstItem = 2 " select first item (but don't insert)
""let OmniCpp_NamespaceSearch = 2 " search namespaces in this and included files
"let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype (i.e. parameters) in popup window
"let OmniCpp_DefaultNamespaces = ["zillians::language", "zillians::language::tree"]
"set tags+=~/project/zillians/platform/tags
"set tags+=~yoco/tags/boost/boost_tags
" Find file in current directory and edit it.

" vim-gitgutter hotkeys
nmap <silent> ]h :<C-U>execute v:count1 . "GitGutterNextHunk"<CR>
nmap <silent> [h :<C-U>execute v:count1 . "GitGutterPrevHunk"<CR>
highlight clear SignColumn

nmap ,a :call SwitchSourceHeader()<CR>
function! SwitchSourceHeader()
  "update!
  if (expand ("%:e") == "cpp" || expand ("%:e") == "cc" )
    call Find(expand("%:t:r").".h")
  else
    call Find(expand("%:t:r").".cpp")
    call Find(expand("%:t:r").".cc")
  endif
endfunction

function! Grep(name)
  execute ":grep -isrn --exclude=tags --exclude-dir=framework_addon --exclude-dir=network_addon --exclude-dir=runtime_addon --exclude-dir=build --exclude-dir=bin --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.repo --binary-files=without-match . -e ".a:name
  execute ":copen"
endfunction
command! -nargs=1 Grep :call Grep("<args>")

function! Find(name)
  echo a:name
  let l:list=system("find . -iname '".a:name."' | perl -ne 'print \"$.\\t$_\"'")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    "echo "'".a:name."' not found"
    return
  endif
  if l:num != 1
    echo l:list
    let l:input=input("Which ? (CR=nothing)\n")
    if strlen(l:input)==0
      return
    endif
    if strlen(substitute(l:input, "[0-9]", "", "g"))>0
      echo "Not a number"
      return
    endif
    if l:input<1 || l:input>l:num
      echo "Out of range"
      return
    endif
    let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
  else
    let l:line=l:list
  endif
  let l:line=substitute(l:line, "^[^\t]*\t./", "", "")
  execute ":e ".l:line
endfunction
command! -nargs=1 Find :call Find("<args>")

" vim-go settings
" let g:go_highlight_functions = 1
" let g:go_highlight_methods = 1
" let g:go_highlight_structs = 1
" let g:go_highlight_operators = 1
" let g:go_highlight_build_constraints = 1
" let g:go_fmt_command = "goimports"
" let g:neocomplete#enable_at_startup = 1
" let g:go_fmt_autosave = 0

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ neocomplete#start_manual_complete()
function! s:check_back_space() "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

" vundle setting
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
" required!
Plugin 'VundleVim/Vundle.vim'

Plugin 'easymotion/vim-easymotion'
Plugin 'L9'
" Plugin 'FuzzyFinder'
Plugin 'git@github.com:motemen/git-vim.git'
Plugin 'git@github.com:jisaacks/GitGutter.git'
Plugin 'Mark'
" Plugin 'git@github.com:Valloric/YouCompleteMe.git'
Plugin 'scrooloose/syntastic'
Plugin 'git@github.com:ton/vim-bufsurf.git'
Plugin 'Shougo/neocomplete'
Plugin 'Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'git@github.com:keith/swift.vim.git'
Plugin 'git@github.com:fatih/vim-go.git'
Plugin 'git@github.com:majutsushi/tagbar.git'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'git@github.com:digitaltoad/vim-jade.git'
Plugin 'git@github.com:othree/javascript-libraries-syntax.vim.git'
Plugin 'vim-ruby/vim-ruby'
Plugin 'git@github.com:tpope/vim-rails.git'
Plugin 'slim-template/vim-slim.git'
Plugin 'padde/jump.vim'

" -- start -- silver search related plugin
Plugin 'git@github.com:rking/ag.vim.git'
Plugin 'git@github.com:Chun-Yang/vim-action-ag.git'
" -- end -- silver search related plugin

" The local vim conifguration
Plugin 'git://github.com/thinca/vim-localrc'

" Unite Vim
Plugin 'git://github.com/Shougo/unite.vim'
Plugin 'git://github.com/ujihisa/unite-colorscheme'
Plugin 'git://github.com/basyura/unite-rails'

" Elixir
Plugin 'elixir-lang/vim-elixir'
Plugin 'slashmili/alchemist.vim'

" Git wrapper
Plugin 'git://github.com/tpope/vim-fugitive'

" solidity
Plugin 'tomlion/vim-solidity'

" terraform
Plugin 'git://github.com/hashivim/vim-terraform.git'

" vuejs
Plugin 'posva/vim-vue'

" indent handler
Plugin 'Yggdroot/indentLine'

" rust
Plugin 'rust-lang/rust.vim'
Plugin 'racer-rust/vim-racer'

" All of your Plugins must be added before the following line
call vundle#end()           " required
filetype plugin indent on   " required!

" == Unite initialization
call unite#filters#matcher_default#use(['matcher_fuzzy'])
" == end of Unite initializatoin

let g:syntastic_enable_elixir_checker = 1
let g:syntastic_enable_rubyr_checker = 1
let g:syntastic_elixir_checkers = ['elixir', 'ruby']
let g:syntastic_c_cppcheck_args = ["-std=c++17", "-Wc++11-extensions"]

" change the vimdiff color
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

" setting of indentLine plugin
let g:indentLine_conceallevel = 2
let g:indentLine_char = '┆'
let g:indentLine_enabled = 0  " to enabled it, use :IndentLinesToggle

" setting of rustfmt
let g:rustfmt_autosave = 1

" setting of racer
set hidden
let g:racer_cmd = "/Users/giggle/.cargo/bin/racer"
let g:racer_experimental_completer = 1

augroup Racer
    autocmd!
    autocmd FileType rust nmap <buffer> gd         <Plug>(rust-def)
    autocmd FileType rust nmap <buffer> gs         <Plug>(rust-def-split)
    autocmd FileType rust nmap <buffer> gx         <Plug>(rust-def-vertical)
    autocmd FileType rust nmap <buffer> <leader>gt <Plug>(rust-def-tab)
    autocmd FileType rust nmap <buffer> <leader>gd <Plug>(rust-doc)
augroup END
" end of racer setting
