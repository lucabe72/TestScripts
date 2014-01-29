MIN=300000
MAX=1400000
STEP=50000
REPS=10
PKTS=10000000
XTRA=	# exta parameters to pass on
CARD=eth1

while getopts i:m:M:s:r:p:x: opt
 do
  case "$opt" in
    i)		CARD=$OPTARG;;
    m)		MIN=$OPTARG;;
    M)		MAX=$OPTARG;;
    s)		STEP=$OPTARG;;
    r)		REPS=$OPTARG;;
    p)		PKTS=$OPTARG;;
    x)		XTRA=$OPTARG;;
    [?])	print >&2 "Usage: $0 [-m] [-M] [-s] [-r] [-x]"
		exit 1;;
  esac
 done
shift $((OPTIND-1))


ids=$(seq 1 $REPS)
rates=$(seq $MIN $STEP $MAX)

for i in $ids
 do
  for r in $rates
   do
    echo Run $i, Rate $r
    bash test.sh -i $CARD -p $PKTS -r $r -x "$XTRA"
    echo "cat /tmp/cpuload.txt; exit" | nc 192.168.1.10 8888 > cpuload-$r.txt
    sleep 5
   done
 done

