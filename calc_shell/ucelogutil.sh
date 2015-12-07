#!/bin/sh

#create by mlj

if [ $# -lt 4 ]
then
	echo "Usage:$0 picture 20140920 99 112 'www.17ce.com|ott'"
	echo "Usage:$0 业务类型 date time [proberefer]"
        echo "业务类型 dns/picture/video/lgw"
        exit
fi

porject_home=/opt/mlj/txt/$1/$2
result_home=/opt/mlj/result/$1/$2


if [ "$1" == "picture" ]
then
	mkdir -p $result_home
	txt_home=$porject_home/002
	for i in `seq $3 $4`
	do
		if [ $# -eq 5 ]
		then
			cat $txt_home/$i|grep -vE $5|awk -F"|" '{$17=int($17);print $2,$8,$9,$17,$20}'|awk '{if(NF==5) {print $0}}'|awk '{value[$1]+=$2+$3;if($5==1){value[$1]+=$4}} \
			END {for(name in value) {printf("%-20s %-22dB\n",name,value[name])}}' > $result_home/$i
		else
			cat $txt_home/$i|awk -F"|" '{$17=int($17);print $2,$8,$9,$17,$20}'|awk '{if(NF==5) {print $0}}'|awk '{value[$1]+=$2+$3;if($5==1){value[$1]+=$4}} \
			END {for(name in value) {printf("%-20s %-22dB\n",name,value[name])}}'  > $result_home/$i
		fi
	done
fi

if [ "$1" == "video" ]
then
        mkdir -p $result_home
        txt_home=$porject_home/102
        for i in `seq $3 $4`
        do
                if [ $# -eq 5 ]
                then
                        cat $txt_home/$i|grep -vE $5|awk -F"|" '{$17=int($17);print $2,$8,$9,$17,$20}'|awk '{if(NF==5) {print $0}}'|awk '{value[$1]+=$2+$3;if($5==1){value[$1]+=$4}} \
                        END {for(name in value) {printf("%-20s %-22dB\n",name,value[name])}}' > $result_home/$i
                else
                        cat $txt_home/$i|awk -F"|" '{$17=int($17);print $2,$8,$9,$17,$20}'|awk '{if(NF==5) {print $0}}'|awk '{value[$1]+=$2+$3;if($5==1){value[$1]+=$4}} \
                        END {for(name in value) {printf("%-20s %-22dB\n",name,value[name])}}'  > $result_home/$i
                fi
        done
fi
