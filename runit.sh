ids=`seq 1 10`
rates=`seq 300000 20000 600000`

for i in $ids
 do
  for r in $rates
   do
    echo Run $i, Rate $r
    bash test1.sh $r
    sleep 40
   done
 done

