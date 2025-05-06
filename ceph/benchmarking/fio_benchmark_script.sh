#!/bin/bash

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
# List of filesystems test directories (NOTE: a bunch of files will be created for the test. Please use/define a specific test sub-directory in the filesystem)
# Please put here all the filesystems mount points that will be tested, with a specific test directory (space separated list, no trailing slash)
#TEST_DIRS="/gpfs/gpfs0/fio /gpfs/gpfs1/fio"
TEST_DIRS="/var/tmp/fio1 /var/tmp/fio2"
for i in $TEST_DIRS
do
   [ ! -d $i ] && mkdir $i
   [ ! -d ${i}/${THIS_HOST} ] && mkdir ${i}/${THIS_HOST}
done
#
# List of test patterns that will be executed
#TEST_LIST="read write randrw"
TEST_LIST="read write"
#
# List of IO block sizes that will be tested
#BS_LIST="4k 1M 16M"
BS_LIST="1M 4M"
#
# Size of each test file to be created (NOTE: the total disk space used during the tests is equal to F_SIZE * JOBS)
#F_SIZE=512mb
F_SIZE=16mb
#
# Will be test buffered and unbuffered IO? 0 means buffered IO and 1 means direct IO
#IO_TYPE_LIST="1 0" # both
IO_TYPE_LIST="1"   # direct IO only
#IO_TYPE_LIST="0"   # buffered IO only
#
# Number of jobs to be started
#JOBS=32
JOBS=2
#
# Maximum running time in seconds
RUNTIME=120
#
# The output directory for the tests results
BENCHMARK_OUT_DIR=/tmp/benchmark_tests_${TODAY}
[ ! -d $BENCHMARK_OUT_DIR ] && mkdir -p $BENCHMARK_OUT_DIR
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
             /usr/bin/fio --name="fio_benchmark_${THIS_HOST}" --size=${F_SIZE} --rw=${TEST} --bs=${BS} --direct=${TYPE} --numjobs=${JOBS} --ioengine=libaio --group_reporting --runtime=${RUNTIME} --directory=${FS}/${THIS_HOST}
             sleep 3
             echo "#"
          done
       done
       #echo -e "\n====================================================\n"
   done
   echo -e "====================================================\n\n"
   # Cleaning up the test files ->>>>>> I'm not removing it automatically in case we need to run more tests. Then there is no need ot lay out new test files every time.
   #/bin/rm -f ${FS}/${THIS_HOST}/fio_benchmark*.0
   #/bin/rmdir ${FS}/${THIS_HOST}
done | tee ${BENCHMARK_OUT_DIR}/fio_${THIS_HOST}_${NOW}.out

# Output file and tip for summary of tests report
echo -e "The full test results output file is: ${BENCHMARK_OUT_DIR}/fio_${THIS_HOST}_${NOW}.out\n\n"
echo -e "To create a summary report, please run the following command:"
echo -e "   grep -E '^#|^=|read: |write: ' ${BENCHMARK_OUT_DIR}/fio_${THIS_HOST}_${NOW}.out\n"
echo -e "\nIf you will not run additional tests, you can remove the test files created by this test node undder the test directories defined: $TEST_DIRS\n\n"

# Nice exit
exit 0
