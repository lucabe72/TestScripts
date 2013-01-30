BINDIR=`dirname $0`
PREFIX="res-"
PROC_PREFIX="procesed-"

for file in `ls $PREFIX*.txt`; do
  [ -f $dir ] && sh $BINDIR/process.sh $@ $file > $PROC_PREFIX$file
done

cat <<END >tmp.gnu
set xr [0:]
set yr [0:]
set key left
set terminal unknown

plot x
END

for file in `ls $PREFIX*.txt`; do
  echo 'replot "'$PROC_PREFIX$file'" u 1:2:3 w yerrorlines t "'$file'"' >>tmp.gnu
done

cat <<END >>tmp.gnu
set terminal postscript eps color size 6,5
replot
END

gnuplot tmp.gnu
