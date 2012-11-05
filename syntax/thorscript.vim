" Vim syntax file
" Language:	JavaScript
" Maintainer:	Claudio Fleiner <claudio@fleiner.com>
" Updaters:	Scott Shattuck (ss) <ss@technicalpursuit.com>
" URL:		http://www.fleiner.com/vim/syntax/javascript.vim
" Changes:	(ss) added keywords, reserved words, and other identifiers
"		(ss) repaired several quoting and grouping glitches
"		(ss) fixed regex parsing issue with multiple qualifiers [gi]
"		(ss) additional factoring of keywords, globals, and members
" Last Change:	2010 Mar 25

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
" tuning parameters:
" unlet thorScript_fold

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'thorscript'
endif

" Drop fold if it set but vim doesn't support it.
if version < 600 && exists("thorScript_fold")
  unlet thorScript_fold
endif


syn keyword thorScriptCommentTodo      TODO FIXME XXX TBD contained
syn match   thorScriptLineComment      "\/\/.*" contains=@Spell,thorScriptCommentTodo
syn match   thorScriptCommentSkip      "^[ \t]*\*\($\|[ \t]\+\)"
syn region  thorScriptComment	       start="/\*"  end="\*/" contains=@Spell,thorScriptCommentTodo
syn match   thorScriptSpecial	       "\\\d\d\d\|\\."
syn region  thorScriptStringD	       start=+"+  skip=+\\\\\|\\"+  end=+"\|$+	contains=thorScriptSpecial,@htmlPreproc
syn region  thorScriptStringS	       start=+'+  skip=+\\\\\|\\'+  end=+'\|$+	contains=thorScriptSpecial,@htmlPreproc

syn match   thorScriptSpecialCharacter "'\\.'"
syn match   thorScriptNumber	       "-\=\<\d\+L\=\>\|0[xX][0-9a-fA-F]\+\>"
syn region  thorScriptRegexpString     start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/[gi]\{0,2\}\s*$+ end=+/[gi]\{0,2\}\s*[;.,)\]}]+me=e-1 contains=@htmlPreproc oneline

syn keyword thorScriptConditional	if else switch
syn keyword thorScriptRepeat		while for do in
syn keyword thorScriptBranch		break continue
syn keyword thorScriptOperator		new delete instanceof typeof
syn keyword thorScriptType		Array Boolean Date Function Number Object String RegExp
syn keyword thorScriptStatement		return with
syn keyword thorScriptBoolean		true false
syn keyword thorScriptNull		null undefined
syn keyword thorScriptIdentifier	arguments this var let
syn keyword thorScriptLabel		case default
syn keyword thorScriptException		try catch finally throw
syn keyword thorScriptMessage		alert confirm prompt status
syn keyword thorScriptGlobal		self window top parent
syn keyword thorScriptMember		document event location 
syn keyword thorScriptDeprecated	escape unescape
syn keyword thorScriptReserved		abstract boolean byte char class const debugger double enum export extends final float goto implements import int interface long native package private protected public short static super synchronized throws transient volatile 
syn keyword thorScriptReserved		void int8 int16 int32 int64 float16 float32 float64

syn match   thorScriptAnnotations       "@\h\w*"

if exists("thorScript_fold")
    syn match	thorScriptFunction	"\<function\>"
    syn region	thorScriptFunctionFold	start="\<function\>.*[^};]$" end="^\z1}.*$" transparent fold keepend

    syn sync match thorScriptSync	grouphere thorScriptFunctionFold "\<function\>"
    syn sync match thorScriptSync	grouphere NONE "^}"

    setlocal foldmethod=syntax
    setlocal foldtext=getline(v:foldstart)
else
    syn keyword thorScriptFunction	function
    syn match	thorScriptBraces	   "[{}\[\]]"
    syn match	thorScriptParens	   "[()]"
endif

syn sync fromstart
syn sync maxlines=100

if main_syntax == "thorscript"
  syn sync ccomment thorScriptComment
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_thorscript_syn_inits")
  if version < 508
    let did_thorscript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink thorScriptComment		Comment
  HiLink thorScriptLineComment		Comment
  HiLink thorScriptCommentTodo		Todo
  HiLink thorScriptSpecial		Special
  HiLink thorScriptStringS		String
  HiLink thorScriptStringD		String
  HiLink thorScriptCharacter		Character
  HiLink thorScriptSpecialCharacter	thorScriptSpecial
  HiLink thorScriptNumber		thorScriptValue
  HiLink thorScriptConditional		Conditional
  HiLink thorScriptRepeat		Repeat
  HiLink thorScriptBranch		Conditional
  HiLink thorScriptOperator		Operator
  HiLink thorScriptType			Type
  HiLink thorScriptStatement		Statement
  HiLink thorScriptFunction		Function
  "HiLink thorScriptBraces		Function
  hi thorScriptBraces		ctermfg=149 guifg=#88BB33
  hi thorScriptParens		ctermfg=149 guifg=#88BB33
  HiLink thorScriptError		Error
  HiLink thorScriptParenError		thorScriptError
  HiLink thorScriptNull			Keyword
  HiLink thorScriptBoolean		Boolean
  HiLink thorScriptRegexpString		String

  HiLink thorScriptIdentifier		Identifier
  HiLink thorScriptLabel		Label
  HiLink thorScriptException		Exception
  HiLink thorScriptMessage		Keyword
  HiLink thorScriptGlobal		Keyword
  HiLink thorScriptMember		Keyword
  HiLink thorScriptDeprecated		Exception 
  HiLink thorScriptReserved		Keyword
  HiLink thorScriptDebug		Debug
  HiLink thorScriptConstant		Label

  hi     thorScriptAnnotations          ctermfg=177

  delcommand HiLink
endif


syn match MyCppOperators '+\|-\|\*\|[\/\*]\@<!\/[\/\*]\@!\|%\|='  "arithmatic & assign
syn match MyCppOperators '<\|>\|==\|!='                           "relation
syn match MyCppOperators '[~|&!^]'                                "bitwise
syn match MyCppOperators '[?:;,]'                                 "misc
syn match MyCppOperators '||\|&&'                                 "logic
hi  MyCppOperators ctermfg=166 guifg=#CC0000


let b:current_syntax = "thorscript"
if main_syntax == 'thorscript'
  unlet main_syntax
endif

" vim: ts=8
