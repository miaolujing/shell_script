#!/bin/sh
#此脚本定义通用方法，可直接在其他脚本中调用
today=`date "+%Y%m%d"`
today1=`date "+%Y%m%d%H%M%S"`
war_dir=/data/soft

#以下为txtcollect的通用方法
stop_pid(){
    pid=`ps -ef|grep $1|grep -v grep|awk '{print $2}'`
    if [ "$pid" != "" ]
     then
          /opt/$1/bin/collect stop
          sleep 8
          echo "停止进程完毕"
          sleep 2
     fi
}


bakup_war(){
     bak_dir=/data/$1/$2$today
     bak_dir1=/data/$1/$2$today1
     if [ -d $bak_dir ]
     then
          echo "备份目录已存在"
          mv $bak_dir $bak_dir1
          mkdir -p $bak_dir
     else
          mkdir -p $bak_dir
     fi
     
     cd /opt
     tar -cvzf $2.tar.gz $2
     mv $2.tar.gz $bak_dir
}

install(){
     if [ -d $war_dir/$1 -a -s $war_dir/$1/$2.tar.gz ]
     then
           rm -rf /opt/$3
           tar -zxvf $war_dir/$1/$2.tar.gz -C /opt
           mv /opt/$2 /opt/$3
     else 
           echo "war is not exits"
     fi
}

#以下为tomcat通用方法

kill_pid(){
     pid=`ps -ef|grep $1|grep -v grep|awk '{print $2}'`
     if [ "$pid" != "" ]
     then
          kill -9 $pid
          sleep 5
          echo "停止进程成功"
          sleep 2
     fi
}

bakup_tomcat(){
     bak_dir=/data/$1/$today
     bak_dir1=/data/$1/$today1
     if [ -d $bak_dir ]
     then
          echo "备份目录已存在"
          mv $bak_dir $bak_dir1
          mkdir -p $bak_dir
     else
          mkdir -p $bak_dir
     fi
     
     cd /opt/onewave/$2/webapps
     tar -cvzf $3.tar.gz $3
     mv $3.tar.gz $bak_dir
}

install_tomcat(){
     web=`echo $3|awk -F"_" '{print $2}'`
     tomcat_dir=/opt/onewave/$3/webapps/$web
     if [ -d $war_dir/$1 -a -s $war_dir/$1/$2 ]
     then
          cd $tomcat_dir
          rm -rf *
          cp $war_dir/$1/$2 .
     else
          echo "没有安装包，退出安装"
          exit
     fi
      
     unzip $2
     rm -rf $2
}
