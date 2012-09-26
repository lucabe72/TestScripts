
logeth()
{
  ethtool -i $1 >$1
  ethtool -a $1 >>$1
  ethtool -c $1 >>$1
  ethtool -g $1 >>$1
  ethtool -k $1 >>$1
}

date > date
uname -a >uname
ifconfig -a >ifconfig
cat /proc/cpuinfo >cpuinfo
lsusb >lsusb
lspci >lspci
cat /proc/interrupts >interrupts

logeth eth0
logeth eth1
logeth eth2
logeth eth3
