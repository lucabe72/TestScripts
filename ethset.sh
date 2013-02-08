e1000e_reset {
  #Remove and re-insert the e1000e module, to start from a clean config...
  sudo /sbin/rmmod e1000e
  #sudo /sbin/modprobe e1000e TxIntDelay=0 TxAbsIntDelay=0 RxAbsIntDelay=0 RxIntDelay=0 InterruptThrottleRate=0
  #sudo /sbin/modprobe e1000e TxAbsIntDelay=0 RxAbsIntDelay=0 InterruptThrottleRate=99999		#740+ pps
  #sudo /sbin/modprobe e1000e TxAbsIntDelay=0 RxAbsIntDelay=0 InterruptThrottleRate=0		#740+, larger RX errors
  sudo /sbin/modprobe e1000e # Let's not play with the module's parameters...
}

sudo /sbin/ifdown eth$1
e1000e_reset
sleep 1
sudo /sbin/ifconfig eth$1 192.168.1.1
sudo /sbin/ifconfig eth$1 txqueuelen 1000000
sudo /sbin/ifconfig eth$1:0 192.168.2.1
sleep 5
sudo ethtool -A eth$1 autoneg off rx off tx off
sudo /sbin/modprobe pktgen

 
