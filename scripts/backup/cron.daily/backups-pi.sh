#!/bin/bash
# Clean logs over one week
find /z/backup-scripts/8a38c8df-cfcd-4d8c-bee5-ad121dcc50b3/pi/logs -type f -mtime +7 -exec rm {} \;
# Max allowed rsync processes
MAX_RSYNC=10
# Count current running rsync processes (excluding this script itself)
RSYNC_COUNT=$(pgrep -fc rsync)
if [ "$RSYNC_COUNT" -gt "$MAX_RSYNC" ]; then
  echo "[$(date)] More than $MAX_RSYNC rsync processes running ($RSYNC_COUNT). Exiting." >> /var/log/pi_backup_cron.log
  exit 1
fi
# Run stage_pi_backups.sh
echo "[$(date)] Starting stage_pi_backups.sh" >> /var/log/pi_backup_cron.log
/z/backup-scripts/stage_pi_backups.sh
if [ $? -ne 0 ]; then
  echo "[$(date)] stage_pi_backups.sh failed. Exiting." >> /var/log/pi_backup_cron.log
  exit 1
fi
# Run run_this_to_copy_files_pi.sh
echo "[$(date)] Starting run_this_to_copy_files_pi.sh" >> /var/log/pi_backup_cron.log
/z/backup-scripts/run_this_to_copy_files_pi.sh
if [ $? -eq 0 ]; then
  echo "[$(date)] Backup completed successfully." >> /var/log/pi_backup_cron.log
else
  echo "[$(date)] run_this_to_copy_files_pi.sh failed." >> /var/log/pi_backup_cron.log
fi
