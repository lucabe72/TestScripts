BINDIR=`dirname $0`
PREFIX="res-"

for file in `ls $PREFIX*.txt`; do
  [ -f $dir ] && sh $BINDIR/process.sh $@ $file > ${file/$PREFIX/}
done

cat <<END >tmp.gnu
set xr [0:]
set yr [0:]
set key left

plot x
END

for file in `ls $PREFIX*.txt`; do
  echo 'replot "'${file/$PREFIX/}'" u 1:2:3 w yerrorlines t "'${file/$PREFIX/}'"' >>tmp.gnu
done

cat <<END >>tmp.gnu
set terminal postscript eps color size 6,5
replot
END

gnuplot tmp.gnu
