
#!/bin/bash
# remove logs over one week
find /z/backup-scripts/home/dfc1195b-889d-4123-9a99-c223bb9cc830/logs -mtime +7 -exec rm {} \;
# Max allowed rsync processes
MAX_RSYNC=10
# Log file
LOGFILE="/var/log/home_backup_cron.log"
# Count active rsync processes
RSYNC_COUNT=$(pgrep -fc rsync)
if [ "$RSYNC_COUNT" -gt "$MAX_RSYNC" ]; then
            echo "[$(date)] Too many rsync processes running ($RSYNC_COUNT). Skipping backup." >> "$LOGFILE"
                exit 1
fi
echo "[$(date)] Starting stage_home_backups.sh" >> "$LOGFILE"
/z/backup-scripts/stage_home_backups.sh >> "$LOGFILE" 2>&1
if [ $? -ne 0 ]; then
            echo "[$(date)] stage_home_backups.sh failed. Exiting." >> "$LOGFILE"
                exit 1
fi
echo "[$(date)] Starting run_this_to_copy_files_dfc1195b-889d-4123-9a99-c223bb9cc830.sh" >> "$LOGFILE"
/z/backup-scripts/run_this_to_copy_files_dfc1195b-889d-4123-9a99-c223bb9cc830.sh >> "$LOGFILE" 2>&1
if [ $? -eq 0 ]; then
            echo "[$(date)] Backup completed successfully." >> "$LOGFILE"
    else
                echo "[$(date)] run_this_to_copy_files_dfc1195b-889d-4123-9a99-c223bb9cc830.sh failed." >> "$LOGFILE"
fi

