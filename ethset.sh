sudo /sbin/ifdown eth$1
sudo /sbin/rmmod e1000e
#sudo /sbin/modprobe e1000e TxIntDelay=0 TxAbsIntDelay=0 RxAbsIntDelay=0 RxIntDelay=0 InterruptThrottleRate=0
#sudo /sbin/modprobe e1000e TxAbsIntDelay=0 RxAbsIntDelay=0 InterruptThrottleRate=99999		#740+ pps
sudo /sbin/modprobe e1000e TxAbsIntDelay=0 RxAbsIntDelay=0 InterruptThrottleRate=0		#740+, larger RX errors
sleep 1
sudo /sbin/ifconfig eth$1 192.168.1.1
sudo /sbin/ifconfig eth$1 txqueuelen 1000000
sudo /sbin/ifconfig eth$1:0 192.168.2.1
sleep 5
sudo /sbin/ethtool -A eth$1 autoneg off rx off tx off
#sudo /bin/echo 1 > /proc/sys/net/ipv4/ip_forward
sudo /sbin/modprobe pktgen

 
