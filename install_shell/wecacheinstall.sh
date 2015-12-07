#!/bin/bash
today=`date "+%Y%m%d"`
today1=`date "+%Y%m%d%H%M%S"`
bak_dir=/data/bakup/$today
bak_dir1=/data/bakup/$today1
oss_dir=/opt/onewave/tomcat_oss/webapps/oss
agent_dir=/opt/component/webcache.agent
war_agent=webcache.agent.war
war_oss=webcache.oss.war
war_dir=/data/soft/$today

#kill pid
pid=`ps -ef|grep oss|grep -v grep|awk '{print $2}'`
if [ "$pid" != "" ]
then
     kill -9 $pid
     sleep 5
     echo "停止进程成功"
     sleep 2
fi

#bakup_oss
if [ -d $bak_dir ]
then
     mv $bak_dir $bak_dir1
     mkdir -p $bak_dir
else
     mkdir -p $bak_dir
fi
cd /opt/onewave/tomcat_oss/webapps/
tar -cvzf ossbak.tar.gz oss
mv ossbak.tar.gz $bak_dir
cp $oss_dir/modules/webcache.oss/META-INF/services/config/spring/config.properties /opt/config.properties1_bak
cp $oss_dir/modules/webcache.oss/web/portal/index.html /opt/index.html_bak
cp $oss_dir/WEB-INF/conf/config.properties /opt/config.properties_bak
cp $oss_dir/modules/webcache.oss/META-INF/services/config/spring/solarwinds.properties /opt/solarwinds.properties_bak
cp $oss_dir/WEB-INF/conf/log4j.global.properties /opt/log4j.global.properties_bak
cp $oss_dir/modules/webcache.sp/META-INF/services/config/spring/spContentType.properties /opt/spContentType.properties_bak
cp $oss_dir/modules/webcache.sp/META-INF/services/config/spring/config.properties /opt/config.properties2_bak
#cp $oss_dir/modules/webcache.oss/bin/cloudIp/cloudIp.txt /opt/cloudIp.txt_bak
cp $oss_dir/modules/webcache.basic/META-INF/services/config/spring/config.properties /opt/config.properties3_bak
cp $oss_dir/modules/webcache.message.handler/META-INF/services/config/spring/config.properties   /opt/config.properties_messagehander
cp $oss_dir/modules/webcache.oss/META-INF/services/config/spring/uploadPath.properties /opt/uploadPath.properties_bak
cp $oss_dir/modules/pkgng/META-INF/services/config/spring/pkgng.properties /opt/pkgng.properties_bak
#bakup_agent
#cd $agent_dir
#mv $war_agent $bak_dir

#install_oss
if [ -d $war_dir -a -s $war_dir/$war_oss ]
then
    cd $oss_dir
    rm -rf *     
    cp $war_dir/$war_oss .
else
    echo "没有安装包，退出升级"
    exit 0
fi
unzip $war_oss
rm -rf $war_oss
cd modules/webcache.oss/META-INF/services/config/spring
rm -rf config.properties
rm -rf solarwinds.properties
rm -rf uploadPath.properties
mv /opt/config.properties1_bak config.properties
mv /opt/solarwinds.properties_bak solarwinds.properties
mv /opt/uploadPath.properties_bak uploadPath.properties
cd $oss_dir/modules/webcache.oss/web/portal
rm -rf index.html
mv /opt/index.html_bak index.html
cd $oss_dir/WEB-INF/conf
rm -rf config.properties
rm -rf log4j.global.properties
mv /opt/config.properties_bak config.properties
mv /opt/log4j.global.properties_bak log4j.global.properties
cd $oss_dir/modules/webcache.sp/META-INF/services/config/spring
rm -rf spContentType.properties
mv /opt/spContentType.properties_bak spContentType.properties
#cd $oss_dir/modules/webcache.oss/bin/cloudIp
#rm -rf cloudIp.txt
#mv /opt/cloudIp.txt_bak cloudIp.txt
cd $oss_dir/modules/webcache.sp/META-INF/services/config/spring
rm -rf config.properties
mv /opt/config.properties2_bak config.properties
cd $oss_dir/modules/webcache.basic/META-INF/services/config/spring
rm -rf config.properties
mv /opt/config.properties3_bak config.properties
cd $oss_dir/modules/webcache.message.handler/META-INF/services/config/spring/
\cp -rf /opt/config.properties_messagehander  config.properties
cd $oss_dir/modules/pkgng/META-INF/services/config/spring
rm -rf pkgng.properties
mv /opt/pkgng.properties_bak pkgng.properties
#install_agent
#if [ -d $war_dir -a -s $war_dir/$war_agent ]
#then
    #cp $war_dir/$war_agent $agent_dir/
#else
    #echo "没有安装包，退出升级"
    #exit 0
#fi

echo "升级成功"
