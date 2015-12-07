#!/bin/sh

source /opt/install/common.sh

today=`date "+%Y%m%d"`
bakup=backup_portal
tmn=tomcat_portal
conf=/opt/spconf
warins=/opt/onewave/tomcat_portal/webapps/portal
wardir=/portal_install/$today
warname=webcache.portal.war

#kill_pid
kill_pid $tmn

#bakup
bakup_tomcat $bakup $tmn portal

#bakconf
if [ -d $conf ]
then
      rm -rf $conf
      mkdir -p $conf
else
      mkdir -p $conf
fi

cp $warins/WEB-INF/conf/config.properties $conf/config.properties.bak
cp $warins/WEB-INF/conf/log4j.global.properties $conf/log4j.global.properties.bak
cp $warins/modules/webcache.portal/web/logdownload/logdownload.html $conf/logdownload.html.bak
cp $warins/modules/webcache.portal/META-INF/services/config/spring/config.properties $conf/config.properties.bak1
cp $warins/modules/webcache.portal/META-INF/services/config/spring/spContentType.properties $conf/spContentType.properties.bak
cp $warins/modules/webcache.portal/META-INF/services/config/security.properties $conf/security.properties.bak

#install
install_tomcat $wardir $warname $tmn
\cp -rf $conf/config.properties.bak $warins/WEB-INF/conf/config.properties
\cp -rf $conf/log4j.global.properties.bak $warins/WEB-INF/conf/log4j.global.properties
\cp -rf $conf/logdownload.html.bak $warins/modules/webcache.portal/web/logdownload/logdownload.html
\cp -rf $conf/config.properties.bak1 $warins/modules/webcache.portal/META-INF/services/config/spring/config.properties
\cp -rf $conf/spContentType.properties.bak $warins/modules/webcache.portal/META-INF/services/config/spring/spContentType.properties
\cp -rf $conf/security.properties.bak $warins/modules/webcache.portal/META-INF/services/config/security.properties

echo "升级完成"
