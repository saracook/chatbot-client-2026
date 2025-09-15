#!/bin/bash

# Do we have fio installed?
type fio >/dev/null 2>&1
if [ $? -ne 0 ] ;
then
   echo -e "\nfio is not installed. Exiting...\n"
   exit 1
fi

## VARIABLES
#
# This node
THIS_HOST=`hostname -s`
#
# Today
TODAY=`date +%Y%m%d`
#
# Now
NOW=`date +%Y%m%d_%H%M%S`
#
####################################################################################################
#
# CHANGE THE TEST PARAMETERS ADJUSTING ONLY THE VARIABLES INSIDE THIS BLOCK!!!!!!!!!!!!!!!!!!!
#
####################################################################################################
#
# List of filesystems test directories. Here we create files to read from and write to during the fio tests.
# NOTE: a bunch of files will be created for the test. Please use/define a specific test sub-directory in the filesystem.
# Please put here all the filesystems mount points that will be tested, with a specific test directory (space separated list, no trailing slash)
#TEST_DIRS="/gpfs/gpfs0/benchmark /gpfs/gpfs1/benchmark"
TEST_DIRS="/var/lib/kubelet/plugins/kubernetes.io/csi/pv/cephfs-static-pi-slurm/globalmount/tmp /var/lib/kubelet/plugins/kubernetes.io/csi/pv/cephfs-static-home-slurm/globalmount/tmp"
#
# The output directory for the tests results. Here we save the tests outputs. PLease no trailing "/".
OUT_DIR="/var/lib/kubelet/plugins/kubernetes.io/csi/pv/cephfs-static-pi-slurm/globalmount/tmp/outputs"
#
# List of test patterns that will be executed
TEST_LIST="read write randrw"
#TEST_LIST="read write"
#
# List of IO block sizes that will be tested
#BS_LIST="4k 1M 16M"
BS_LIST="4K 1M 4M"
#
# Number of jobs (IO streams) to be started. It represents the number of files fio will create in the target directory.
#JOBS=32
JOBS=8
#
# Size of each test file to be created (NOTE: the total disk space used during the tests is equal to F_SIZE * JOBS)
F_SIZE=512mb
#F_SIZE=32mb
#
# Will be test buffered and unbuffered IO? 0 means buffered IO and 1 means direct IO
IO_TYPE_LIST="1 0" # both
#IO_TYPE_LIST="1"   # direct IO only
#IO_TYPE_LIST="0"   # buffered IO only
#
# Maximum running time in seconds
RUNTIME=60
#
####################################################################################################
#
# DO NOT CHANGE ANYTHING BELOW THIS LINE
#
####################################################################################################
#
# Creating the outputs directory
BENCHMARK_OUT_DIR="${OUT_DIR}/benchmark_tests_${THIS_HOST}_${TODAY}"
[ ! -d $BENCHMARK_OUT_DIR ] && mkdir -p $BENCHMARK_OUT_DIR
#
# Create the IO directotries
for i in $TEST_DIRS
do
   [ ! -d $i ] && mkdir $i
   [ ! -d ${i}/${THIS_HOST} ] && mkdir ${i}/${THIS_HOST}
done
#
# Define the output file name
OUT_FILE_NAME="${BENCHMARK_OUT_DIR}/fio_${THIS_HOST}_${NOW}.out"
#
#
## TEST MAIN LOOP
#
for FS in $TEST_DIRS
do
   echo -e "==========\n##### TESTING FILESYSTEM $FS\n==========\n"
   echo -e "Filesystem usage (df):"
   df -Th $FS
   echo
   echo -e "Mount options:"
   mpoint=`df -hT $FS | grep -v "Mounted on" | awk '{print $NF}'`
   grep -w $mpoint /proc/mounts
   echo
   type stat >/dev/null 2>&1
   if [ $? -eq 0 ] ;
   then
      echo -e "FS block size:"
      stat -fc %s $FS
      echo
   fi
   for BS in $BS_LIST
   do
       #echo -e "=====\n#### TESTING BLOCK SIZE $BS\n=====\n"
       for TEST in $TEST_LIST
       do
          #echo -e "### STARTING $TEST TESTS\n"
          # In the for statement below: 1 means direct IO and 0 means buffered IO
	  for TYPE in $IO_TYPE_LIST
          do
             if [ $TYPE -eq 1 ] ;
             then
                echo "## TEST: $FS, $BS block size, $TEST IO, direct"
             else
                echo "## TEST: $FS, $BS block size, $TEST IO, buffered"
             fi
             date
             echo -e "# COMMAND ISSUED: fio --name=\"fio_benchmark_${THIS_HOST}\" --size=${F_SIZE} --rw=${TEST} --bs=${BS} --direct=${TYPE} --numjobs=${JOBS} --ioengine=libaio --group_reporting --runtime=${RUNTIME} --directory=${FS}/${THIS_HOST}\n"
             echo "#"
             # Here it goes: the actual test command
             fio --name="fio_benchmark_${THIS_HOST}" --size=${F_SIZE} --rw=${TEST} --bs=${BS} --direct=${TYPE} --numjobs=${JOBS} --ioengine=libaio --group_reporting --runtime=${RUNTIME} --directory=${FS}/${THIS_HOST}
             sleep 3
             echo "#"
          done
       done
       #echo -e "\n====================================================\n"
   done
   echo -e "====================================================\n\n"
   # Cleaning up the test files ->>>>>> I'm not removing it automatically in case we need to run more tests. Then there is no need to lay out new test files every time.
   #/bin/rm -f ${FS}/${THIS_HOST}/fio_benchmark*.0
   #/bin/rmdir ${FS}/${THIS_HOST}
done | tee ${OUT_FILE_NAME}

# Output file and tip for summary of tests report
echo -e "The full test results output file is: ${OUT_FILE_NAME}\n\n"
echo -e "To create a summary report, please run the following command:"
echo -e "   grep -E '^#|^=|read: |write: ' ${OUT_FILE_NAME}\n"
echo -e "\nIf you will not run additional tests, you can remove the test files created by this node under the test directories: $TEST_DIRS\n\n"

# Nice exit
exit 0

