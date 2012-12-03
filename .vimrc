filetype plugin indent on
au BufNewFile,BufRead *.cpp set syntax=cpp11
set smartindent
set shiftwidth=4
set tabstop=4
set expandtab ts=4 sw=4 ai
set hlsearch
nmap ,f :FufCoverageFile<CR>
nmap ,b :FufBuffer<CR>
nmap ,t :FufTaggedFile<CR>
map sa :exec "/\\(".getreg('/')."\\)\\\\|".expand("<cword>")<CR>
map ,c :Tlist<CR>

"Buffer surf back and force
map K :BufSurfForward<CR>
map J ::BufSurfBack<CR>

cabbrev grep <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Grep' : 'grep')<CR>
cabbrev find <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Find' : 'find')<CR>
map ,s :execute " grep -srnw --exclude=tags --exclude=*.html --exclude-dir=framework_addon --exclude-dir=network_addon --exclude-dir=runtime_addon --exclude-dir=build --exclude-dir=bin --binary-files=without-match --exclude-dir=.git --exclude-dir=.repo . -e " . expand("<cword>") . " " <bar> cwindow<CR>

"Set ctags looking path
set tags=tags;/
set tags+=~/ctags/boost.tags

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

nmap ,a :call SwitchSourceHeader()<CR>

function! SwitchSourceHeader()
  "update!
  if (expand ("%:e") == "cpp")
    call Find(expand("%:t:r").".h")
  else
    call Find(expand("%:t:r").".cpp")
  endif
endfunction

function! Grep(name)
  execute ":grep -isrn --exclude=tags --exclude=*.html --exclude-dir=framework_addon --exclude-dir=network_addon --exclude-dir=runtime_addon --exclude-dir=build --exclude-dir=bin --exclude-dir=.git --exclude-dir=.repo --binary-files=without-match . -e ".a:name
  execute ":copen"
endfunction
command! -nargs=1 Grep :call Grep("<args>")

function! Find(name)
  echo a:name
  let l:list=system("find . -iname '".a:name."' | perl -ne 'print \"$.\\t$_\"'")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:name."' not found"
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

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
