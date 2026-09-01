@echo off
setlocal

:: ==================================================
:: Config
:: ==================================================
set "NAZ_REMOTE=gdrive:naztuff"
set "NAZ_LOCAL=D:\naztuff"
set "NAZ_FILTER_FILE_PATH=%~dp0filter.txt"
set "NAZ_LOG_FILE_PATH=%NAZ_LOCAL%\.rclone\bisync.log"
set "NAZ_LOG_LEVEL=INFO"
set "NAZ_RESYNC=0"
set "NAZ_RESYNC_MODE=newer"
set "NAZ_CONFLICT_LOSER=pathname"
set "NAZ_CONFLICT_RESOLVE=none"
set "NAZ_CONFLICT_SUFFIX=remote,local"
set "NAZ_BACKUP_PATH_REMOTE=%NAZ_REMOTE%/.rclone/backups/remote"
set "NAZ_BACKUP_PATH_LOCAL=%NAZ_LOCAL%\.rclone\backups\local"
set "NAZ_BACKUP_DELETE_EXPIRED=0"
set "NAZ_BACKUP_EXPIRED_AGE=30d"
set "NAZ_DRY_RUN="
set "NAZ_DEBUG=0"


:: ==================================================
:: Argument parsing
:: ==================================================
:loop
if "%~1" == "" goto end

if "%~1" == "--resync" (
  set "NAZ_RESYNC=1"
  shift
) else if "%~1" == "--resync-mode" (
  set "NAZ_RESYNC_MODE=%~2"
  shift
  shift
) else if "%~1" == "--log-level" (
  set "NAZ_LOG_LEVEL=%~2"
  shift
  shift
) else if "%~1" == "--conflict-loser" (
  set "NAZ_CONFLICT_LOSER=%~2"
  shift
  shift
) else if "%~1" == "--conflict-resolve" (
  set "NAZ_CONFLICT_RESOLVE=%~2"
  shift
  shift
) else if "%~1" == "--conflict-suffix" (
  set "NAZ_CONFLICT_SUFFIX=%~2"
  shift
  shift
) else if "%~1" == "--backup-delete-expired" (
  set "NAZ_BACKUP_DELETE_EXPIRED=1"
  shift
) else if "%~1" == "--backup-expired-age" (
  set "NAZ_BACKUP_EXPIRED_AGE=%~2"
  shift
  shift
) else if "%~1" == "--dry-run" (
  set "NAZ_DRY_RUN= %~1"
  shift
) else if "%~1" == "-n" (
  set "NAZ_DRY_RUN= %~1"
  shift
) else if "%~1" == "--debug" (
  set "NAZ_DEBUG=1"
  shift
) else (
  echo _WARNING_: skipping invalid argument "%~1"
  shift
)

goto loop
:end

if %NAZ_DEBUG% == 1 (
  echo NAZ_REMOTE                %NAZ_REMOTE%
  echo NAZ_LOCAL                 %NAZ_LOCAL%
  echo NAZ_FILTER_FILE_PATH      %NAZ_FILTER_FILE_PATH%
  echo NAZ_LOG_FILE_PATH         %NAZ_LOG_FILE_PATH%
  echo NAZ_LOG_LEVEL             %NAZ_LOG_LEVEL%
  echo NAZ_RESYNC                %NAZ_RESYNC%
  echo NAZ_RESYNC_MODE           %NAZ_RESYNC_MODE%
  echo NAZ_CONFLICT_LOSER        %NAZ_CONFLICT_LOSER%
  echo NAZ_CONFLICT_RESOLVE      %NAZ_CONFLICT_RESOLVE%
  echo NAZ_CONFLICT_SUFFIX       %NAZ_CONFLICT_SUFFIX%
  echo NAZ_BACKUP_PATH_REMOTE    %NAZ_BACKUP_PATH_REMOTE%
  echo NAZ_BACKUP_PATH_LOCAL     %NAZ_BACKUP_PATH_LOCAL%
  echo NAZ_BACKUP_DELETE_EXPIRED %NAZ_BACKUP_DELETE_EXPIRED%
  echo NAZ_BACKUP_EXPIRED_AGE    %NAZ_BACKUP_EXPIRED_AGE%
  echo NAZ_DRY_RUN               %NAZ_DRY_RUN%
)

:: ==================================================
:: Commands & Run
:: ==================================================
echo Path1 ^(REMOTE^) "%NAZ_REMOTE%"
echo Path2 ^(LOCAL^)  "%NAZ_LOCAL%"

if not exist "%NAZ_LOCAL%" (
  mkdir "%NAZ_LOCAL%"
)
if not exist "%NAZ_LOCAL%\.rclone" (
  mkdir "%NAZ_LOCAL%\.rclone"
)

set "BISYNC_CMD=rclone bisync %NAZ_REMOTE% %NAZ_LOCAL% --workdir %NAZ_LOCAL%\.rclone\workdir --filters-file "%NAZ_FILTER_FILE_PATH%" --log-file %NAZ_LOG_FILE_PATH% --log-level %NAZ_LOG_LEVEL% --progress%NAZ_DRY_RUN%"

set "DELETE_CMD=rclone delete --rmdirs --min-age %NAZ_BACKUP_EXPIRED_AGE% --log-file %NAZ_LOG_FILE_PATH% --log-level %NAZ_LOG_LEVEL% --progress%NAZ_DRY_RUN%"

if %NAZ_RESYNC% == 1 (
  %BISYNC_CMD% --resync --resync-mode %NAZ_RESYNC_MODE% --create-empty-src-dirs
) else (
  %BISYNC_CMD% --backup-dir1 %NAZ_BACKUP_PATH_REMOTE% --backup-dir2 %NAZ_BACKUP_PATH_LOCAL% --conflict-loser %NAZ_CONFLICT_LOSER% --conflict-resolve %NAZ_CONFLICT_RESOLVE% --conflict-suffix %NAZ_CONFLICT_SUFFIX%
)

if %NAZ_BACKUP_DELETE_EXPIRED% == 1 (
  echo Cleaning expired backups: %NAZ_BACKUP_EXPIRED_AGE%

  %DELETE_CMD% %NAZ_BACKUP_PATH_REMOTE%
  if exist "%NAZ_BACKUP_PATH_LOCAL%" (
    %DELETE_CMD% %NAZ_BACKUP_PATH_LOCAL%
  )
)

echo _INFO_: rclone operation log file path: %NAZ_LOG_FILE_PATH%
