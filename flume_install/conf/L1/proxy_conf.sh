#!/bin/bash
ipaddr=`ifconfig eth0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "`
ipaddd=`ifconfig eth0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "|cut -f 1-2 -d "."`
BASE_HOME=/usr/local/miner/miner-1.0.2-bin/conf
h=proxy.conf
today=`date +%Y%m%d`
pcollect_port1=`awk '{if ($7~/'$ipaddd'\./ && $2=="EDGEHSM") print $4}' COLLECT_PORT.INFO`
pcollect_port2=`awk '{if ($7~/'$ipaddd'\./ && $2=="EDGEHSM") print $6}' COLLECT_PORT.INFO`
vcollect_port1=`awk '{if ($7~/'$ipaddd'\./ && $2=="VEDGEHSM") print $4}' COLLECT_PORT.INFO`
vcollect_port2=`awk '{if ($7~/'$ipaddd'\./ && $2=="VEDGEHSM") print $6}' COLLECT_PORT.INFO`
collect1=`awk '{if ($7~/'$ipaddd'\./ && $2=="EDGEHSM") print $3}' COLLECT_PORT.INFO`
collect2=`awk '{if ($7~/'$ipaddd'\./ && $2=="EDGEUCE") print $3}' COLLECT_PORT.INFO`
collect3=`awk '{if ($7~/'$ipaddd'\./ && $2=="CENTERHSM") print $3}' COLLECT_PORT.INFO`
collect4=`awk '{if ($7~/'$ipaddd'\./ && $2=="CENTERUCE") print $3}' COLLECT_PORT.INFO`
collect5=`awk '{if ($7~/'$ipaddd'\./ && $2=="CLOUDUCE") print $3}' COLLECT_PORT.INFO`
collect6=`awk '{if ($7~/'$ipaddd'\./ && $2=="PROXYHSM") print $3}' COLLECT_PORT.INFO`
collect1r=`awk '{if ($7~/'$ipaddd'\./ && $2=="EDGEHSM") print $5}' COLLECT_PORT.INFO`
collect2r=`awk '{if ($7~/'$ipaddd'\./ && $2=="EDGEUCE") print $5}' COLLECT_PORT.INFO`
collect3r=`awk '{if ($7~/'$ipaddd'\./ && $2=="CENTERHSM") print $5}' COLLECT_PORT.INFO`
collect4r=`awk '{if ($7~/'$ipaddd'\./ && $2=="CENTERUCE") print $5}' COLLECT_PORT.INFO`
collect5r=`awk '{if ($7~/'$ipaddd'\./ && $2=="CLOUDUCE") print $5}' COLLECT_PORT.INFO`
collect6r=`awk '{if ($7~/'$ipaddd'\./ && $2=="CLOUDUCE") print $5}' COLLECT_PORT.INFO`

cd $BASE_HOME
if [ -f $h ]
then
    echo "proxy is exist"
     mv  $h $h\.bak$today
fi

echo "##CHANNEL mem-channel1 ##  
agent1.channels.mem-channel1.type = memory  
agent1.channels.mem-channel1.capacity = 5000000  
agent1.channels.mem-channel1.transactionCapacity = 200000  
agent1.channels.mem-channel1.keep-alive = 30  
  
## DEFINE SOURCE udp-source1 ##  
agent1.sources.udp-source1.type = com.yeexun.flume.source.SyslogUDPSource  
agent1.sources.udp-source1.channels = mem-channel1  
agent1.sources.udp-source1.host = $ipaddr  
agent1.sources.udp-source1.port = 65013  
agent1.sources.udp-source1.thread.size = 10  
agent1.sources.udp-source1.corethread.size = 5  
agent1.sources.udp-source1.queue.size = 1000000  
  
## DEFINE SINK avro-sink11 ##  
agent1.sinks.avro-sink11.type = com.yeexun.flume.sink.AvroSink  
agent1.sinks.avro-sink11.rollInterval = 120000  
agent1.sinks.avro-sink11.channel = mem-channel1  
agent1.sinks.avro-sink11.hostname = $collect6  
agent1.sinks.avro-sink11.port = $pcollect_port1  
agent1.sinks.avro-sink11.batch-size = 1000  
  
## DEFINE SINK avro-sink11r ##  
agent1.sinks.avro-sink11r.type = com.yeexun.flume.sink.AvroSink  
agent1.sinks.avro-sink11r.rollInterval = 120000  
agent1.sinks.avro-sink11r.channel = mem-channel1  
agent1.sinks.avro-sink11r.hostname = $collect6r  
agent1.sinks.avro-sink11r.port = $pcollect_port2  
agent1.sinks.avro-sink11r.batch-size = 1000  
  
## DEFINE SINK-GROUP group1 ##
agent1.sinkgroups.group1.sinks = avro-sink11 avro-sink11r
agent1.sinkgroups.group1.processor.type = failover
agent1.sinkgroups.group1.processor.priority.avro-sink11 = 10
agent1.sinkgroups.group1.processor.priority.avro-sink11r = 5
agent1.sinkgroups.group1.processor.maxpenalty = 100000

### DEFINE AGENT agent1 ###
agent1.channels = mem-channel1 
agent1.sources = udp-source1 
agent1.sinks = avro-sink11 avro-sink11r
agent1.sinkgroups = group1" >> $h  
