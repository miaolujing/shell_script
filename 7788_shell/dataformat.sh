#!/bin/sh

Log_Home=/data/portalresult

for i in `ls $Log_Home`
do
	ls $Log_Home/$i|grep -q '.txt'
	if [ $? -eq 0 ]
	then
		for j in `ls $Log_Home/$i/*.txt|awk -F"." '{print $1}'|awk -F"_" '{print $NF}'|cut -b 1-8|sort|uniq`
		do
			mkdir -p $Log_Home/$i/$j
			mv $Log_Home/$i/*$j*txt $Log_Home/$i/$j
		done
	fi
done
		

