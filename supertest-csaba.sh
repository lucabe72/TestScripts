REPS=10
CONT=0
BINDIR=`pwd`
MIN=300000
MAX=1400000
STEP=50000

while getopts r:c:m:M:s: opt
 do
  case "$opt" in
    m)		MIN=$OPTARG;;
    M)		MAX=$OPTARG;;
    s)		STEP=$OPTARG;;
    r)		REPS=$OPTARG;;
    c)		CONT=$OPTARG;;
    [?])	print >&2 "Usage: $0 [-r REPS] [-c PPS]"
		exit 1;;
  esac
 done
shift $((OPTIND-1))

ids=$(seq 1 $REPS)

rm res.txt

one_cycle_macvtap() {

 ############## 1 router ###########
 #make sure 1 router is running 
 echo "killall qemu-system-x86_64" | nc 192.168.1.10 8888
 sleep 1
 echo "sh start-msr-mq-one.sh 1; exit" | nc 192.168.1.10 8888
 sleep 5

 echo 'sh setvhost.sh -f "vnc :1" -v 4 -V 8 -p 99 -P 99; exit' | nc 192.168.1.10 8888
 one_test res-4core-1router-bind-rt-cs.txt

 ############## 3 routers ###########
 #make sure all 3 routers are running 
 echo "killall qemu-system-x86_64" | nc 192.168.1.10 8888
 sleep 1
 echo "sh start-msr-mq-one.sh 1; exit" | nc 192.168.1.10 8888
 sleep 1
 echo "sh start-msr-mq-one.sh 2; exit" | nc 192.168.1.10 8888
 sleep 1
 echo "sh start-msr-mq-one.sh 3; exit" | nc 192.168.1.10 8888
 sleep 5

 #No bindings
 echo 'sh setvhost.sh -f "vnc :1" -v 15 -V 15 -p 0 -P 0; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :2" -v 15 -V 15 -p 0 -P 0; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :3" -v 15 -V 15 -p 0 -P 0; exit' | nc 192.168.1.10 8888
 one_test res-4core-3router-nobind-cs.txt

 #bindings
 echo 'sh setvhost.sh -f "vnc :1" -v 2 -V 2 -p 99 -P 99; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :2" -v 4 -V 4 -p 99 -P 99; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :3" -v 8 -V 8 -p 99 -P 99; exit' | nc 192.168.1.10 8888
 one_test res-4core-3router-bind-pc99ph99.txt

 echo 'sh setvhost.sh -f "vnc :1" -v 2 -V 2 -p 98 -P 99; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :2" -v 4 -V 4 -p 98 -P 99; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :3" -v 8 -V 8 -p 98 -P 99; exit' | nc 192.168.1.10 8888
 one_test res-4core-3router-bind-pc98ph99.txt

 echo 'sh setvhost.sh -f "vnc :1" -v 2 -V 2 -p 99 -P 98; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :2" -v 4 -V 4 -p 99 -P 98; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :3" -v 8 -V 8 -p 99 -P 98; exit' | nc 192.168.1.10 8888
 one_test res-4core-3router-bind-pc99ph98.txt

 ############## 4 routers ###########
 #make sure all 4 routers are running 
 echo "killall qemu-system-x86_64" | nc 192.168.1.10 8888
 sleep 1
 echo "sh start-msr-mq-one.sh 1; exit" | nc 192.168.1.10 8888
 sleep 1
 echo "sh start-msr-mq-one.sh 2; exit" | nc 192.168.1.10 8888
 sleep 1
 echo "sh start-msr-mq-one.sh 3; exit" | nc 192.168.1.10 8888
 sleep 1
 echo "sh start-msr-mq-one.sh 4; exit" | nc 192.168.1.10 8888
 sleep 5

 #No bindings
 echo 'sh setvhost.sh -f "vnc :1" -v 15 -V 15 -p 0 -P 0; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :2" -v 15 -V 15 -p 0 -P 0; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :3" -v 15 -V 15 -p 0 -P 0; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :4" -v 15 -V 15 -p 0 -P 0; exit' | nc 192.168.1.10 8888
 one_test res-4core-4router-nobind-cs.txt

 #bindings
 echo 'sh setvhost.sh -f "vnc :1" -v 2 -V 2 -p 99 -P 98; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :2" -v 4 -V 4 -p 99 -P 98; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :3" -v 8 -V 8 -p 99 -P 98; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :4" -v 1 -V 1 -p 99 -P 98; exit' | nc 192.168.1.10 8888
 one_test res-4core-4router-bind-pc99ph98.txt

 echo 'sh setvhost.sh -f "vnc :1" -v 2 -V 2 -p 99 -P 98; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :2" -v 4 -V 4 -p 99 -P 98; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :3" -v 8 -V 8 -p 99 -P 98; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :4" -v 15 -V 15 -p 0 -P 0; exit' | nc 192.168.1.10 8888
 one_test res-4core-4router-bind3-nobind1-pc99ph98.txt
}

one_cycle_lb() {
 ############## LB ###########
 #make sure 1 router and 1 LB are running 
 echo "killall qemu-system-x86_64" | nc 192.168.1.10 8888
 echo "sh ~/MSR/start-msr-br.sh; exit" | nc 192.168.1.10 8888

 #use 1 core
 echo 'sh setvhost.sh -f "vnc :1" -v 1 -V 1 -p 0 -P 0; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :2" -v 1 -V 1 -p 0 -P 0; exit' | nc 192.168.1.10 8888
 one_test res-1core-lb-cs.txt

 #use 2 cores, no bindings
 echo 'sh setvhost.sh -f "vnc :1" -v 3 -V 3 -p 0 -P 0; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :2" -v 3 -V 3 -p 0 -P 0; exit' | nc 192.168.1.10 8888
 one_test res-2core-lb-nobind-cs.txt

 #use 2 cores, bind
 echo 'sh setvhost.sh -f "vnc :1" -v 2 -V 1 -p 97 -P 98; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :2" -v 2 -V 1 -p 99 -P 98; exit' | nc 192.168.1.10 8888
 one_test  res-2core-lb-bind-rt-cs.txt

 #use 2 cores, bind
 echo 'sh setvhost.sh -f "vnc :1" -v 1 -V 2 -p 97 -P 98; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :2" -v 1 -V 2 -p 99 -P 98; exit' | nc 192.168.1.10 8888
 one_test  res-2core-lb-bind2-rt-cs.txt

 #use 2 cores, bind
 echo 'sh setvhost.sh -f "vnc :1" -v 1 -V 2 -p 97 -P 98; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :2" -v 2 -V 1 -p 99 -P 98; exit' | nc 192.168.1.10 8888
 one_test  res-2core-lb-bind3-rt-cs.txt

 #use 2 cores, bind
 echo 'sh setvhost.sh -f "vnc :1" -v 2 -V 1 -p 97 -P 98; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :2" -v 1 -V 2 -p 99 -P 98; exit' | nc 192.168.1.10 8888
 one_test  res-2core-lb-bind4-rt-cs.txt

 #use 4 cores, nobind
 echo 'sh setvhost.sh -f "vnc :1" -v 15 -V 15 -p 0 -P 0; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :2" -v 15 -V 15 -p 0 -P 0; exit' | nc 192.168.1.10 8888
 one_test  res-4core-lb-nobind-cs.txt

 #use 4 cores, bind
 echo 'sh setvhost.sh -f "vnc :1" -v 2 -V 1 -p 97 -P 98; exit' | nc 192.168.1.10 8888
 echo 'sh setvhost.sh -f "vnc :2" -v 4 -V 8 -p 99 -P 98; exit' | nc 192.168.1.10 8888
 one_test  res-4core-lb-bind-cs.txt
}

one_test() {
 if [ $CONT -gt 0 ] ; then
  ./test-cont.sh $CONT
 else 
  if cut -d ' ' -f 10 $1 | grep -x $i ; then
    echo "$1/$i exists, skipping"
  else
    sleep 5

    sh runit.sh -m $MIN -M $MAX -s $STEP -r 1 -x "$i"
    sleep 1
    cat res.txt >>$1
    mkdir -p $1-logenv/$i
    mv res.txt $1-logenv/$i
    mkdir -p $1-logenv/$i/src
    cd $1-logenv/$i/src
    sh $BINDIR/logenv.sh
    cd -
    mkdir -p $1-logenv/$i/host
    cd $1-logenv/$i/host
    sh $BINDIR/logenv_host.sh
    cd -
  fi
 fi
}

for i in $ids
 do
  #one_cycle_lb
  one_cycle_macvtap
done
