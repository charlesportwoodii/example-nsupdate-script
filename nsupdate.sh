#!/bin/bash
# This script fetches the current external IP Address, writes out an nsupdate file
# Then performs an nsupdate to our remote server of choice
# This script should be placed on a 10 minute crontab

WGET=$(which wget)
ECHO=$(which echo)
NSUPDATE=$(which nsupdate)

IP=$($WGET -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/
<.*$//')

$ECHO "server ns1.example.com" > /tmp/nsupdate
$ECHO "debug yes" >> /tmp/nsupdate
$ECHO "zone example.com." >> /tmp/nsupdate
$ECHO "update delete subdomain.example.com" >> /tmp/nsupdate
$ECHO "update add subdomain.example.com 60 A $IP" >> /tmp/nsupdate
$ECHO "send" >> /tmp/nsupdate

$NSUPDATE -k /var/lib/bindKexample.com.+127+24536.key -v /tmp/nsupdate 2>&1
