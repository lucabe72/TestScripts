BINDIR=`dirname $0`

for file in `ls res*.txt`; do
  [ -f $dir ] && sh $BINDIR/process.sh $@ $file > ${file/res-/}
done

cat <<END >tmp.gnu
set xr [0:]
set yr [0:]
set key left

plot x
END

for file in `ls res*.txt`; do
  echo 'replot "'${file/res-/}'" u 1:2:3 w yerrorlines t "'${file/res-/}'"' >>tmp.gnu
done

cat <<END >>tmp.gnu
set terminal postscript eps color size 6,5
replot
END

gnuplot tmp.gnu
