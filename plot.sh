cat <<END >tmp.gnu
set xr [0:]
set yr [0:]
set key left

plot x
END

for f in `ls res*.txt`; do
  echo 'replot "'$f'" u 9:($9)*($2/10000000) smooth unique w lp t "'$f'"' >>tmp.gnu
done

cat <<END >>tmp.gnu
set terminal postscript eps color size 6,5
replot
END

gnuplot tmp.gnu
