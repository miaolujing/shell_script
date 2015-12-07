#!/bin/sh

source /opt/install/common.sh

today=`date "+%Y%m%d"`
bakup=backup_txtcollect
war=collect-4.1.1.5
wardir=/txtcollect_install/$today
conf=/opt/txtconf

for i in "collect_pic" "collect_vid"
do
     #kill pid
     stop_pid $i

     #bakup_war
     bakup_war $bakup $i
     
     #bakup_conf
     if [ -d $conf ]
     then
          rm -rf $conf
          mkdir -p $conf
     else
          mkdir -p $conf
     fi

     cp /opt/$i/bin/collect $conf/collect.bak
     cp /opt/$i/config/config.properties $conf/config.properties.bak
     cp /opt/$i/config/ftpservers.xml $conf/ftpservers.xml.bak
     cp /opt/$i/config/ne_ftpserver.xml $conf/ne_ftpserver.xml.bak
     cp /opt/$i/config/etl_db.cfg $conf/etl_db.cfg.bak

     #install
     install $wardir $war $i
     \cp -rf $conf/collect.bak /opt/$i/bin/collect
     \cp -rf $conf/config.properties.bak /opt/$i/config/config.properties
     \cp -rf $conf/ftpservers.xml.bak /opt/$i/config/ftpservers.xml
     \cp -rf $conf/ne_ftpserver.xml.bak /opt/$i/config/ne_ftpserver.xml
     \cp -rf $conf/etl_db.cfg.bak /opt/$i/config/etl_db.cfg

echo "升级成功"
done
