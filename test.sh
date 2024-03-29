RES=---
CARD=eth1
PKTS=10000000
RATE=100000
XTRA=
MULTI_DST=

while getopts i:r:p:x:m opt
 do
  case "$opt" in
    r)		RATE=$OPTARG;;
    p)		PKTS=$OPTARG;;
    x)		XTRA=$OPTARG;;
    m)		MULTI_DST=-m;;
    i)		CARD=$OPTARG;;
    [?])	print >&2 "Usage: $0 [-r pps] [-p pkts] [-x xtras]"
		exit 1;;
  esac
 done
shift $((OPTIND-1))

read_pkts() {
  echo $(grep $1 /proc/net/dev) | cut -d ' ' -f $2
}


PREV=$(read_pkts $CARD 3)
PREVE=$(read_pkts $CARD 4)
echo Prev: $PREV  PrevE: $PREVE

/sbin/ifconfig $CARD >> results
echo "mpstat -P ALL 1 < /dev/null > /tmp/cpuload.txt 2> /dev/null & exit" | nc 192.168.1.10 8888
sudo sh pktgen-test.cfg $MULTI_DST -i $CARD -r $RATE -p $PKTS
echo "killall mpstat; exit" | nc 192.168.1.10 8888
/sbin/ifconfig $CARD >> results

NEXT=$(read_pkts $CARD 3)
NEXTE=$(read_pkts $CARD 4)
RECV=$((NEXT - PREV))
ERRS=$((NEXTE - PREVE))
PPS=$(sudo grep pps /proc/net/pktgen/$CARD)
TXPPS=$(echo $PPS | cut -d 'p' -f 1)
DATE=$(date -Iseconds)
echo Next: $NEXT - Prev: $PREV = Recv: $RECV
SENTPPS=$RATE
echo $RECV/$PKTS*$SENTPPS
SENTPPS=$((SENTPPS/10000))
PKTS=$((PKTS/10000))
echo $(((RECV*SENTPPS)/PKTS))
PPS=$(((RECV*SENTPPS)/PKTS))
echo PPS: $PPS
echo Recv: $RECV Errs: $ERRS $PPS $TXPPS $DATE $((SENTPPS*10000)) $XTRA>> res.txt
sudo cat /proc/net/pktgen/$CARD >> results
