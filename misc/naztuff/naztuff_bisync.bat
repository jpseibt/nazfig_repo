@echo off

:: ==================================================
:: Config
:: ==================================================
set "REMOTE=gdrive:naztuff"
set "LOCAL=D:\naztuff"
set "LOG_FILE_PATH=%LOCAL%\.rclone\bisync.log"
set "LOG_LEVEL=INFO"
set "RESYNC=0"
set "RESYNC_MODE=newer"
set "CONFLICT_LOSER=pathname"
set "CONFLICT_RESOLVE=none"
set "CONFLICT_SUFFIX=remote,local"
set "BACKUP_PATH_REMOTE=%REMOTE%/.rclone/backups/remote"
set "BACKUP_PATH_LOCAL=%LOCAL%\.rclone\backups\local"
set "BACKUP_DELETE_EXPIRED=0"
set "BACKUP_EXPIRED_AGE=64d"
set "DRY_RUN="


:: ==================================================
:: Argument parsing
:: ==================================================
:loop
if "%~1" == "" goto end

if "%~1" == "--resync" (
  set "RESYNC=1"
  shift
) else if "%~1" == "--resync-mode" (
  set "RESYNC_MODE=%~2"
  shift
  shift
) else if "%~1" == "--log-level" (
  set "LOG_LEVEL=%~2"
  shift
  shift
) else if "%~1" == "--conflict-loser" (
  set "CONFLICT_LOSER=%~2"
  shift
  shift
) else if "%~1" == "--conflict-resolve" (
  set "CONFLICT_RESOLVE=%~2"
  shift
  shift
) else if "%~1" == "--conflict-suffix" (
  set "CONFLICT_SUFFIX=%~2"
  shift
  shift
) else if "%~1" == "--backup-delete-expired" (
  set "BACKUP_DELETE_EXPIRED=1"
  shift
) else if "%~1" == "--backup-expired-age" (
  set "BACKUP_EXPIRED_AGE=%~2"
  shift
  shift
) else if "%~1" == "--dry-run" (
  set "DRY_RUN= %~1"
  shift
) else if "%~1" == "-n" (
  set "DRY_RUN= %~1"
  shift
) else (
  echo _WARNING_: skipping invalid argument "%~1"
  shift
)

goto loop
:end


:: ==================================================
:: Commands & Run
:: ==================================================
set "BISYNC_CMD=rclone bisync %REMOTE% %LOCAL% --workdir %LOCAL%\.rclone\workdir --filters-file %LOCAL%\.rclone\filter.txt --log-file %LOG_FILE_PATH% --log-level %LOG_LEVEL% --progress%DRY_RUN%"

set "DELETE_CMD=rclone delete --rmdirs --min-age %BACKUP_EXPIRED_AGE% --log-file %LOG_FILE_PATH% --log-level %LOG_LEVEL% --progress%DRY_RUN%"

if %RESYNC% == 1 (
  %BISYNC_CMD% --resync --resync-mode %RESYNC_MODE% --create-empty-src-dirs
) else (
  %BISYNC_CMD% --backup-dir1 %BACKUP_PATH_REMOTE% --backup-dir2 %BACKUP_PATH_LOCAL% --conflict-loser %CONFLICT_LOSER% --conflict-resolve %CONFLICT_RESOLVE% --conflict-suffix %CONFLICT_SUFFIX%
)

if %BACKUP_DELETE_EXPIRED% == 1 (
  echo Cleaning expired backups: %BACKUP_EXPIRED_AGE%
  echo Remote path: %BACKUP_PATH_REMOTE%
  echo Local path:  %BACKUP_PATH_LOCAL%

  %DELETE_CMD% %BACKUP_PATH_REMOTE%
  if exist "%BACKUP_PATH_LOCAL%" (
    %DELETE_CMD% %BACKUP_PATH_LOCAL%
  )
)

echo _INFO_: rclone operation log file path: %LOG_FILE_PATH%
