" Colorscheme name: naz

highlight clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'naz'

" ===========================================
" Color Palette Reference (loose)
" ===========================================
" Background: #101622  | Foreground:  #c3ccdc
" Comments:   #7c8f8f  | Functions:   #0094ea
" Strings:    #37b166  | Types:       #c77212
" Statements: #db9e60  | Constants:   #90ee90
" PreProc:    #ff5874  | Identifiers: #7fdbca
" ===========================================

"------------------------------
" Core UI Elements
"
hi Normal           guibg=#101622 guifg=#c3ccdc
hi LineNr           guibg=NONE    guifg=#4b6479
hi LineNrAbove      guibg=NONE    guifg=#4b6479
hi LineNrBelow      guibg=NONE    guifg=#4b6479
hi CursorLine       guibg=#11324d guifg=NONE    gui=NONE cterm=NONE
hi CursorLineNr     guibg=#11324d guifg=#0094ea gui=NONE cterm=NONE
hi VertSplit        guibg=NONE    guifg=#252c3f gui=NONE cterm=NONE
hi Visual           guibg=#1d3b53 guifg=NONE
hi Search           guibg=#38507a guifg=#d6deeb gui=NONE cterm=NONE
hi IncSearch        guibg=#ffcb8b guifg=#171a22 gui=NONE cterm=NONE
hi Pmenu            guibg=#09243a guifg=#c3ccdc
hi PmenuSel         guibg=#316394 guifg=#d6deeb
hi StatusLine       guibg=#11324d guifg=#0094ea gui=bold cterm=bold
hi StatusLineNC     guibg=#252c3f guifg=#a1aab8 gui=NONE cterm=NONE
hi StatusLineTerm   guibg=#588c58 guifg=#90ee90 gui=bold cterm=bold
hi StatusLineTermNC guibg=#366656 guifg=#a1aab8 gui=NONE cterm=NONE
hi MatchParen       guibg=#002700 guifg=#00ff00 gui=underline cterm=underline
hi ColorColumn      guibg=#2c3043 guifg=NONE

hi Directory        guibg=NONE    guifg=#ffaa00
hi EndOfBuffer      guibg=NONE    guifg=#444466
hi NonText          guibg=NONE    guifg=#444466
hi Folded           guibg=#336666 guifg=#000000
hi FoldColumn       guibg=#336666 guifg=#000000 gui=bold cterm=bold
hi SignColumn       guibg=NONE    guifg=#ffffff gui=bold cterm=bold
hi ModeMsg          guibg=NONE    guifg=#90ee90
hi MsgArea          guibg=NONE    guifg=NONE
hi MsgSeparator     guibg=#11324d guifg=#0094ea gui=bold cterm=bold
hi MoreMsg          guibg=NONE    guifg=#40ffbb

hi Pmenu            guibg=#002244
hi WildMenu         guibg=#dddddd guifg=#0094ea

"------------------------------
" Standard Syntax (C)
"
hi Comment      guifg=#7c8f8f
hi Constant     guifg=#90ee90            " Numbers
hi String       guifg=#37b166            " String literals
hi Character    guifg=#ae81ff            " Char literals
hi Identifier   guifg=#7fdbca            " Variables
hi Function     guifg=#0094ea            " Function names
hi Statement    guifg=#db9e60 gui=NONE   " if, else, for, while
hi PreProc      guifg=#ff5874            " #include, #define, #ifdef
hi Type         guifg=#c77212 gui=NONE   " int, void, struct, size_t
hi StorageClass guifg=#db9e60            " static, const
hi Operator     guifg=#ff5874            " sizeof, +, -, *
hi Special      guifg=#ff5874            " \n, \t inside strings

"------------------------------
" C/C++ Specific Overrides
"
hi cTypedef       guifg=#db9e60
hi cppAccess      guifg=#db9e60
hi cppCast        guifg=#7fdbca
hi cppExceptions  guifg=#a1cd5e
hi cppModifier    guifg=#db9e60
hi cppOperator    guifg=#a1cd5e
hi cppStatement   guifg=#7fdbca
hi cppStructure   guifg=#db9e60

"------------------------------
" QuickFix / Diagnostic
"
hi ErrorMsg       guibg=NONE guifg=#ff514e gui=bold cterm=bold
hi WarningMsg     guibg=NONE guifg=#ffc64b gui=bold cterm=bold
hi OkMsg          guibg=NONE guifg=#90ee90 gui=bold cterm=bold
hi StderrMsg      guibg=NONE guifg=#ff514e gui=bold cterm=bold
hi StdoutMsg      guibg=NONE guifg=NONE
hi QuickFixLine   guibg=#11324d guifg=NONE
hi qfFileName     guifg=#c77212

"------------------------------
" Diff
"
hi DiffAdd        guibg=#00aa66 guifg=#dddddd
hi DiffChange     guibg=#686868 guifg=#dddddd
hi DiffDelete     guibg=NONE    guifg=#dd6666 gui=bold cterm=bold
hi DiffText       guibg=#006666 guifg=#dddddd
hi DiffTextAdd    guibg=#009999 guifg=#dddddd

"------------------------------
" Netrw
"
hi netrwDir       guifg=#0094ea gui=bold cterm=bold " Directories
hi netrwClassify  guifg=#ff5874                     " Trailing symbols like / or *
hi netrwExe       guifg=#90ee90                     " Executable files
hi netrwSymLink   guifg=#7fdbca                     " Symlinks
hi netrwTreeBar   guifg=#4b6479                     " Tree formatting characters (|)
hi netrwPlain     guifg=#c3ccdc                     " Regular files (Foreground)
hi netrwMarkFile  guibg=NONE " Hide netrw marks highlight (because it gliches when refreshing)

"------------------------------
" Tabs
"
hi TabLine      guibg=#11324d guifg=#0094ea gui=NONE cterm=NONE " Inactive tabs
hi TabLineSel   guibg=#366656 guifg=#90ee90 gui=bold cterm=bold " The currently active tab
hi TabLineFill  guibg=#252c3f guifg=#8c9f9f gui=NONE cterm=NONE " The empty space behind tabs
hi TabLineInfo  guibg=#252c3f guifg=#8c9f9f gui=italic cterm=italic
" TabLineInfo needed to apply style without affecting the other tab highlights

"------------------------------
" Terminal Colors (ANSI Palette)
"
let g:terminal_color_0  = '#000000' " Black
let g:terminal_color_1  = '#e06c75' " Red
let g:terminal_color_2  = '#98c379' " Green
let g:terminal_color_3  = '#c77212' " Yellow
let g:terminal_color_4  = '#0094ea' " Blue
let g:terminal_color_5  = '#c678dd' " Magenta
let g:terminal_color_6  = '#56b6c2' " Cyan
let g:terminal_color_7  = '#c3ccdc' " White

let g:terminal_color_8  = '#222222' " Bright Black
let g:terminal_color_9  = '#ff5874' " Bright Red
let g:terminal_color_10 = '#90ee90' " Bright Green
let g:terminal_color_11 = '#ffcb8b' " Bright Yellow
let g:terminal_color_12 = '#51afef' " Bright Blue
let g:terminal_color_13 = '#d670d6' " Bright Magenta
let g:terminal_color_14 = '#46ddff' " Bright Cyan
let g:terminal_color_15 = '#eeeeee' " Bright White
