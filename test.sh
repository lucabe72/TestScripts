RES=---
CARD=eth1
PKTS=10000000

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
sudo bash pktgen-test.cfg -r $1 -p $PKTS
/sbin/ifconfig -s $CARD >> results

read_pkts 4
NEXT=$RES
read_pkts 6
NEXTE=$RES
RECV=$(echo $NEXT - $PREV | bc)
ERRS=$(echo $NEXTE - $PREVE | bc)
PPS=$(sudo grep pps /proc/net/pktgen/$CARD)
TXPPS=$(echo $PPS | cut -d 'p' -f 1)
DATE=$(date --rfc-3339=sec)
echo Next: $NEXT - Prev: $PREV = Recv: $RECV
SENTPPS=$1
echo $RECV/$PKTS*$SENTPPS
echo "($RECV*$SENTPPS)/$PKTS" | bc
PPS=$(((RECV*SENTPPS)/PKTS))
echo PPS: $PPS
echo Recv: $RECV Errs: $ERRS $PPS $TXPPS $DATE >> res.txt
sudo cat /proc/net/pktgen/$CARD >> results
