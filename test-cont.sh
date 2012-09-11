RES=---

onexit()
{
 if sudo kill -0 $PID; then
  sudo modprobe -r pktgen	# kill -9 doesn't seem to work
  sudo modprobe pktgen
 fi
}
trap onexit 0

read_pkts() {
  TMP=`/sbin/ifconfig -s eth1 | grep eth1`
  RES=`echo $TMP | cut -d ' ' -f $1`
}

RATE=$1
sudo bash pktgen-test.cfg $RATE &
PID=$!

while sudo kill -0 $PID
 do
  read_pkts 4
  PREV=$RES
  read_pkts 6
  PREVE=$RES
  sleep 1
  read_pkts 4
  NEXT=$RES
  read_pkts 6
  NEXTE=$RES
  RECV=`echo $NEXT - $PREV | bc`
  ERRS=`echo $NEXTE - $PREVE | bc`
  PPS=`sudo grep pps /proc/net/pktgen/eth1`
  DATE=`date --rfc-3339=sec`
  echo Next: $NEXT - Prev: $PREV = Recv: $RECV
 done