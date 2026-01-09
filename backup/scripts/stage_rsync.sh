#!/bin/bash

# Show usage help
if [[ $# -lt 4 || $# -gt 8 ]]; then
echo "Usage: $0 <folder_depth> <split_count> <backupDir> <sourcePath> [dryrun] [remove_string] [snap] [snap_folder]"
echo
echo "  folder_depth : How deep to search for folders (e.g. 4)"
echo "  split_count  : Number of entries per batch file (e.g. 1)"
echo "  backupDir    : Full target directory on remote server"
echo "  sourcePath   : Full path to the source folder to sync from"
echo "  dryrun       : (optional) If set, adds --dry-run to rsync"
echo "  remove_string: (optional) String to remove from each batch file AND append to rsync source path"
echo "  snap         : (optional) 'snap' to enable snapshot mode"
echo "  snap_folder  : (optional) Path containing snapshot folders to use"
exit 1
fi

# Assign passed-in variables
folder_depth="$1"
split_count="$2"
backupDir="$3"
path="$4"
dryrun_flag="${5:-}"
remove_string="${6:-}"
snap_enabled="${7:-}"
snap_folder="${8:-}"

# Determine if dryrun is enabled
if [[ "$dryrun_flag" == "dryrun" ]]; then
rsync_dry_option="--dry-run"
dryrun_used=true
else
rsync_dry_option=""
dryrun_used=false
fi

# Other setup
date=$(date +y_m_d_s_%Y_%m_%d_%S)
timestamp_folder=$(date "+%d_%b_%Y_%I:%M%p" | sed 's/:/_/g')

DatamoverIPAddresses="10.220.8.93 10.220.8.91 10.220.8.92 10.220.8.90"
userNameSSH=root
userKey=/home/wenzie/.ssh/id_rsa
workdirRoot=$(pwd)

# NEW: Snap support
if [[ "$snap_enabled" == "snap" && -n "$snap_folder" ]]; then
# Find latest snapshot folder
latest_snap=$(ls -1d "$snap_folder"/*/ 2>/dev/null | sort -V | tail -n 1)
if [[ -z "$latest_snap" ]]; then
echo "ERROR: No snapshots found in $snap_folder"
exit 1
fi
path="$latest_snap"
fi

# Build derived path
path_just_above_volume=$(dirname "$path")

# NEW — Adjust rsync source path if remove_string is provided
if [[ -n "$remove_string" ]]; then
adjusted_source="$path/$remove_string/"
else
adjusted_source="$path/"
fi

# Setup directories
workDir="$workdirRoot"
batchDir="$workDir/batches/batch_$timestamp_folder"
logDir="$workDir/logs/logs_$timestamp_folder"
mkdir -p "$batchDir"
mkdir -p "$logDir"

# Ensure exclude.list exists
exclude_file="$workDir/exclude.list"
if [[ ! -f "$exclude_file" ]]; then
touch "$exclude_file"
fi

# Define file list
list="list_of_dirs_$date"
rm -f "$workDir/$list"

# Generate file list with optional exclusions
folder_depth_minus_one=$folder_depth
folder_depth_minus_one=$((folder_depth_minus_one-1))

while [[ $folder_depth_minus_one -gt 0 && $folder_depth_minus_one -lt $folder_depth ]]; do
find "$path" -maxdepth "$folder_depth_minus_one" -mindepth "$folder_depth_minus_one" \( -type f -o -type l \) \
| sed "s~$path_just_above_volume/~~g" \
| grep -v -f "$exclude_file" \
| sort -R >> "$workDir/$list"
((folder_depth_minus_one--))
done

find "$path" -maxdepth "$folder_depth" -mindepth "$folder_depth" \( -type d -o -type l -o -type f \) \
| sed "s~$path_just_above_volume/~~g" \
| grep -v -f "$exclude_file" \
| sort -R >> "$workDir/$list"

# Split into batch files
split -l "$split_count" -a 6 -d "$workDir/$list" "$batchDir/batch_"

# NEW — remove strings from each batch file if provided / snapshot cleanup
for bfile in "$batchDir"/batch_*; do
# Remove the remove_string if present
if [[ -n "$remove_string" ]]; then
sed -i "s~$remove_string/~~g" "$bfile"
fi
# Remove snapshot folder pattern (_scheduled-YYYY-MM-DD-HH_MM_SS_UTC_X)
sed -i 's~_scheduled-[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}-[0-9]\{2\}_[0-9]\{2\}_[0-9]\{2\}_UTC_[0-9]\+\/~~g' "$bfile"
done

# Generate run script
run_script="$workDir/run_this_to_copy_files.sh"
echo > "$run_script"

batch_list=$(find "$batchDir" -mindepth 1 -maxdepth 1 -type f -name "batch_*")

# Combined error log for all batches
combined_error_log="$workDir/all_rsync_errors.log"
rm -f "$combined_error_log"

# ----------------- for loop (rollback version) -----------------
for i in $batch_list; do
line="${i/.\//}"
chop_line_to_batch_id=${line: -10}
selectedIPAddress=$(shuf -e $DatamoverIPAddresses -n 1)

# Remove remove_string from adjusted_source dynamically
rsync_source="$adjusted_source"
if [[ -n "$remove_string" ]]; then
rsync_source="${rsync_source%/$remove_string/}"
fi
# Ensure exactly one trailing slash
rsync_source="${rsync_source%/}/"

## Local mount mode (DEEP ONLY CHANGE → uses $rsync_source)
echo "rsync -Artplv $rsync_dry_option --stats --numeric-ids --no-whole-file --delete --files-from=$line --log-file=\"$logDir/$date-$chop_line_to_batch_id.log\" $rsync_source  $backupDir 1>\"$logDir/$date-$chop_line_to_batch_id.log.stdout\" 2>\"$logDir/$date-$chop_line_to_batch_id.error.log\"; echo \"$line ### $logDir/$date-$chop_line_to_batch_id.log\" >> \"$combined_error_log\";cat \"$logDir/$date-$chop_line_to_batch_id.error.log\" >> \"$combined_error_log\"" >> "$run_script"
done
# -------------------------------------------------------------

chmod 700 "$run_script"
echo
echo "Generated run script: $run_script"
echo "Run with: ./controlled_runner.sh $run_script <max_parallel_jobs>"

# Added summary
job_count=$(wc -l < "$run_script")
echo "Total rsync jobs in run script: $job_count"
echo
echo "This will copy contents of: $path"
echo "Into remote backup location: $backupDir"
echo "Logs stored here: $logDir"
echo "Batches stored here: $batchDir"
echo

# remove list file
rm -f "$workDir/$list"

# Note dryrun status
if $dryrun_used; then
echo "NOTE: Script will run in DRY-RUN mode (no files will be copied) once invoked."
else
echo "NOTE: Script will run in NORMAL mode (real copy will occur) once invoked."
fi

echo
echo "All individual rsync error logs will be collected into:"
echo "  $combined_error_log"
