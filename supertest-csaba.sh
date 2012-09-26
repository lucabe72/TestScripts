#!/bin/bash
# needs bash for "source"

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
    [?])	print >&2 "Usage: $0 [-r REPS] [-c PPS] testcase ...";;
  esac
 done
shift $((OPTIND-1))

ids=$(seq 1 $REPS)

rm -f res.txt

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

for i in $ids; do
  for testcase in $@; do
    if [ -f $testcase ]; then
      source  $testcase  #include testcase
      $testcase #run testcase
    else
      echo "testcase file $testcase missing"
    fi
  done
done
