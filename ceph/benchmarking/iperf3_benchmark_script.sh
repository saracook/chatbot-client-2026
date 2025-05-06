#!/bin/bash

# iperf3 test script

## TEST PARAMETERS
#
# Today
TODAY=`date +%Y%m%d`
#
# Now
NOW=`date +%Y%m%d_%H%M%S`
#
# Target node(s) IP(s) (space separated list)
#nodeIPs="192.168.206.51 192.168.205.51"
nodeIPs="192.168.206.51"
#
# Test duration in seconds
TDURATION=120
#
# Number of parallel data streams per process (iperf3 process is single-threaded, though)
#TJOBS=8
TJOBS=2
#
# Number of simultaneous iperf3 processes (it will start this number of simultaneous iperf3 processes in the sender node, each one with TJOBS streams)
# Minimum value is 2
#NIPERF3=16
NIPERF3=2
#
# The output directory for the tests results
BENCHMARK_OUT_DIR=/tmp/benchmark_tests_${TODAY}
[ ! -d $BENCHMARK_OUT_DIR ] && mkdir -p $BENCHMARK_OUT_DIR
#
# Target ports (sockets that will be created at the receiver side)
PORTS=""
for i in `seq 1 $NIPERF3`
do
   N=`printf "%02d" $i`
   PORTS="$PORTS 51${N}"
done
#
#
## TEST MAIN LOOP
#
for DEST in $nodeIPs
do
   #
   # Prepare the commands to create the listener sockets at the receiver side
   echo -e "\nATTENTION!\nPlease run the following commands on the receiver node (IP $DEST) to start the iperf3 listener processes:\n"
   for i in $PORTS
   do
      echo "iperf3 -s -p ${i} &"
   done
   #
   # Wait for an answer
   echo
   while true
   do
      read -p "After starting the listener processes in the receiver node, please type 'y' to continue: " ans
      case $ans in
      [yY]|[yY][eE][sS])
         break ;;
      *)
         ;;
      esac
   done
   # 
   # Test overall output file
   OUTFILE="${BENCHMARK_OUT_DIR}/iperf3_${NOW}_Sender_`hostname -s`_Receiver_${DEST}_Duration_${TDURATION}_Jobs_${TJOBS}.out"
   #
   echo -e "=============================\nTEST: Sending traffic to ${DEST}:\n=============================\n" | tee -a $OUTFILE
   #
   # Collect initial statistics
   echo "Test time and date:" | tee $OUTFILE ; date | tee -a $OUTFILE
   echo "" | tee -a $OUTFILE ; echo "=============================" | tee -a $OUTFILE ; echo "" | tee -a $OUTFILE 
   echo "Statistics before the test:" | tee -a $OUTFILE
   echo "netstat -s:" | tee -a $OUTFILE
   netstat -s | egrep -i 'packets|retrans|errors' | tee -a $OUTFILE
   echo "" | tee -a $OUTFILE
   echo "netstat -i:" | tee -a $OUTFILE
   netstat -i | tee -a $OUTFILE
   echo "" | tee -a $OUTFILE
   echo "ifconfig:" | tee -a $OUTFILE
   ifconfig | grep -A6 BROADCAST | egrep 'BROADCAST|RX errors|TX errors' | tee -a $OUTFILE
   #
   # Start the iperf3 processes
   for i in $PORTS
   do
      echo "" | tee -a $OUTFILE ; echo "=============================" | tee -a $OUTFILE ; echo "" | tee -a $OUTFILE 
      echo "Test command issued: iperf3 -c $DEST -t $TDURATION -P $TJOBS -p $i" | tee -a $OUTFILE
      # Here they go: the actual iperf3 commands executed
      ( iperf3 -c $DEST -t $TDURATION -P $TJOBS -p $i >$OUTFILE.${i} 2>&1 ) &
      # For bidirectional tests (sender and receiver send data at the same time
      # NOTE: bidirectional tests may not be available in the version running at your system
      #( iperf3 -c $DEST -t $TDURATION -P $TJOBS -p $i --bidir >$OUTFILE.${i} 2>&1 ) &
      #echo "Output file for test at port $i would be $OUTFILE.${i}" | tee -a $OUTFILE
   done
   #
   # Wait for the iperf tests finish to collect the statistics again
   while true
   do
      count=`ps -ef | grep "iperf3 -c $DEST" | grep -v grep | wc -l`
      if [ $count -eq 0 ] ;
      then
         break
      fi
      sleep 3
   done
   #
   echo "" | tee -a $OUTFILE ; echo "=============================" | tee -a $OUTFILE ; echo "" | tee -a $OUTFILE 
   echo "Statistics after the test:" | tee -a $OUTFILE
   echo "netstat -s:" | tee -a $OUTFILE
   netstat -s | egrep -i 'packets|retrans|errors' | tee -a $OUTFILE
   echo "" | tee -a $OUTFILE
   echo "netstat -i:" | tee -a $OUTFILE
   netstat -i | tee -a $OUTFILE
   echo "" | tee -a $OUTFILE
   echo "ifconfig:" | tee -a $OUTFILE
   ifconfig | grep -A6 BROADCAST | egrep 'BROADCAST|RX errors|TX errors' | tee -a $OUTFILE
   echo "" | tee -a $OUTFILE
   echo "OVERALL PERFORMANCE:" | tee -a $OUTFILE
   for i in `ls -1 ${OUTFILE}.51*`; do echo -e "\n$i" ; grep -Ew 'sender|receiver|Interval' $i | grep -vw Cwnd | grep -Ew 'Interval|SUM' ; done | tee -a $OUTFILE
   echo -e "\n=============================\n=============================\n" | tee -a $OUTFILE 
done

echo ""
echo -e "\nATTENTION!\nPlease stop the listeners at ALL the receiver node(s) using the command below in each of them:"
echo "pkill iperf3"
echo ""

# Clean exit
exit 0
