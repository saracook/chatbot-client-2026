#!/bin/bash

# iperf[3] test script

## Variables
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
# Output directory. Here we will save the tests results.
OUT_DIR="/var/lib/kubelet/plugins/kubernetes.io/csi/pv/cephfs-static-pi-slurm/globalmount/tmp/outputs"
#
# Target node(s) IP(s) (space separated list)
#TARGET_IPs="192.168.206.51 192.168.205.51"
TARGET_IPs="192.168.1.29 192.168.1.24 192.168.0.245 192.168.0.249"
#
# Test duration in seconds
TDURATION=60
#
# Number of parallel data streams per iperf process (iperf process is single-threaded, though)
#TJOBS=8
TJOBS=4
#
# Number of simultaneous iperf processes (it will start this number of simultaneous iperf processes in the sender node, each one with TJOBS streams)
# Minimum value is 2
#NIPERF=16
NIPERF=2
#
####################################################################################################
#
# DO NOT CHANGE ANYTHING BELOW THIS LINE
#
####################################################################################################
#
# iperf binary (some systems use iperf3 and some systems use iperf)
if [ -x /usr/bin/iperf ] ;
then
   IPERF_BIN="iperf"
elif [ -x /usr/bin/iperf3 ] ;
then
   IPERF_BIN="iperf3"
else
   echo -e "\nERROR\nNo iperf nor iperf3 binaries found. Please install iperf and retry.\nExiting...\n"
   exit 1
fi
#
# Create the output directory
BENCHMARK_OUT_DIR="${OUT_DIR}/benchmark_tests_${THIS_HOST}_${TODAY}"
[ ! -d $BENCHMARK_OUT_DIR ] && mkdir -p $BENCHMARK_OUT_DIR
#
# Target ports (sockets that will be created at the receiver side)
PORTS=""
for i in `seq 1 $NIPERF`
do
   N=`printf "%02d" $i`
   PORTS="$PORTS 51${N}"
done
#
#
## TEST MAIN LOOP
#
for DEST in $TARGET_IPs
do
   #
   # Prepare the commands to create the listener sockets at the receiver side
   echo -e "\nATTENTION!\nPlease run the following commands on the receiver node (IP $DEST) to start the listener processes:\n"
   for i in $PORTS
   do
      echo "$IPERF_BIN -s -p ${i} &"
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
   OUTFILE="${BENCHMARK_OUT_DIR}/${IPERF_BIN}_${NOW}_Sender_${THIS_HOST}_Receiver_${DEST}_Duration_${TDURATION}_Jobs_${TJOBS}.out"
   #
   echo -e "=============================\nTEST: Sending traffic to ${DEST}:\n=============================\n" | tee -a $OUTFILE
   #
   # Collect initial statistics and devices information
   echo "Test time and date:" | tee $OUTFILE ; date | tee -a $OUTFILE
   echo "" | tee -a $OUTFILE ; echo "=============================" | tee -a $OUTFILE ; echo "" | tee -a $OUTFILE
   echo "Devices information:" | tee -a $OUTFILE
   type lshw >/dev/null 2>&1
   if [ $? -eq 0 ] ;
   then
      echo "lshw:" | tee -a $OUTFILE
      lshw -c network -businfo 2>/dev/null | tee -a $OUTFILE
      echo -e "\n+-+-+-+-+-+-+\n" | tee -a $OUTFILE
   fi
   echo "IP:" | tee -a $OUTFILE
   ip -br a | grep -w UP | tee -a $OUTFILE
   echo -e "\n+-+-+-+-+-+-+\n" | tee -a $OUTFILE
   echo "Routes:" | tee -a $OUTFILE
   ip r | tee -a $OUTFILE
   echo -e "\n+-+-+-+-+-+-+\n" | tee -a $OUTFILE
   echo "Link speed:" | tee -a $OUTFILE
   for i in `ip -br a | grep -w UP | awk '{print $1}'`; do echo "===" ; ethtool $i 2>/dev/null | grep -E 'Settings for |Speed: |Link detected: ' ; done | tee -a $OUTFILE
   echo -e "\n+-+-+-+-+-+-+\n" | tee -a $OUTFILE
   [ -d /proc/net/bonding ] && echo "Bond info:" | tee -a $OUTFILE
   [ -d /proc/net/bonding ] && for i in `ls -1 /proc/net/bonding/*`; do echo -e "===\nSettings for: $i" ; cat $i ; echo -e "===" ; done | tee -a $OUTFILE
   [ -d /proc/net/bonding ] && echo -e "\n+-+-+-+-+-+-+\n" | tee -a $OUTFILE
   if [ -x /bin/ibdev2netdev ] ; then
      echo "IB Devices:" | tee -a $OUTFILE
      ibdev2netdev -v 2>/dev/null | tee -a $OUTFILE
   fi
   echo "" | tee -a $OUTFILE ; echo "=============================" | tee -a $OUTFILE ; echo "" | tee -a $OUTFILE
   echo "Statistics before the test:" | tee -a $OUTFILE
   type netstat >/dev/null 2>&1
   if [ $? -eq 0 ] ;
   then
      echo "netstat -s:" | tee -a $OUTFILE
      netstat -s | egrep -i 'packets|retrans|errors' | tee -a $OUTFILE
      echo "" | tee -a $OUTFILE
      echo "netstat -i:" | tee -a $OUTFILE
      netstat -i | tee -a $OUTFILE
      echo "" | tee -a $OUTFILE
   fi
   type ifconfig >/dev/null 2>&1
   if [ $? -eq 0 ] ;
   then
      echo "ifconfig:" | tee -a $OUTFILE
      for i in `ip -br a | grep -w UP | awk '{print $1}'`; do ifconfig $i 2>/dev/null ; echo "" ; done | tee -a $OUTFILE
   fi
   type ethtool >/dev/null 2>&1
   if [ $? -eq 0 ] ;
   then
      type lshw >/dev/null 2>&1
      if [ $? -eq 0 ] ;
      then
         ifaces=`lshw -c network -businfo | grep -w network | awk '{print $2}' 2>/dev/null`
         echo "ethtool -S <IFNAME>:" | tee -a $OUTFILE
         for i in $ifaces
         do
            mytest=`ip -br a | grep -w UP | grep $i`
            if [ "x${mytest}" != "x" ] ;
            then
               echo $i | tee -a $OUTFILE ; ethtool -S $i | tee -a $OUTFILE ; echo "+-+-+-+" | tee -a $OUTFILE
            fi
            mytest=""
         done
      fi
   fi
   #
   # Start the iperf processes
   for i in $PORTS
   do
      echo "" | tee -a $OUTFILE ; echo "=============================" | tee -a $OUTFILE ; echo "" | tee -a $OUTFILE
      echo "Test command issued: $IPERF_BIN -c $DEST -t $TDURATION -P $TJOBS -p $i" | tee -a $OUTFILE
      # Here they go: the actual iperf commands executed
      ( $IPERF_BIN -c $DEST -t $TDURATION -P $TJOBS -p $i >$OUTFILE.${i} 2>&1 ) &
      # For bidirectional tests (sender and receiver send data at the same time
      # NOTE: bidirectional tests may not be available in the version running at your system
      #( $IPERF_BIN -c $DEST -t $TDURATION -P $TJOBS -p $i --bidir >$OUTFILE.${i} 2>&1 ) &
      #echo "Output file for test at port $i would be $OUTFILE.${i}" | tee -a $OUTFILE
   done
   #
   # Wait for the iperf tests finish to collect the statistics again
   while true
   do
      count=`ps -ef | grep "$IPERF_BIN -c $DEST" | grep -v grep | wc -l`
      if [ $count -eq 0 ] ;
      then
         break
      fi
      sleep 3
   done
   #
   echo "" | tee -a $OUTFILE ; echo "=============================" | tee -a $OUTFILE ; echo "" | tee -a $OUTFILE
   echo "Statistics after the test:" | tee -a $OUTFILE
   type netstat >/dev/null 2>&1
   if [ $? -eq 0 ] ;
   then
      echo "netstat -s:" | tee -a $OUTFILE
      netstat -s | egrep -i 'packets|retrans|errors' | tee -a $OUTFILE
      echo "" | tee -a $OUTFILE
      echo "netstat -i:" | tee -a $OUTFILE
      netstat -i | tee -a $OUTFILE
      echo "" | tee -a $OUTFILE
   fi
   type ifconfig >/dev/null 2>&1
   if [ $? -eq 0 ] ;
   then
      echo "ifconfig:" | tee -a $OUTFILE
      for i in `ip -br a | grep -w UP | awk '{print $1}'`; do ifconfig $i 2>/dev/null ; echo "" ; done | tee -a $OUTFILE
   fi
   type ethtool >/dev/null 2>&1
   if [ $? -eq 0 ] ;
   then
      type lshw >/dev/null 2>&1
      if [ $? -eq 0 ] ;
      then
         ifaces=`lshw -c network -businfo | grep -w network | awk '{print $2}' 2>/dev/null`
         echo "ethtool -S <IFNAME>:" | tee -a $OUTFILE
         for i in $ifaces
         do
            mytest=`ip -br a | grep -w UP | grep $i`
            if [ "x${mytest}" != "x" ] ;
            then
               echo $i | tee -a $OUTFILE ; ethtool -S $i | tee -a $OUTFILE ; echo "+-+-+-+" | tee -a $OUTFILE
            fi
            mytest=""
         done
      fi
   fi
   echo "" | tee -a $OUTFILE
   echo "OVERALL PERFORMANCE:" | tee -a $OUTFILE
   if [ $IPERF_BIN == iperf3 ] ;
   then
      for i in `ls -1 ${OUTFILE}.51*`; do echo -e "\n$i" ; grep -Ew 'sender|receiver|Interval' $i | grep -vw Cwnd | grep -Ew 'Interval|SUM' ; done | tee -a $OUTFILE
   else
      for i in `ls -1 ${OUTFILE}.51*`; do echo -e "\n$i" ; grep -Ew 'Interval|SUM' $i ; done | tee -a $OUTFILE
   fi
   echo -e "\n=============================\n=============================\n" | tee -a $OUTFILE
done

echo ""
echo -e "\nATTENTION!\nPlease stop the listeners at ALL the receiver node(s) using the command below in each of them:"
echo "pkill $IPERF_BIN"
echo ""

# Clean exit
exit 0


