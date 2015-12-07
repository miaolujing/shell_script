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

if [ "$1" == "lgw" ]
then
        mkdir -p $result_home
        txt_home=$porject_home
        for i in `seq $3 $4`
        do
                if [ $# -eq 5 ]
                then
                        cat $txt_home/$i|grep -vE $5|awk '{if($8=="http-proxy" && $11!=443) {hsum+=$16;hqsum+=$17}  else if ($8=="http-proxy" && $11==443) {ssum+=$16;sqsum+=$17} \
                        else if($8=="nat-route") {nsum+=$19;nqsum+=$18}} \
                        END {printf("hsum %20dB\nhqsum %20dB\nssum %20dB\nsqsum %20dB\nnsum %20dB\nnqsum %20dB\n",hsum,hqsum,ssum,sqsum,nsum,nqsum)}' > $result_home/$i
                else
                        cat $txt_home/$i|awk '{if($8=="http-proxy") {hsum+=$16;hqsum+=$17} else if ($8=="http-proxy" && $11==443) {ssum+=$16;sqsum+=$17} \
                        else if($8=="nat-route") {nsum+=$19;nqsum+=$18}} \
                        END {printf("hsum %20dB\nhqsum %20dB\nssum %20dB\nsqsum %20dB\nnsum %20dB\nnqsum %20dB\n",hsum,hqsum,ssum,sqsum,nsum,nqsum)}' > $result_home/$i
                fi
        done
fi
