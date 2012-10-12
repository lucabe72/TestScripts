while getopts f: opt
 do
  echo "Opt: $opt"
  case "$opt" in
    f)		FILTER="$OPTARG";;
    [?])	echo >&2 "Usage: $0"\
    		" [-f ps filter]"\
		""
		exit 1;;
  esac
 done

kvmpids=`ps -e | grep [q]emu | grep "$FILTER" | cut -c 1-6`
echo kvm PIDs: $kvmpids
for kvmpid in $kvmpids
 do
  vhostpids="$vhostpids "`ps ax | grep [v]host-$kvmpid | cut -c 1-6`
  tmp=$(ls /proc/$kvmpid/task)
  vcpupids="$vcpupids "$(echo $tmp | cut -d ' ' -f 2)
 done

echo vhost PIDs: $vhostpids
echo vcpu PIDs: $vcpupids

for vcpupid in $vcpupids
 do 
  sudo chrt -p $vcpupid
  sudo taskset -p $vcpupid
 done

for vhostpid in $vhostpids
 do 
  sudo chrt -p $vhostpid
  sudo taskset -p $vhostpid
 done

for kvmpid in $kvmpids
 do
  sudo chrt -p $kvmpid
  sudo taskset -p $kvmpid
 done

