#!/bin/bash
checkalive (){
NODE=$1
ping -c 3 $NODE>/dev/null 2>&1
if [ $? -eq 0 ]
then
echo "$NODE is alive"
else
echo "$NODE is not alive"
fi
}
input="$1"
ips=$(echo ${input%.*}.)
start=$(echo ${input##*.} | awk -F- '{print $1}')
end=$(echo ${input##*.} | awk -F- '{print $2}')
echo $start
echo $end
for(( i=$start;i<=$end;i++ ))
do
ip="$ips$i"
checkalive  $ip
done
