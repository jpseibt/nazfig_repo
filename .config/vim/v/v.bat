@echo off

:: Usage:
::   v [--vim] [--edit | --term] [-e | -t | -d] [files...]
::
:: Description:
::   Generate terminal-to-host / remote Vim or Nvim command calls
::
:: Options:
::   --vim     Use Vim instead of Neovim (must be the first argument)
::   -e        Edit file in the current window (default)
::   -t        Edit file in a new tab
::   -d        Open two files in a new tab and `windo diffthis`
::   --edit    Open the `v` script for editing (at %userprofile%\vimfiles\v\v.bat)
::   --term    Open current directory (netrw) and launch germinal on a new tab
::
:: Examples:
::   v .                   Open current directory     ($ nvim --server %NVIM% --remote .)
::   v --vim -t main.c     Open `main.c` in a new tab ($ vim --servername SERVER --remote-tab main.c)
::   v -d file_a file_b    Diff `file_a` (lhs) and `file_b` (rhs)
::     ($ nvim --server %NVIM% --remote-tab file_a
::      $ nvim --server %NVIM% --remote-send "<C-\><C-n> :execute 'vert split ' . fnameescape('file_b') | windo diffthis<CR>")
::
::  Note: if there's no Vim or Neovim server, launch new Vim/Neovide instance


set "V_PRG=nvim"
set "V_SERVER_OP=--server"
set "V_REMOTE_OP=--remote"
set "V_SERVER=%NVIM%"
set "V_ARGS="
set "V_DIFF=0"
set "V_TERM=0"
set "V_FILE_A="
set "V_FILE_B="


:: ==================================================
:: Argument parsing
:: ==================================================

:: Check for the `--vim` (only on %1) flag to set V_PRG to Vim or NeoVim
if "%~1" == "--vim" (
  set "V_PRG=vim"
  set "V_SERVER_OP=--servername"
  set "V_SERVER="

  for /f "tokens=*" %%i in ('vim --serverlist') do (
    set "V_SERVER=%%i"
    goto for_out
  )
  :for_out
  shift
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
  set "V_FILE_B=%~f3"
  goto end
)

if %V_DIFF% == 0 (
  if "%~1" == "" (
    set "V_ARGS=."
    goto end
  ) else if "%~1" == "--edit" (
    set "V_ARGS="%userprofile%\vimfiles\v\v.bat""
    goto end
  ) else if "%~1" == "--term" (
    set "V_ARGS=."
    set "V_TERM=1"
    goto end
  )
)

::echo [DEBUG] V_FILE_A: %V_FILE_A%
::echo [DEBUG] V_FILE_B: %V_FILE_B%

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
if "%V_SERVER%" == "" (
  if "%V_PRG%" == "nvim" (
    set "NVIM=\\.\pipe\neovide_v_server"
    set "V_SERVER=\\.\pipe\neovide_v_server"
    start neovide -- --listen \\.\pipe\neovide_v_server
  ) else (
    set "V_SERVER=VIM_v_server"
    start vim --servername VIM_v_server
  )
  timeout /t 1 /nobreak >nul
)

:: Launch the V_PRG with server (NeoVim server path is stored in %NVIM% or custom pipe)
if "%V_DIFF%" == "1" (
  %V_PRG% %V_SERVER_OP% %V_SERVER% --remote-tab %V_FILE_A%
  %V_PRG% %V_SERVER_OP% %V_SERVER% --remote-send "<C-\><C-n> :execute 'vert split ' . fnameescape('%V_FILE_B%') | windo diffthis<CR>"
) else (
  %V_PRG% %V_SERVER_OP% %V_SERVER% %V_REMOTE_OP% %V_ARGS%
  if %V_TERM% == 1 (
    timeout /t 1 /nobreak >nul
    %V_PRG% %V_SERVER_OP% %V_SERVER% --remote-send "<C-\><C-n> :Termhere<CR>"
  )
)
