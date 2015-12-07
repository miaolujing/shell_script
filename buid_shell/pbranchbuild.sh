#!/bin/sh

time=`date "+%Y%m%d%H%M%S"`
build_dir=/opt/gocode/src/pagent
bak_dir=/data/bak/pagent/branch/$time
if [ -d $build_dir ]
then
	echo "file exits,rm"
	rm -rf $build_dir
fi

#build
mv /root/.jenkins/jobs/pagent-branch/workspace $build_dir
cd $build_dir
go get ./...
cp cfg.example.json cfg.json
go test ./...|grep FAIL
if [ $? -eq 1 ]
then
	chmod +x control
        ./control pack
else
        echo "test fail"
        exit
fi

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
