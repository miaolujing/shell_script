#!/bin/bash
SCRIPT_HOME=`pwd`
cd $SCRIPT_HOME
#rpm -ivh --force --nodeps expect-5.42.1-1.i386.rpm
#rpm -ivh --force --nodeps expect-devel-5.42.1-1.i386.rpm
#chmod +x ZJL1_FILE.et
> /root/.ssh/known_hosts
LOG_FILE=COLLECT.log
for KEY in `awk '1' COLLECT_HOST.INFO|awk NR!=1`
do
{
	SERVER_IP=`echo $KEY|awk -F'|' '{print $1}'`
	SERVER_PORT=`echo $KEY|awk -F'|' '{print $2}'`
	ROOT_PASS=`echo $KEY|awk -F'|' '{print $3}'`
	./COLLECT_CONF.et $SERVER_IP $SERVER_PORT $ROOT_PASS >> $LOG_FILE 2>&1 
}
done
