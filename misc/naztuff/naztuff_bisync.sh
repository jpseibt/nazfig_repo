#!/usr/bin/env bash

#==================================================
# Config
#==================================================
NAZ_REMOTE="gdrive:naztuff"
NAZ_LOCAL="/mnt/Win/D/naztuff"
NAZ_FILTER_FILE_PATH="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/filter.txt"
NAZ_LOG_FILE_PATH="$NAZ_LOCAL/.rclone/bisync.log"
NAZ_LOG_LEVEL="INFO"
NAZ_RESYNC="0"
NAZ_RESYNC_MODE="newer"
NAZ_CONFLICT_LOSER="pathname"
NAZ_CONFLICT_RESOLVE="none"
NAZ_CONFLICT_SUFFIX="remote,local"
NAZ_BACKUP_PATH_REMOTE="$NAZ_REMOTE/.rclone/backups/remote"
NAZ_BACKUP_PATH_LOCAL="$NAZ_LOCAL/.rclone/backups/local"
NAZ_BACKUP_DELETE_EXPIRED="0"
NAZ_BACKUP_EXPIRED_AGE="30d"
NAZ_DRY_RUN=""
NAZ_DEBUG=0


#==================================================
# Argument parsing
#==================================================
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --resync)
      NAZ_RESYNC=1
      shift
      ;;
    --resync-mode)
      NAZ_RESYNC_MODE="$2"
      shift 2
      ;;
    --log-level)
      NAZ_LOG_LEVEL="$2"
      shift 2
      ;;
    --conflict-loser)
      NAZ_CONFLICT_LOSER="$2"
      shift 2
      ;;
    --conflict-resolve)
      NAZ_CONFLICT_RESOLVE="$2"
      shift 2
      ;;
    --conflict-suffix)
      NAZ_CONFLICT_SUFFIX="$2"
      shift 2
      ;;
    --backup-delete-expired)
      NAZ_BACKUP_DELETE_EXPIRED=1
      shift
      ;;
    --backup-expired-age)
      NAZ_BACKUP_EXPIRED_AGE="$2"
      shift 2
      ;;
    --dry-run|-n)
      NAZ_DRY_RUN="$1"
      shift
      ;;
    --debug)
      NAZ_DEBUG=1
      shift
      ;;
    *)
      echo "_WARNING_: skipping invalid argument $1"
      shift
      ;;
  esac
done

if [ "$NAZ_DEBUG" -eq 1 ]; then
  echo "NAZ_REMOTE                $NAZ_REMOTE"
  echo "NAZ_LOCAL                 $NAZ_LOCAL"
  echo "NAZ_FILTER_FILE_PATH      $NAZ_FILTER_FILE_PATH"
  echo "NAZ_LOG_FILE_PATH         $NAZ_LOG_FILE_PATH"
  echo "NAZ_LOG_LEVEL             $NAZ_LOG_LEVEL"
  echo "NAZ_RESYNC                $NAZ_RESYNC"
  echo "NAZ_RESYNC_MODE           $NAZ_RESYNC_MODE"
  echo "NAZ_CONFLICT_LOSER        $NAZ_CONFLICT_LOSER"
  echo "NAZ_CONFLICT_RESOLVE      $NAZ_CONFLICT_RESOLVE"
  echo "NAZ_CONFLICT_SUFFIX       $NAZ_CONFLICT_SUFFIX"
  echo "NAZ_BACKUP_PATH_REMOTE    $NAZ_BACKUP_PATH_REMOTE"
  echo "NAZ_BACKUP_PATH_LOCAL     $NAZ_BACKUP_PATH_LOCAL"
  echo "NAZ_BACKUP_DELETE_EXPIRED $NAZ_BACKUP_DELETE_EXPIRED"
  echo "NAZ_BACKUP_EXPIRED_AGE    $NAZ_BACKUP_EXPIRED_AGE"
  echo "NAZ_DRY_RUN               $NAZ_DRY_RUN"
fi


#==================================================
# Commands & Run
#==================================================
#------------------------------
# Check directories and construct commands
#
echo "Path1 (REMOTE) $NAZ_REMOTE"
echo "Path2 (LOCAL)  $NAZ_LOCAL"

if [ ! -d "$NAZ_LOCAL" ]; then
  mkdir -p "$NAZ_LOCAL"
fi
if [ ! -d "$NAZ_LOCAL/.rclone" ]; then
  mkdir -p "$NAZ_LOCAL/.rclone"
fi

BISYNC_CMD=(
  rclone bisync "$NAZ_REMOTE" "$NAZ_LOCAL"
  --workdir "$NAZ_LOCAL/.rclone/workdir"
  --filters-file "$NAZ_FILTER_FILE_PATH"
  --log-file $NAZ_LOG_FILE_PATH
  --log-level $NAZ_LOG_LEVEL
  --progress
)

DELETE_CMD=(
  rclone delete --rmdirs --min-age "$NAZ_BACKUP_EXPIRED_AGE"
  --log-file "$NAZ_LOG_FILE_PATH"
  --log-level "$NAZ_LOG_LEVEL"
  --progress
)

if [ -n "$NAZ_DRY_RUN" ]; then
  BISYNC_CMD+=("$NAZ_DRY_RUN") 
  DELETE_CMD+=("$NAZ_DRY_RUN") 
fi

#------------------------------
# Execute commands
#
if [ "$NAZ_RESYNC" -eq 1 ]; then
  "${BISYNC_CMD[@]}" --resync --resync-mode "$NAZ_RESYNC_MODE" --create-empty-src-dirs
else
  "${BISYNC_CMD[@]}" --backup-dir1 "$NAZ_BACKUP_PATH_REMOTE" --backup-dir2 "$NAZ_BACKUP_PATH_LOCAL" --conflict-loser "$NAZ_CONFLICT_LOSER" --conflict-resolve "$NAZ_CONFLICT_RESOLVE" --conflict-suffix "$NAZ_CONFLICT_SUFFIX"
fi

if [ "$NAZ_BACKUP_DELETE_EXPIRED" -eq 1 ]; then
  echo Cleaning expired backups: "$NAZ_BACKUP_EXPIRED_AGE"

  "${DELETE_CMD[@]}" "$NAZ_BACKUP_PATH_REMOTE"
  if [ -d "$NAZ_BACKUP_PATH_LOCAL" ]; then
    "${DELETE_CMD[@]}" "$NAZ_BACKUP_PATH_LOCAL"
  fi
fi

echo _INFO_: rclone operation log file path: "$NAZ_LOG_FILE_PATH"
