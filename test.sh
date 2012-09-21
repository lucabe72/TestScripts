RES=---
CARD=eth1
read_pkts() {
  TMP=$(/sbin/ifconfig -s $CARD | grep $CARD)
  RES=$(echo $TMP | cut -d ' ' -f $1)
}

read_pkts 4
PREV=$RES
read_pkts 6
PREVE=$RES
echo Prev: $PREV  PrevE: $PREVE

/sbin/ifconfig -s $CARD >> results
sudo bash pktgen-test.cfg -r $1
/sbin/ifconfig -s $CARD >> results

read_pkts 4
NEXT=$RES
read_pkts 6
NEXTE=$RES
RECV=$(echo $NEXT - $PREV | bc)
ERRS=$(echo $NEXTE - $PREVE | bc)
PPS=$(sudo grep pps /proc/net/pktgen/$CARD)
DATE=$(date --rfc-3339=sec)
echo Next: $NEXT - Prev: $PREV = Recv: $RECV
SENTPPS=$1
echo $RECV/10000000*$SENTPPS
echo "($RECV*$SENTPPS)/10000000" | bc
PPS=$(((RECV*SENTPPS)/10000000))
echo PPS: $PPS
echo Recv: $RECV Errs: $ERRS $PPS $DATE >> res.txt
sudo cat /proc/net/pktgen/$CARD >> results
