#!/bin/sh

if [ $# -lt 1 ]
then
	echo "Usage:$0 projechname"
	exit
fi

time=`date "+%Y%m%d%H%M%S"`
build_dir=/opt/gocode/src/hawkeye/$1
bak_dir=/data/bak/$1/master/$time
if [ -d $build_dir ]
then
        echo "file exits,rm"
        rm -rf $build_dir
fi

#build
mv /root/.jenkins/jobs/$1/workspace $build_dir
cd $build_dir
go get ./...
chmod +x control
./control pack

#bak
if [ -d $bak_dir ]
then
        mv $build_dir/*.tar.gz $bak_dir/
        rm -rf $build_dir
else
        mkdir -p $bak_dir
        mv $build_dir/*.tar.gz $bak_dir/
        rm -rf $build_dir
fi
