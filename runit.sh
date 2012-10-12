MIN=300000
MAX=1400000
STEP=50000
REPS=10
PKTS=10000000
XTRA=	# exta parameters to pass on

while getopts m:M:s:r:p:x: opt
 do
  case "$opt" in
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
    bash test.sh -p $PKTS -r $r -x "$XTRA"
    sleep 5
   done
 done

