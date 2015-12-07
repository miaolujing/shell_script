#!/bin/bash
echo 'export FLUME_HOME=/usr/local/miner/miner-1.0.2-bin' >> ~/.bash_profile
echo 'export PATH=$PATH:$FLUME_HOME/bin' >> ~/.bash_profile
echo 'export FLUME_CONF_DIR=$FLUME_HOME/conf' >> ~/.bash_profile
echo 'export LANG=en_US.UTF-8' >> ~/.bash_profile
echo 'export JAVA_HOME=/usr/java/jdk1.6.0_21' >> ~/.bash_profile
echo 'export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar' >> ~/.bash_profile
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bash_profile

source ~/.bash_profile
