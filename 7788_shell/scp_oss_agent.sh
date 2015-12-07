#!/usr/bin/expect -f
if {$argc<5} {
send_user "Usage: $argv0 \[IP\] \[PORT\] \[Passwd of ROOT User\] \[FILE1\] \[FILE2\]\n"
exit
}
set IP [lindex $argv 0]
set PORT [lindex $argv 1]
set Passwd [lindex $argv 2]
set FILE1 [lindex $argv 3]
set FILE2 [lindex $argv 4]
exec /bin/echo $IP
exec /bin/echo $PORT
exec /bin/echo $Passwd
exec /bin/echo $FILE1
exec /bin/echo $FILE2

set timeout 3
spawn scp -q -P $PORT $FILE1 $FILE2 root@$IP:/root/oss_auto
expect {
	"Are you sure you want to continue connecting*" { send "yes\r"; exp_continue }
	"*password:*" { send "$Passwd\r" }
}
expect eof
exec /bin/sleep 10

spawn ssh -p $PORT $IP -l root "/root/oss_auto/auto.sh"
expect {
	"*password:*" { send "$Passwd\r" }
}
expect eof
exec /bin/sleep 5
