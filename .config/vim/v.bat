@echo off

:: v [--vim] <-e, -t, -d> [--edit] [Vim/Nvim arguments]
:: Possible commands ...
:: Neovide/NeoVim:
::   > v (`nvim --server $NVIM --remote .`)
::   > v -e <NVIM ARGS>   (`nvim --server $NVIM --remote <NVIM ARGS>`)
::   > v -t <NVIM ARGS>   (`nvim --server $NVIM --remote-tab <NVIM ARGS>`)
::   > v -d <file> <file> (`nvim --server $NVIM --remote-tab <NVIM ARGS>`)
:: Vim:
::   > v --vim (`vim --server VIM --remote .`)
::   > v --vim -e <VIM ARGS> (`vim --server VIM --remote <VIM ARGS>`)
::   > v --vim -t <VIM ARGS> (`vim --server VIM --remote-tab <VIM ARGS>`)
::   > v --vim -d {file_a} {file_b} (
::     `vim --server VIM --remote-tab {file_a}`
::     `vim --server VIM --remote-send ":vert split | edit {file_b} | windo diffthis`
::   )

set "V_PRG="
set "V_SERVER="
set "V_REMOTE_OP=--remote"
set "V_ARGS="
set "V_DIFF=0"
set "V_FILE_A="
set "V_FILE_B="


:: ==================================================
:: Argument parsing
:: ==================================================

:: Check for the `--vim` (only on %1) flag to set V_PRG to Vim or NeoVim
if "%~1" == "--vim" (
  set "V_PRG=vim"
  set "V_SERVER=VIM"
  shift
) else (
  set "V_PRG=nvim"
  set "V_SERVER=%NVIM%"
)

:: Set var based on the flag `-e = --remote`, `-t` = remote-tab)
if "%~1" == "-e" (
  shift
) else if "%~1" == "-t" (
  set "V_REMOTE_OP=--remote-tab"
  shift
) else if "%~1" == "-d" (
  set "V_DIFF=1"
  set "V_FILE_A="%~f2""
  set "V_FILE_B="%~f3""
  goto end
)
::echo [DEBUG] V_FILE_A: %V_FILE_A%
::echo [DEBUG] V_FILE_B: %V_FILE_B%

:: If there are no arguments left, default to current directory (`--edit` = edit v.bat)
if "%~1" == "" (
  set "V_ARGS=."
  goto end
) else if "%~1" == "--edit" (
  set "V_ARGS="%userprofile%\vimfiles\v\v.bat""
  goto end
)

:: Build variable with every arg from the new %1 onwards
:loop
if "%~1" == "" goto end

:: Expand file paths (chek for `-` or `+` for flags)
:: Syntax for getting chars from arguments: %variable:~start_index,length%
set "curr_arg=%~1"
::echo [DEBUG] curr_arg: %curr_arg%

set "prefix=%curr_arg:~0,1%"
::echo [DEBUG] prefix: [%prefix%]

if not "%prefix%" == "-" (
  if not "%prefix%" == "+" (
    set "curr_arg="%~f1""
  )
)

if "%V_ARGS%" == "" (
  set "V_ARGS=%curr_arg%"
) else (
  set "V_ARGS=%V_ARGS% %curr_arg%"
)

shift
goto loop
:end


:: ==================================================
:: Running commands
:: ==================================================

:: If V_PRG is nvim and there's no Neovide instance, define a server pipe name
:: and launch Neovide, passing --listen to nvim (sleep to wait for Neovide to open)
if "%NVIM%" == "" (
  if "%V_PRG%" == "nvim" (
    set "NVIM=\\.\pipe\neovide_v_server"
    set "V_SERVER=\\.\pipe\neovide_v_server"
    start neovide -- --listen \\.\pipe\neovide_v_server
    timeout /t 1 /nobreak >nul
  )
)

:: Launch the V_PRG with server (NeoVim server path is stored in %NVIM% or custom pipe)
if "%V_DIFF%" == "1" (
  %V_PRG% --server %V_SERVER% --remote-tab %V_FILE_A%
  %V_PRG% --server %V_SERVER% --remote-send "<C-\><C-n>:execute 'vert split ' . fnameescape('%V_FILE_B%') | windo diffthis<CR>"
) else (
  %V_PRG% --server %V_SERVER% %V_REMOTE_OP% %V_ARGS%
)
