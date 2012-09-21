MIN=300000
MAX=900000
STEP=50000
REPS=10

while getopts m:M:s:r: opt
 do
  case "$opt" in
    m)		MIN=$OPTARG;;
    M)		MAX=$OPTARG;;
    s)		STEP=$OPTARG;;
    r)		REPS=$OPTARG;;
    [?])	print >&2 "Usage: $0 [-m] [-M] [-s] [-r]"
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
    bash test.sh $r
    sleep 20
   done
 done

