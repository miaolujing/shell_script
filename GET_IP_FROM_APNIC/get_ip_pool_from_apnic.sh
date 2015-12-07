#!/bin/bash
export LANGUAGE=zh_CN.GB18030:zh_CN.GB2312:zh_CN
export LANG=zh_CN.GBK

FILE=`pwd`/IP_IPANIC
TMPD=`pwd`/TEMP
SUCC=`pwd`/SUCC_RESULT

####中国联通
CUCC_GROUP="CNC|UNICOM|WASU|NBIP|CERNET|CHINAGBN|CHINACOMM|FibrLINK|DXTNET"

####中国移动
CMCC_GROUP="CMNET|CRTC|CRBjB|CTTNET"

####中国电信
CTCC_GROUP="CHINATELECOM|CHINANET"

#######[APNIC]提供实时更新的IP地址池列表,TSV数据###############################
IP_POOL_APNIC="http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest"



CHECKER_USER()
{
	if [ `whoami` != root ]; then 
		echo "需要以ROOT权限,运行此脚本" 
		exit 
	fi
return 0;
}
################################################################################
CHECKER_PARAMETER()
{
	if [ $# -lt 1 ];then
			echo "#################################################"
			echo "Usage: `pwd`/get_ip_pool_from_apanic.sh"
			echo "#################################################"
	else
			echo "#################################################"
			echo "NOT NEED ARGV"
			echo "#################################################"
			exit 1
	fi
return 0;
}
################################################################################
INIT_DIR()
{
	if [ -d $TMPD ] ;then
		echo "Go Next Step"
	else 
		mkdir -p $TMPD
	fi
return 0;
}
################################################################################
PREPARE_RELATIONS()
{
	if [ -x /sbin/ipcalc ];then
			echo "/sbin/ipcalc is OK,Go next"
		else
			\cp `pwd`/ipcalc /sbin/ipcalc
		if [ $? -eq 0 ];then
			echo "OK!!!!"
			else 
			echo "Lack of file [/sbin/ipcalc] OR not have exec permission"
			exit 1
		fi
	fi
return 0;			
}
################################################################################


GET_APNIC_IP_LIST()
{
	rm -rf $FILE
	time /usr/bin/wget -T360 -q $IP_POOL_APNIC -O $FILE;
	if [ $? -eq 0 ];then
		echo "APANC数据集下载完毕,Go Next "
	else
		echo "下载IPADDR LIST FROM APANIC,FAILED!!!,Connect 360S TIMEOUT,PLEASE CHECK NETWORK CONNECTION!!!"
		exit 1
	fi
return 0;		
}

##########################分类处理中国移动、中国联通、中国电信 3类运营商的地址池信息###################################
_DEALWITH_IP_LIST() {
			echo "开始分拣数据……"
			echo "IP-----|OPERATOR-----|PROVINCE------|DESC------" > $TMPD/CUCC
			echo "IP-----|OPERATOR-----|PROVINCE------|DESC------" > $TMPD/CMCC
			echo "IP-----|OPERATOR-----|PROVINCE------|DESC------" > $TMPD/CTCC
			echo "IP-----|OPERATOR-----|PROVINCE------|DESC------" > $TMPD/OTHER

				grep 'apnic|CN|ipv4|' $FILE | cut -f 4,5 -d'|'| awk -F'|' '{print $1}' |while read IP_LIST
				do
					/usr/bin/whois $IP_LIST@whois.apnic.net | sed -n '/^inetnum/,/source/p' | awk '(/mnt-/ || /netname/ || /inetnum/ || /descr/ )' > $TMPD/next_tempfile
					IP_SECGMENT=`/sbin/ipcalc -r $(awk '1' $TMPD/next_tempfile|awk -F ':' '(/inetnum/) {print $2}')|tail -1`
					IP_AREA_OPEOF3=`awk '1' $TMPD/next_tempfile|awk -F ':' '(/netname/) {print $2}'|sed -e 's/        //g'`
					IP_PROVINCE=`echo $IP_AREA_OPEOF3|awk -F'-' '{print $2}'`
					IP_DESC=`awk '1' $TMPD/next_tempfile|awk -F ':' '(/descr/) {print $2}'|head -1|sed -e 's/          //g'`
					
					if [ -z $IP_PROVINCE ];then
						IP_PROVINCE='-'
					fi
					
					echo "$IP_AREA_OPEOF3" |egrep -qi "($CUCC_GROUP)" 
					if [ $? = 0 ];then
								echo $IP_SECGMENT'|'$IP_AREA_OPEOF3'|'$IP_PROVINCE'|'$IP_DESC  >> $TMPD/CUCC
						continue
					fi
					
					egrep -qi "($CMCC_GROUP)" $TMPD/next_tempfile
					if [ $? = 0 ];then
								echo $IP_SECGMENT'|'$IP_AREA_OPEOF3'|'$IP_PROVINCE'|'$IP_DESC  >> $TMPD/CMCC
						continue
					fi

					egrep -qi "($CTCC_GROUP)" $TMPD/next_tempfile
					if [ $? = 0 ];then
								echo $IP_SECGMENT'|'$IP_AREA_OPEOF3'|'$IP_PROVINCE'|'$IP_DESC  >> $TMPD/CTCC
						continue
					fi

					echo $IP_SECGMENT'|'$IP_AREA_OPEOF3'|'$IP_PROVINCE'|'$IP_DESC >> $TMPD/OTHER
				done
			echo "分拣数据完毕…";
			echo "中国移动[$TMPD/CMCC]";
			echo "中国联通[$TMPD/CUCC]";
			echo "中国电信[$TMPD/CTCC]";
return 0;
}

CLEAN_TEMP_FILES()
{
	rm -rf $TMPD/next_tempfile
	rm -rf $TMPD/CUCC
	rm -rf $TMPD/CMCC
	rm -rf $TMPD/CTCC
	rm -rf $TMPD/OTHER
return 0;	
}

GATHER_KEYWORDS()
{
	/bin/awk '1' $TMPD/CUCC|awk -F'|' '{print $1,$3}'|sed -e 's/ /|/g'|grep '^[0-9]' >  $SUCC
	/bin/awk '1' $TMPD/CMCC|awk -F'|' '{print $1,$3}'|sed -e 's/ /|/g'|grep '^[0-9]' >> $SUCC
	/bin/awk '1' $TMPD/CTCC|awk -F'|' '{print $1,$3}'|sed -e 's/ /|/g'|grep '^[0-9]' >> $SUCC
return 0;		
}


main(){
		echo "STEP1……"
		CHECKER_USER;
		echo "STEP2……"
		CHECKER_PARAMETER;
		echo "STEP3……"
		INIT_DIR;
		echo "STEP4……开始下载APNIC"
		GET_APNIC_IP_LIST;
		echo "STEP5……检测关联性"
		PREPARE_RELATIONS;
		echo "STEP6……开始分拣IP资源信息"
		_DEALWITH_IP_LIST;
		echo "STEP7……汇总IP资源信息"
		GATHER_KEYWORDS;
		echo "STEP8……开始清除临时文件"
		CLEAN_TEMP_FILES
		echo "清理临时数据完毕~~~~~~"
return 0				
}

main;
exit 0
