RES=---
read_pkts() {
  TMP=`/sbin/ifconfig -s eth1 | grep eth1`
  RES=`echo $TMP | cut -d ' ' -f $1`
}

#PREV=`/sbin/ifconfig -s eth1 | grep eth1 | cut -d ' ' -f 11`
#PREVE=`/sbin/ifconfig -s eth1 | grep eth1 | cut -d ' ' -f 18`
read_pkts 4
PREV=$RES
read_pkts 6
PREVE=$RES
echo Prev: $PREV  PrevE: $PREVE

/sbin/ifconfig -s eth1 >> results
sudo bash pktgen-test.cfg $1
/sbin/ifconfig -s eth1 >> results

#NEXT=`/sbin/ifconfig -s eth1 | grep eth1 | cut -d ' ' -f 11`
#NEXTE=`/sbin/ifconfig -s eth1 | grep eth1 | cut -d ' ' -f 18`
read_pkts 4
NEXT=$RES
read_pkts 6
NEXTE=$RES
RECV=`echo $NEXT - $PREV | bc`
ERRS=`echo $NEXTE - $PREVE | bc`
PPS=`sudo grep pps /proc/net/pktgen/eth1`
echo Next: $NEXT - Prev: $PREV = Recv: $RECV
SENTPPS=$1
echo $RECV/10000000*$SENTPPS
echo "($RECV*$SENTPPS)/10000000" | bc
PPS=$(((RECV*SENTPPS)/10000000))
echo PPS: $PPS
echo Recv: $RECV Errs: $ERRS $PPS >> res.txt
sudo cat /proc/net/pktgen/eth1 >> results
