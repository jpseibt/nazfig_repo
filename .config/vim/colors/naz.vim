" Name: naz

highlight clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'naz'

" ====================================================================
" Color Palette Reference
" ====================================================================
" Background: #171a22  | Foreground:  #c3ccdc
" Comments:   #7c8f8f  | Functions:   #0094ea
" Strings:    #37b166  | Types:       #c77212
" Statements: #db9e60  | Constants:   #18d05f
" PreProc:    #ff5874  | Identifiers: #7fdbca
" ====================================================================

" --- Core UI Elements ---
hi Normal       guibg=#171a22 guifg=#c3ccdc
hi LineNr       guibg=NONE    guifg=#4b6479
hi CursorLine   guibg=#11324d guifg=NONE    gui=NONE cterm=NONE
hi CursorLineNr guibg=#11324d guifg=#0094ea gui=NONE cterm=NONE
hi VertSplit    guibg=NONE    guifg=#252c3f gui=NONE cterm=NONE
hi Visual       guibg=#1d3b53 guifg=NONE
hi Search       guibg=#38507a guifg=#d6deeb gui=NONE cterm=NONE
hi IncSearch    guibg=#ffcb8b guifg=#101622 gui=NONE cterm=NONE
hi Pmenu        guibg=#09243a guifg=#c3ccdc
hi PmenuSel     guibg=#316394 guifg=#d6deeb
hi StatusLine   guibg=#11324d guifg=#c3ccdc gui=NONE cterm=NONE
hi StatusLineNC guibg=#252c3f guifg=#a1aab8 gui=NONE cterm=NONE
hi MatchParen   guibg=#101622 guifg=#18d05f gui=underline cterm=underline
hi ColorColumn  guibg=#2c3043 guifg=NONE

" --- Standard Syntax (C) ---
hi Comment      guifg=#7c8f8f gui=italic
hi Constant     guifg=#18d05f            " Numbers
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

" --- C/C++ Specific Overrides ---
hi cTypedef       guifg=#db9e60
hi cppAccess      guifg=#db9e60
hi cppCast        guifg=#7fdbca
hi cppExceptions  guifg=#a1cd5e
hi cppModifier    guifg=#db9e60
hi cppOperator    guifg=#a1cd5e
hi cppStatement   guifg=#7fdbca
hi cppStructure   guifg=#db9e60

" --- QuickFix / Diagnostic ---
hi ErrorMsg       guibg=NONE guifg=#fc514e
hi WarningMsg     guibg=NONE guifg=#18d05f
hi QuickFixLine   guibg=#11324d guifg=NONE
hi qfFileName     guifg=#c77212

" --- netrw ---
hi netrwDir       guifg=#0094ea gui=bold cterm=bold " Directories
hi netrwClassify  guifg=#ff5874                     " Trailing symbols like / or *
hi netrwExe       guifg=#37b166                     " Executable files
hi netrwSymLink   guifg=#7fdbca                     " Symlinks
hi netrwTreeBar   guifg=#4b6479                     " Tree formatting characters (|)
hi netrwPlain     guifg=#c3ccdc                     " Regular files (Foreground)

" --- Tabs (Native & Taboo) ---
hi TabLineFill  guibg=#11324d guifg=NONE    gui=NONE cterm=NONE " The empty space behind tabs
hi TabLine      guibg=#252c3f guifg=#a1aab8 gui=NONE cterm=NONE " Inactive tabs
hi TabLineSel   guibg=#11324d guifg=#0094ea gui=bold cterm=bold " The currently active tab
