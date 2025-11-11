#!/bin/bash
#
# This script will set the L_SCRATCH* env variables
# Directory creation and permissions setting is done in prolog.sh

LOCAL_SCRATCH_ROOT="/local/scratch"
LOCAL_SCRATCH_USER=$LOCAL_SCRATCH_ROOT/$USER
LOCAL_SCRATCH_JOB=$LOCAL_SCRATCH_USER/$SLURM_JOB_ID

echo "export L_SCRATCH_USER=$LOCAL_SCRATCH_USER"
echo "export L_SCRATCH_JOB=$LOCAL_SCRATCH_JOB"
echo "export L_SCRATCH=$LOCAL_SCRATCH_USER"

exit 0
