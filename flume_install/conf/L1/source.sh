#!/bin/bash
h=`cat ~/.bash_profile|grep -q FLUME_HOME`

if [ $? -eq 0]
then
     echo "FLUME_HOME is exits in bash"
else
     echo 'export FLUME_HOME=/usr/local/miner/miner-1.0.2-bin' >> ~/.bash_profile
     echo 'export PATH=$PATH:$FLUME_HOME/bin' >> ~/.bash_profile
     echo 'export FLUME_CONF_DIR=$FLUME_HOME/conf' >> ~/.bash_profile
fi

source ~/.bash_profile
