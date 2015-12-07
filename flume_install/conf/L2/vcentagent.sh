#！/bin/bash
ipaddr=`ifconfig eth0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "`
ipaddd=`ifconfig eth0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "|cut -f 1-2 -d "."`
BASE_HOME=/usr/local/miner/miner-1.0.2-bin/conf
h=vcentagent-01.conf
today=`date "+%Y%m%d"`
pcollect_port1=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="EDGEHSM") print $4}' COLLECT_PORT.INFO`
pcollect_port2=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="EDGEHSM") print $6}' COLLECT_PORT.INFO`
vcollect_port1=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="VEDGEHSM") print $4}' COLLECT_PORT.INFO`
vcollect_port2=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="VEDGEHSM") print $6}' COLLECT_PORT.INFO`
collect1=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="EDGEHSM") print $3}' COLLECT_PORT.INFO`
collect2=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="EDGEUCE") print $3}' COLLECT_PORT.INFO`
collect3=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="CENTERHSM") print $3}' COLLECT_PORT.INFO`
collect4=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="CENTERUCE") print $3}' COLLECT_PORT.INFO`
collect5=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="CLOUDUCE") print $3}' COLLECT_PORT.INFO`
collect6=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="PROXYHSM") print $3}' COLLECT_PORT.INFO`
collect1r=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="EDGEHSM") print $5}' COLLECT_PORT.INFO`
collect2r=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="EDGEUCE") print $5}' COLLECT_PORT.INFO`
collect3r=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="CENTERHSM") print $5}' COLLECT_PORT.INFO`
collect4r=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="CENTERUCE") print $5}' COLLECT_PORT.INFO`
collect5r=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="CLOUDUCE") print $5}' COLLECT_PORT.INFO`
collect6r=`awk '{if ($7~/'"$ipaddd"'\./ && $2=="CLOUDUCE") print $5}' COLLECT_PORT.INFO`

cd $BASE_HOME
if [ -f $h ]
then
     echo "conf is exist"
     mv $h $h\.bak$today
fi

for i in {1..5}
do
   echo "####----------HZCEN-VID-0$i-----------####

## 以下为中心HSM日志配置 ##
## 配置channel ##
## DEFINE CHANNEL mem-channel${i}1 ##
agent1.channels.mem-channel${i}1.type = memory
agent1.channels.mem-channel${i}1.capacity = 1000000
agent1.channels.mem-channel${i}1.transactionCapacity = 200000
agent1.channels.mem-channel${i}1.keep-alive = 30

## 配置源地址 ##
## DEFINE SOURCE udp-source${i}1 ##
agent1.sources.udp-source${i}1.type = com.yeexun.flume.source.SyslogUDPSource
agent1.sources.udp-source${i}1.channels = mem-channel${i}1
##### NEED TO UPDATE, local IP ####
agent1.sources.udp-source${i}1.host = $ipaddr
##### NEED TO UPDATE, UDP PORT ####
agent1.sources.udp-source${i}1.port = 65111
agent1.sources.udp-source${i}1.thread.size = 10
agent1.sources.udp-source${i}1.corethread.size = 5
agent1.sources.udp-source${i}1.queue.size = 1000000

## 配置上传到collect地址 ##
## DEFINE SINK avro-sink${i}1 ##
agent1.sinks.avro-sink${i}1.type = com.yeexun.flume.sink.AvroSink
agent1.sinks.avro-sink${i}1.rollInterval = 120000
agent1.sinks.avro-sink${i}1.channel = mem-channel${i}1
#### NEED TO UPDATE, collector IP ####
agent1.sinks.avro-sink${i}1.hostname = $collect3
#### NEED TO UPDATE, collector avro tcp port #### 
agent1.sinks.avro-sink${i}1.port = $vcollect_port1
agent1.sinks.avro-sink${i}1.batch-size = 1000

## 配置冗余collect地址 ##
## DEFINE SINK avro-sink${i}1r ##
agent1.sinks.avro-sink${i}1r.type = com.yeexun.flume.sink.AvroSink
agent1.sinks.avro-sink${i}1r.rollInterval = 120000
agent1.sinks.avro-sink${i}1r.channel = mem-channel${i}1
agent1.sinks.avro-sink${i}1r.hostname = $collect3r
agent1.sinks.avro-sink${i}1r.port = $vcollect_port2
agent1.sinks.avro-sink${i}1r.batch-size = 1000

## DEFINE SINK-GROUP group${i}1 ##
agent1.sinkgroups.group${i}1.sinks = avro-sink${i}1 avro-sink${i}1r
agent1.sinkgroups.group${i}1.processor.type = failover
agent1.sinkgroups.group${i}1.processor.priority.avro-sink${i}1 = 10
agent1.sinkgroups.group${i}1.processor.priority.avro-sink${i}1r = 5
agent1.sinkgroups.group${i}1.processor.maxpenalty = 100000

## 以下为中心UCE日志配置 ##
## DEFINE CHANNEL mem-channel${i}2 ##
agent1.channels.mem-channel${i}2.type = memory
agent1.channels.mem-channel${i}2.capacity = 1000000
agent1.channels.mem-channel${i}2.transactionCapacity = 200000
agent1.channels.mem-channel${i}2.keep-alive = 30

## DEFINE SOURCE udp-source${i}2 ##
agent1.sources.udp-source${i}2.type = com.yeexun.flume.source.SyslogUDPSource
agent1.sources.udp-source${i}2.channels = mem-channel${i}2
##### NEED TO UPDATE, local IP ####
agent1.sources.udp-source${i}2.host = $ipaddr
##### NEED TO UPDATE, UDP PORT ####
agent1.sources.udp-source${i}2.port = 65121
agent1.sources.udp-source${i}2.thread.size = 10
agent1.sources.udp-source${i}2.corethread.size = 5
agent1.sources.udp-source${i}2.queue.size = 1000000

## DEFINE SINK avro-sink${i}2 ##
agent1.sinks.avro-sink${i}2.type = com.yeexun.flume.sink.AvroSink
agent1.sinks.avro-sink${i}2.rollInterval = 120000
agent1.sinks.avro-sink${i}2.channel = mem-channel${i}2
#### NEED TO UPDATE, collector IP ####
agent1.sinks.avro-sink${i}2.hostname = $collect4
#### NEED TO UPDATE, collector avro tcp port #### 
agent1.sinks.avro-sink${i}2.port = $vcollect_port1
agent1.sinks.avro-sink${i}2.batch-size = 1000

## DEFINE SINK avro-sink${i}2r ##
agent1.sinks.avro-sink${i}2r.type = com.yeexun.flume.sink.AvroSink
agent1.sinks.avro-sink${i}2r.channel = mem-channel${i}2
agent1.sinks.avro-sink${i}2r.hostname = $collect4r
agent1.sinks.avro-sink${i}2r.port = $vcollect_port2
agent1.sinks.avro-sink${i}2r.batch-size = 1000

## DEFINE SINK-GROUP group${i}2 ##
agent1.sinkgroups.group${i}2.sinks = avro-sink${i}2 avro-sink${i}2r
agent1.sinkgroups.group${i}2.processor.type = failover
agent1.sinkgroups.group${i}2.processor.priority.avro-sink${i}2 = 10
agent1.sinkgroups.group${i}2.processor.priority.avro-sink${i}2r = 5
agent1.sinkgroups.group${i}2.processor.maxpenalty = 100000

## DEFINE CHANNEL mem-channel${i}3 ##
agent1.channels.mem-channel${i}3.type = memory
agent1.channels.mem-channel${i}3.capacity = 1000000
agent1.channels.mem-channel${i}3.transactionCapacity = 200000
agent1.channels.mem-channel${i}3.keep-alive = 30

## DEFINE SOURCE udp-source${i}3 ##
agent1.sources.udp-source${i}3.type = com.yeexun.flume.source.SyslogUDPSource
agent1.sources.udp-source${i}3.channels = mem-channel${i}3
##### NEED TO UPDATE, local IP ####
agent1.sources.udp-source${i}3.host = $ipaddr
##### NEED TO UPDATE, UDP PORT ####
agent1.sources.udp-source${i}3.port = 65131
agent1.sources.udp-source${i}3.thread.size = 10
agent1.sources.udp-source${i}3.corethread.size = 5
agent1.sources.udp-source${i}3.queue.size = 1000000

## DEFINE SINK avro-sink${i}3 ##
agent1.sinks.avro-sink${i}3.type = com.yeexun.flume.sink.AvroSink
agent1.sinks.avro-sink${i}3.rollInterval = 120000
agent1.sinks.avro-sink${i}3.channel = mem-channel${i}3
#### NEED TO UPDATE, collector IP ####
agent1.sinks.avro-sink${i}3.hostname = $collect5
#### NEED TO UPDATE, collector avro tcp port #### 
agent1.sinks.avro-sink${i}3.port = $vcollect_port1
agent1.sinks.avro-sink${i}3.batch-size = 1000

## DEFINE SINK avro-sink${i}3r ##
agent1.sinks.avro-sink${i}3r.type = com.yeexun.flume.sink.AvroSink
agent1.sinks.avro-sink${i}3r.rollInterval = 120000
agent1.sinks.avro-sink${i}3r.channel = mem-channel${i}3
agent1.sinks.avro-sink${i}3r.hostname = $collect5r
agent1.sinks.avro-sink${i}3r.port = $vcollect_port2
agent1.sinks.avro-sink${i}3r.batch-size = 1000

## DEFINE SINK-GROUP group${i}3 ##
agent1.sinkgroups.group${i}3.sinks = avro-sink${i}3 avro-sink${i}3r
agent1.sinkgroups.group${i}3.processor.type = failover
agent1.sinkgroups.group${i}3.processor.priority.avro-sink${i}3 = 10
agent1.sinkgroups.group${i}3.processor.priority.avro-sink${i}3r = 5
agent1.sinkgroups.group${i}3.processor.maxpenalty = 100000" >> $h
echo "" >> $h
done

echo "### DEFINE AGENT agent1 ###
agent1.channels = mem-channel11 mem-channel12 mem-channel13 mem-channel21 mem-channel22 mem-channel23 mem-channel31 mem-channel32 mem-channel33 mem-channel41 mem-channel42 mem-channel43 mem-channel51 mem-channel52 mem-channel53
agent1.sources = udp-source11 udp-source12 udp-source13 udp-source21 udp-source22 udp-source23 udp-source31 udp-source32 udp-source33 udp-source41 udp-source42 udp-source43 udp-source51 udp-source52 udp-source53
agent1.sinks = avro-sink11 avro-sink12 avro-sink13 avro-sink21 avro-sink22 avro-sink23 avro-sink31 avro-sink32 avro-sink33 avro-sink41 avro-sink42 avro-sink43 avro-sink51 avro-sink52 avro-sink53 avro-sink11r avro-sink12r avro-sink13r avro-sink21r avro-sink22r avro-sink23r avro-sink31r avro-sink32r avro-sink33r avro-sink41r avro-sink42r avro-sink43r avro-sink51r avro-sink52r avro-sink53r
agent1.sinkgroups = group11 group12 group13 group21 group22 group23 group31 group32 group33 group41 group42 group43 group51 group52 group53" >> $h
