#/bin/sh
NOW=`date +%Y%m%d`
today=`date +%Y%m%d`
PORTAL_HOME=/opt/onewave/hjl_tomcat_portal/webapps
BAK_DIR=/data/backup_portal
FTP_WAR=/data/soft/portal_install/$today/webcache.portal-*.war
PASSWD=0wlonewave
_killpid(){

 PORTAL_PID=`ps -ef|grep hjl_tomcat_portal|grep -v grep|grep -v cronolog|awk '{print $2}'`
        if [ "$PORTAL_PID" != "" ];then
                echo "PORTAL进程还存在,我将杀掉它";
                echo "PORTAL进程号为:[$PORTAL_PID]";
              #   kill   -9  $PORTAL_PID;
		sleep 5
        fi

}

_cpwar(){
	#备份原先的包
	cd  $PORTAL_HOME
	echo '----cd portal webapps end----'
	 cp -rf portal  $BAK_DIR/PORTAL_$NOW
	rm  $PORTAL_HOME/portal/*   -rf
	#cd  /data/war
	#echo $PASSWD|scp -r -P 5188 10.254.240.110:/data/build/portal/20140327/webcache.portal/target/*.war .
        \cp $FTP_WAR  $PORTAL_HOME/portal
        cd  $PORTAL_HOME/portal        
	unzip  webcache.portal-*.war 
        echo '--------new tag unzip ok---------'
}

_configbak(){
       echo    "需要还原7个配置文件"
        echo    "portal/WEB-INF/conf/config.properties"
        echo    "portal/modules/webcache.portal/web/logdownload/logdownload.html"
        echo    "portal/modules/webcache.portal/META-INF/services/config/spring/config.properties"
        echo    "portal/modules/webcache.portal/META-INF/services/config/security.properties"
        echo    "portal/WEB-INF/conf/log4j.global.properties"
        echo    "portal/modules/webcache.portal/META-INF/services/config/spring/spContentType.properties"
        echo    "portal/modules/webcache.portal/META-INF/services/config/spring/common.properties"
        echo    "开始执行还原"
        cd $PORTAL_HOME/portal
        \cp -rf         $BAK_DIR/PORTAL_$NOW/WEB-INF/conf/config.properties        WEB-INF/conf/config.properties
        \cp -rf         $BAK_DIR/PORTAL_$NOW/modules/webcache.portal/web/logdownload/logdownload.html      modules/webcache.portal/web/logdownload/logdownload.html
        \cp -rf         $BAK_DIR/PORTAL_$NOW/modules/webcache.portal/META-INF/services/config/spring/config.properties     modules/webcache.portal/META-INF/services/config/spring/config.properties
        \cp -rf         $BAK_DIR/PORTAL_$NOW/modules/webcache.portal/META-INF/services/config/security.properties          modules/webcache.portal/META-INF/services/config/security.properties
        \cp -rf         $BAK_DIR/PORTAL_$NOW/WEB-INF/conf/log4j.global.properties  WEB-INF/conf/log4j.global.properties
        \cp -rf         $BAK_DIR/PORTAL_$NOW/modules/webcache.portal/META-INF/services/config/spring/spContentType.properties modules/webcache.portal/META-INF/services/config/spring/spContentType.properties
  echo "配置文件还原完毕"
}

_startup(){
         cd  $PORTAL_HOME/
         cd ../bin/
         rm -rf ../work/*
#         ./catalina.sh start
}

_killpid

_cpwar

_configbak

_startup
