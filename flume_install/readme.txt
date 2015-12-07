1、该工具分两个部分，一个部分是往下游服务器分发，路径为/opt/flume_install/send,一个部分是配置文件修改及组件版本,路径为/opt/flume_install/soft、conf
2、L1、L2节点分开
3、使用方法：以L1节点为例
   a、在/opt/flume_install/send/L1/L1_HOST.INFO文件中，添加需要分发的服务器的ip、port、密码
   b、执行/opt/flume_install/send/L1/L1_FILE.sh脚本
   c、日志查看在/opt/flume_install/send/L1/L1.log
4、注意：
   a、/opt/flume_install/send/L1/L1_FILE.et文件中，定义了需要分发的组件的路径，如果有变化，需要修改
   b、组件版本和配置文件模板均在/opt/flume_install/soft、conf中，如果有更新，在对应的目录下替换即可
   d、采集组件的端口规划在/opt/flume_install/conf/L1/COLLECT_PORT.INFO，配置文件port、ip等信息的替换都是读取该文件，如有变化，变更该文件即可
   
现网flume规划：
L1视频图片，在proxy机器部署，分PIC-01/PIC-02/VID-01/VID-02
L2视频图片，在中心两台collect部署，每台collect承担5台pic和5台vid
collect：一共六台，分001-006日志，做冗余

L1都是eth6网口
L2都是bond2网口
COLLECT是bond1网口