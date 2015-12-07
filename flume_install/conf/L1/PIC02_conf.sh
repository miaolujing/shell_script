#！/bin/bash
ipaddr=`ifconfig eth0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "`
ipaddd=`ifconfig eth0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "|cut -f 1-2 -d "."`
BASE_HOME=/usr/local/miner/miner-1.0.2-bin/conf
h=PIC-02.conf
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
    echo "PIC-02 is exist"
     mv $h $h\.bak$today
fi

echo "## HANNEL mem-channel1 ##  
agent1.channels.mem-channel1.type = memory  
agent1.channels.mem-channel1.capacity = 1000000  
agent1.channels.mem-channel1.transactionCapacity = 200000  
agent1.channels.mem-channel1.keep-alive = 30  
  
## DEFINE SOURCE udp-source1 ##  
agent1.sources.udp-source1.type = com.yeexun.flume.source.SyslogUDPSource  
agent1.sources.udp-source1.channels = mem-channel1  
agent1.sources.udp-source1.host = $ipaddr  
agent1.sources.udp-source1.port = 65012  
agent1.sources.udp-source1.thread.size = 10  
agent1.sources.udp-source1.corethread.size = 8  
agent1.sources.udp-source1.queue.size = 1000000  

## DEFINE SINK avro-sink1 ##  
agent1.sinks.avro-sink1.type = com.yeexun.flume.sink.AvroSink  
agent1.sinks.avro-sink1.rollInterval = 120000  
agent1.sinks.avro-sink1.channel = mem-channel1  
agent1.sinks.avro-sink1.hostname = $collect1  
agent1.sinks.avro-sink1.port =  $pcollect_port1  
agent1.sinks.avro-sink1.batch-size = 1000  
  
## DEFINE SINK avro-sink1r ##  
agent1.sinks.avro-sink1r.type = com.yeexun.flume.sink.AvroSink  
agent1.sinks.avro-sink1r.rollInterval = 120000  
agent1.sinks.avro-sink1r.channel = mem-channel1  
agent1.sinks.avro-sink1r.hostname = $collect1r  
agent1.sinks.avro-sink1r.port =  $pcollect_port2  
agent1.sinks.avro-sink1r.batch-size = 1000  
  
## DEFINE SINK-GROUP group1 ##  
agent1.sinkgroups.group1.sinks = avro-sink1 avro-sink1r  
agent1.sinkgroups.group1.processor.type = failover  
agent1.sinkgroups.group1.processor.priority.avro-sink1 = 10  
agent1.sinkgroups.group1.processor.priority.avro-sink1r = 5  
agent1.sinkgroups.group1.processor.maxpenalty = 100000  
  
## DEFINE CHANNEL mem-channel2##  
agent1.channels.mem-channel2.type = memory  
agent1.channels.mem-channel2.capacity = 1000000  
agent1.channels.mem-channel2.transactionCapacity = 200000  
agent1.channels.mem-channel2.keep-alive = 30  
  
## DEFINE SOURCE udp-source2 ##  
agent1.sources.udp-source2.type = com.yeexun.flume.source.SyslogUDPSource  
agent1.sources.udp-source2.channels = mem-channel2  
agent1.sources.udp-source2.host = $ipaddr  
agent1.sources.udp-source2.port = 65015  
agent1.sources.udp-source2.thread.size = 10  
agent1.sources.udp-source2.corethread.size = 8  
agent1.sources.udp-source2.queue.size = 1000000  
  
## DEFINE SINK avro-sink2 ##  
agent1.sinks.avro-sink2.type = com.yeexun.flume.sink.AvroSink  
agent1.sinks.avro-sink2.rollInterval = 120000  
agent1.sinks.avro-sink2.channel = mem-channel2  
agent1.sinks.avro-sink2.hostname = $collect2  
agent1.sinks.avro-sink2.port = $pcollect_port1  
agent1.sinks.avro-sink2.batch-size = 1000  
  
## DEFINE SINK avro-sink2r ##  
agent1.sinks.avro-sink2r.type = com.yeexun.flume.sink.AvroSink  
agent1.sinks.avro-sink2r.rollInterval = 120000  
agent1.sinks.avro-sink2r.channel = mem-channel2  
agent1.sinks.avro-sink2r.hostname = $collect2r  
agent1.sinks.avro-sink2r.port = $pcollect_port2  
agent1.sinks.avro-sink2r.batch-size = 1000  
  
## DEFINE SINK-GROUP group2 ##  
agent1.sinkgroups.group2.sinks = avro-sink2 avro-sink2r  
agent1.sinkgroups.group2.processor.type = failover  
agent1.sinkgroups.group2.processor.priority.avro-sink2 = 10  
agent1.sinkgroups.group2.processor.priority.avro-sink2r = 5  
agent1.sinkgroups.group2.processor.maxpenalty = 100000  
  
### DEFINE AGENT agent1 ###  
agent1.channels = mem-channel1 mem-channel2  
agent1.sources = udp-source1 udp-source2  
agent1.sinks = avro-sink1 avro-sink2 avro-sink1r avro-sink2r  
agent1.sinkgroups = group1 group2" >> $h  
