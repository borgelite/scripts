#!/bin/bash
# a² - aquadraht@notmail.org 25.05.2005
# minimaler update - maba@freeshell.de 06.08.2015
# prüft erreichbarkeit und verschickt im fehlerfall eine mail
# syntax: checkhost.sh host recipient
# cronjob alle 15 min einrichten: */15 * * * * Befehl

#set -xv

TMPDIR=/tmp                                                                     
FILE=ping-alarm-$1                                                              
FLAG=$TMPDIR/$FILE
#DNS=$(host $1 | awk '{ print $5 }')
DNS=$(/usr/sbin/arp -a 192.168.0.54 | awk '{ print $1 }')

# check, ob FLAG älter als 12h
if [ -f $FLAG ]
then
        find $TMPDIR -name $FILE -mmin +720 -exec rm -f {} \;
fi


if [ ! -f $FLAG ]
then
        ping -c 1 "$1" > /dev/null 2>&1
else
        ping -c 1 "$1" > /dev/null 2>&1
        if [ "$?" = "0" ]
        then
        #cat << EOF | mailx -s "UFF! $1 is UP again!!" $2 $1 is up!!!! `date`
	cat << EOF | /home/pi/push.sh "UFF! $1 is UP again!!" "$2 $1 is up!!!! `date` $DNS" 1>/dev/null 2>/dev/null
EOF

        cd /tmp
        rm $FLAG
        fi

fi

# verschicke Mail, wenn Host nicht erreichbar
if [ "$?" != "0" ]
then
        #cat << EOF | mailx -s "AARGH! $1 is DOWN!!" $2 $1 is down!!!! `date`
	cat << EOF | /home/pi/push.sh "UFF! $1 is DOWN!!" "$2 $1 is down!!!! `date` $DNS " 1>/dev/null 2>/dev/null
EOF
echo $DNS
cd /tmp
touch $FLAG
fi
