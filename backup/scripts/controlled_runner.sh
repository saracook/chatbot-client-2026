
#!/bin/bash



# === Argument Check ===

if [[ $# -ne 2 || -z "$1" || -z "$2" ]]; then

echo "Usage: $0 <input_file> <max_parallel_jobs>"

exit 1

fi



INPUT_FILE="$1"

MAX_JOBS="$2"



# Check input file

if [[ ! -f "$INPUT_FILE" ]]; then

echo "[!] Error: Input file '$INPUT_FILE' not found."

exit 1

fi



mapfile -t COMMANDS < "$INPUT_FILE"

TOTAL_CMDS="${#COMMANDS[@]}"

CMDS_STARTED=0

PIDS=()

declare -A CMD_MAP

NEXT_CMD_INDEX=0



LOG_FILE="rsync_jobs_aborted_errored.log"

rm -f "$LOG_FILE"



# Combined error log for all batches

combined_error_log="all_rsync_errors.log"

rm -f "$combined_error_log"





USER_KILL=false



log_failure() {

local msg="$1"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] $msg" >> "$LOG_FILE"

}



# Global Ctrl+C handler

handle_global_sigint() {

echo -e "\n[!] Caught Ctrl+C. Terminating all jobs..."

USER_KILL=true

for pid in "${PIDS[@]}"; do

if kill -0 "$pid" 2>/dev/null; then

log_failure "[PID $pid] Command killed by user (Ctrl+C): ${CMD_MAP[$pid]} | Batch file: $INPUT_FILE | Log file: $LOG_FILE"

kill -TERM "$pid" 2>/dev/null

fi

done

exit 1

}

trap handle_global_sigint SIGINT



# Run command in a subshell with inline signal trapping

run_and_track() {

local cmd="$1"

local line_number="$2"



# Wrap command in inline shell that logs SIGTERM/SIGINT

bash -c "

trap 'echo \"[PID \$\$] Command killed by signal (SIGINT/SIGTERM): $cmd | Batch file: $INPUT_FILE | Log file: $LOG_FILE\" >> $LOG_FILE; exit 130' SIGINT SIGTERM

$cmd

" &

local child_pid=$!

PIDS+=($child_pid)

CMD_MAP[$child_pid]="$cmd"

}



check_finished_pids() {

for i in "${!PIDS[@]}"; do

local pid="${PIDS[$i]}"

if ! kill -0 "$pid" 2>/dev/null; then

wait "$pid" 2>/dev/null

local status=$?

local cmd="${CMD_MAP[$pid]:-[unknown]}"



if [[ $status -ge 128 ]]; then

local sig=$((status - 128))

log_failure "[PID $pid] Command killed by signal $sig: $cmd | Batch file: $INPUT_FILE | Log file: $LOG_FILE"

elif [[ $status -ne 0 ]]; then

log_failure "[PID $pid] Command failed (exit $status): $cmd | Batch file: $INPUT_FILE | Log file: $LOG_FILE"

fi



unset 'PIDS[i]'

unset 'CMD_MAP[$pid]'

fi

done

PIDS=("${PIDS[@]}")  # compact array

}



echo "[*] Total commands to run: $TOTAL_CMDS"



while [[ $CMDS_STARTED -lt $TOTAL_CMDS || ${#PIDS[@]} -gt 0 ]]; do

while [[ ${#PIDS[@]} -lt $MAX_JOBS && $NEXT_CMD_INDEX -lt $TOTAL_CMDS ]]; do

run_and_track "${COMMANDS[$NEXT_CMD_INDEX]}" "$((NEXT_CMD_INDEX+1))"

((CMDS_STARTED++))

((NEXT_CMD_INDEX++))

done



if [[ ${#PIDS[@]} -gt 0 ]]; then

wait -n 2>/dev/null

check_finished_pids

fi



now=$(date "+%H:%M:%S")

echo -ne "[${now}] Running: ${#PIDS[@]}/$MAX_JOBS | Started: $CMDS_STARTED/$TOTAL_CMDS\r"

done



echo -e "\n[✔] All jobs completed."


