#!/bin/bash
echo "此脚本替换当前目录下的class到WEB-INF中"

binpath=/opt/onewave/tomcat_portalsh/webapps/portal/WEB-INF/classes
today=`date "+%y%m%d%H%M%S"`

if [ ! -d $binpath ]
then
    echo "binpath不存在，退出替换"
    exit 0
fi

for i in *.class
do
  classname=`echo "$i"|sed 's/\.class//g'`
  classname1=`echo $classname|sed 's/\$.*//g'`
  classpath=`javap $classname|grep -oP '(?<=class ).*(?=\.'$classname1'.* extends)'|sed -e 's/\./\//g'`

  if [ -f $binpath/$classpath/$i ]
  then
      mv $binpath/$classpath/$i $binpath/$classpath/$i\.$today
      cp $i $binpath/$classpath
  else
      mkdir -p $binpath/$classpath
      cp $i $binpath/$classpath/$i
  fi
  echo "替换完成"
done
