@echo off

:: v [--vim] <-e or -t> [Vim/Nvim arguments]
:: Possible commands ...
:: Neovide/NeoVim:
::   > v (`nvim --server $NVIM` --remote .)
::   > v -e <NVIM ARGS> (`nvim --server $NVIM` --remote <NVIM ARGS>)
::   > v -t <NVIM ARGS> (`nvim --server $NVIM` --remote-tab <NVIM ARGS>)
:: Vim:
::   > v --vim (`vim --server VIM --remote .`)
::   > v --vim -e <VIM ARGS> (`vim --server VIM --remote <VIM ARGS>`)
::   > v --vim -t <VIM ARGS> (`vim --server VIM --remote-tab <VIM ARGS>`)

set "V_PRG="
set "V_SERVER="
set "V_REMOTE_OP=--remote"
set "V_ARGS="

:: Check for the `--vim` (only on %1) flag to set V_PRG to Vim or NeoVim
if "%~1" == "--vim" (
  set "V_PRG=vim"
  set "V_SERVER=VIM"
  shift
) else (
  set "V_PRG=nvim"
  set "V_SERVER=%NVIM%"
)

:: Set var based on the flag `-e = --remote` or `-t = remote-tab)`
if "%~1" == "-e" (
  shift
) else if "%~1" == "-t" (
  set "V_REMOTE_OP=--remote-tab"
  shift
)

:: If there are no arguments left, default to current directory
if "%~1" == "" (
  set "V_ARGS=."
  goto end
)

:: Prevent leading zero on the first argument
if "%V_ARGS%" == "" (
  set "V_ARGS=%~1"
  shift
)

:: Build variable with every arg from the new %1 onwards
:loop
if "%~1" == "" goto end
set "V_ARGS=%V_ARGS% %1"
shift
goto loop
:end

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
echo Run: %V_PRG% --server %V_SERVER% %V_REMOTE_OP% %V_ARGS%
%V_PRG% --server %V_SERVER% %V_REMOTE_OP% %V_ARGS%
