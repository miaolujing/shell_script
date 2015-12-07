#!/bin/sh
#create by mlj

main_home=/opt/mlj/txt
#today=`date "+%Y%m%d"`

if [ $# -lt 4 ]
then
	echo "Usage:$0 picture 20140920 99 112"
        echo "Usage:$0 业务类型 date time"
        echo "业务类型 dns/picture/video/lgw/rtmp"
        exit
fi

porject_home=$main_home/$1/$2

if [ -d "$porject_home" ]
then
	echo "file is already exits"
else
	mkdir -p $porject_home
fi

if [ "$1" == "picture" ]
then
	for i in `seq -f %03g 1 6`
	do
		for j in `seq $3 $4`
		do
			txt_home=$porject_home/$i
			mkdir -p $txt_home
   			hadoop fs -text /flume/test/huatong/$1/$2/$j/$i/*.snappy >> $txt_home/$j 2>/dev/null
		done
	done
fi

if [ "$1" == "video" ]
then
        for i in {101..106}
        do
                for j in `seq $3 $4`
                do
                        txt_home=$porject_home/$i
                        mkdir -p $txt_home
                        hadoop fs -text /flume/test/huatong/$1/$2/$j/$i/*.snappy >> $txt_home/$j 2>/dev/null
                done
        done
fi

if [ "$1" == "dns" ]
then
	for i in `seq $3 $4`
	do
		txt_home=$porject_home
		mkdir -p $txt_home
		hadoop fs -text /flume/test/huatong/$1/$2/$i/201/*.snappy >> $txt_home/$i 2>/dev/null
	done
fi

if [ "$1" == "lgw" ]
then
        for i in `seq $3 $4`
        do
                txt_home=$porject_home
                mkdir -p $txt_home
                hadoop fs -text /flume/test/huatong/$1/$2/$i/301/*.snappy >> $txt_home/$i 2>/dev/null
        done
fi

if [ "$1" == "rtmp" ]
then
        for i in `seq $3 $4`
        do
                txt_home=$porject_home
                mkdir -p $txt_home
                hadoop fs -text /flume/test/huatong/$1/$2/$i/401/*.snappy >> $txt_home/$i 2>/dev/null
        done
fi
