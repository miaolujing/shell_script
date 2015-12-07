#!/bin/bash
ipaddr=`ifconfig eth0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "`
BASE_HOME=/usr/local/miner/miner-1.0.2-bin/conf
h=VCOLLECTOR-001.conf
cd $BASE_HOME

for i in {1..10}
do
sector=`awk '{if ($13~/'"$i"'\./ &&$5=="EDGEHSM") print $1}' COLLECT_PORT.INFO`
port2=`awk '{if ($8~/'"$ipaddr"'/ && $4=="video" && $13~/'"$i"'\./) print $9}' COLLECT_PORT.INFO` 
type2=`awk '{if ($8~/'"$ipaddr"'/ && $4=="video" && $13~/'"$i"'\./) print $5}' COLLECT_PORT.INFO`
device2=`awk '{if ($8~/'"$ipaddr"'/ && $4=="video" && $13~/'"$i"'\./) print $6}' COLLECT_PORT.INFO`
agent2=`awk '{if ($8~/'"$ipaddr"'/ && $4=="video" && $13~/'"$i"'\./) print $2}' COLLECT_PORT.INFO`

echo "#DEFINE CHANNEL mem-channel$i ##
agent1.channels.mem-channel$i.type = memory
agent1.channels.mem-channel$i.capacity = 5000000
agent1.channels.mem-channel$i.transactionCapacity = 400000
agent1.channels.mem-channel$i.keep-alive = 30

## DEFINE SOURCE avro-source$i ##
agent1.sources.avro-source$i.type = avro
agent1.sources.avro-source$i.channels = mem-channel$i
agent1.sources.avro-source$i.bind = $ipaddr
agent1.sources.avro-source$i.port = $port2
agent1.sources.avro-source$i.threads = 80

## DEFINE SINK hdfs-sink$i ##
agent1.sinks.hdfs-sink$i.type = com.yeexun.flume.sink.hdfs.HDFSEventSink
agent1.sinks.hdfs-sink$i.channel = mem-channel$i
agent1.sinks.hdfs-sink$i.hdfs.batchSize = 400000
agent1.sinks.hdfs-sink$i.hdfs.fileType = SequenceFile
agent1.sinks.hdfs-sink$i.hdfs.writeFormat = TEXT
agent1.sinks.hdfs-sink$i.hdfs.codeC = snappy
agent1.sinks.hdfs-sink$i.hdfs.rollCount = 2000000
agent1.sinks.hdfs-sink$i.hdfs.rollSize = 0
agent1.sinks.hdfs-sink$i.hdfs.rollInterval = 100
agent1.sinks.hdfs-sink$i.hdfs.callTimeout = 120000
agent1.sinks.hdfs-sink$i.hdfs.callTimeout = 120000
agent1.sinks.hdfs-sink$i.post.url = http://10.1.4.44:8080/logservice/api/v1/log
agent1.sinks.hdfs-sink$i.agent.id = $agent2
agent1.sinks.hdfs-sink$i.sector.id = $sector
agent1.sinks.hdfs-sink$i.origin.id = huatong
agent1.sinks.hdfs-sink$i.fs.type = file
agent1.sinks.hdfs-sink$i.config.dir = /etc/hdfs1/conf
agent1.sinks.hdfs-sink$i.dir.header = hdfs://hdfs1/flume/test
agent1.sinks.hdfs-sink$i.business.type = video
agent1.sinks.hdfs-sink$i.log.type = $type2
agent1.sinks.hdfs-sink$i.device.id = $device2" >>$h
echo "" >>$h
done

echo "### DEFINE agent1 agent2 agent3 agent4 agent5 agent6 agent7 agent8 agent9 agent10###
agent1.channels = mem-channel1 mem-channel2 mem-channel3 mem-channel4 mem-channel5 mem-channel6 mem-channel7 mem-channel8 mem-channel9 mem-channel10
agent1.sources = avro-source1 avro-source2 avro-source3 avro-source4 avro-source5 avro-source6 avro-source7 avro-source8 avro-source9 avro-source10
agent1.sinks =  hdfs-sink1 hdfs-sink2 hdfs-sink3 hdfs-sink4 hdfs-sink5 hdfs-sink6 hdfs-sink7 hdfs-sink8 hdfs-sink9 hdfs-sink10" >>$h
