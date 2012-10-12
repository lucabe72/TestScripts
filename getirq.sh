ETH=eth0

get_irqs() {
  irqs=$(grep $1 /proc/interrupts | cut -d ':' -f 1)
  echo $irqs
}

get_affinity() {
  for i in $1
   do
    echo $i `sudo cat /proc/irq/$i/smp_affinity`
   done
}

while getopts i: opt
 do
  echo "Opt: $opt"
  case "$opt" in
    i)		ETH=eth$OPTARG;;
    [?])	print >&2 "Usage: $0 [-i interface]"
		exit 1;;
  esac
 done

echo RX: $RX_AFF TX: $TX_AFF
tx_irqs=$(get_irqs $ETH-tx)
rx_irqs=$(get_irqs $ETH-rx)
eth_irqs=$(get_irqs $ETH)
if test x$tx_irqs = x; then
  echo No separate TX queue!
  get_affinity "$eth_irqs"
 else
  echo Separate TX queue!
  get_affinity "$tx_irqs"
  get_affinity "$rx_irqs"
 fi
