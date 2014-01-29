BINDIR=`dirname $0`

rsh()
{
nc 192.168.1.10 8888 <<END
$1
exit
END
}

rsh "date" > date
rsh "uname -a" >uname
rsh "/sbin/ifconfig -a" >ifconfig
rsh "cat /proc/cpuinfo" >cpuinfo
rsh "lsusb" >lsusb
rsh "lspci" >lspci
rsh "ps ax" >ps
rsh "cat /proc/interrupts" >interrupts
rsh "`cat $BINDIR/getirq.sh`" >getirq
rsh "`cat $BINDIR/getvhost.sh`" >getvhost
