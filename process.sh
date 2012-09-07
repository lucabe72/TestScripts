MIN=300000
MAX=400000
STEP=20000
REPS=5
PKTS=10000000
MODE=pkts

packets_get() {
  IDMAX=$((REPS-1))
  N=$((MAX-MIN))
  N=$((N/STEP+1))
  IDXS=$(seq 0 $IDMAX)
  OFFS=$2

  for i in $IDXS
   do
    LINE=$((i*N+1+OFFS))
    ITEM=$(head -n $LINE $1 | tail -n 1)
#    echo $LINE $ITEM
    echo $ITEM | cut -d ' ' -f 2
   done
}

pps_get() {
  PACKETS=$(packets_get $1 $2)
  PPS=$3

  for p in $PACKETS
   do
    echo $((PPS*p/PKTS))
   done
}

compute_avg() {
  SUM=0
  CNT=0

  for n in $1
   do
    SUM=$((SUM+n))
    CNT=$((CNT+1))
   done
  AVG=$((SUM/CNT))
  echo $AVG
}

compute_stddev() {
  SUM=0
  CNT=0
  AVG=$2

  for n in $1
   do
    D=$((n-AVG))
    SUM=$((SUM+D*D))
    CNT=$((CNT+1))
   done
  AVG=$((SUM/CNT))
  echo "sqrt($AVG)" | bc
}

while getopts m:M:s:r:P opt
 do
  echo "Opt: $opt"
  case "$opt" in
    m)		MIN=$OPTARG;;
    M)		MAX=$OPTARG;;
    s)		STEP=$OPTARG;;
    r)		REPS=$OPTARG;;
    P)		MODE=pps;;
    [?])	print >&2 "Usage: $0 [-v] [-p] [-P] [-b]"
		exit 1;;
  esac
 done
shift $((OPTIND-1))



MAXPPSS=$((MAX-MIN))
MAXPPSS=$((MAXPPSS/STEP))
PPSS=$(seq 0 $MAXPPSS)
for i in $PPSS
 do
  PPS=$((MIN+i*STEP))
  if [[ $MODE == pkts ]];
   then
    RES=$(packets_get $1 $i)
   else
    RES=$(pps_get $1 $i $PPS)
   fi
  A=$(compute_avg "$RES")
  S=$(compute_stddev "$RES" $A)
  echo $PPS: $A $S $RES
 done
