#!/bin/sh

#create by mlj

if [ $# -lt 4 ]
then
        echo "Usage:$0 picture 20140920 99 112 'www.17ce.com|ott'"
        echo "Usage:$0 业务类型 date time [proberefer]"
        echo "业务类型 rtmp"
        exit
fi

porject_home=/opt/mlj/txt/$1/$2
result_home=/opt/mlj/result/$1/$2

if [ "$1" == "rtmp" ]
then
        d_home=$result_home/down
        u_home=$result_home/up
        mkdir -p $d_home
        mkdir -p $u_home
        txt_home=$porject_home
        for i in `seq $3 $4`
        do
                cat $txt_home/$i|awk -F"|" '{if($4=="PLAY" && $31=="south") {$17=int($17);print $2,$9,$17}}'|awk '{if(NF==3) {print $0}}'| \
                awk '{value[$1]+=$2+$3} END {for(name in value) {printf("%-20s %-12dB %-10dMB\n",name,value[name],value[name]/1024/1024)}}' > $d_home/$i
                cat $txt_home/$i|awk -F"|" '{if($4=="PUBLISH" && $31=="south") {$17=int($17);print $2,$9,$17}}'|awk '{if(NF==3) {print $0}}'| \
                awk '{value[$1]+=$2+$3} END {for(name in value) {printf("%-20s %-12dB %-10dMB\n",name,value[name],value[name]/1024/1024)}}' > $u_home/$i
        done
fi
