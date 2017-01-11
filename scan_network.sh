#!/bin/bash
#Quelle: https://fredfire1.wordpress.com/2015/10/09/notify-new-onlineoffline-devices-in-network-raspberrypi/
#install nmap:
#sudo apt-get install nmap -y
# run it once a minute:
# crontab -e
# */1 * * * * /home/pi/scan_network.sh
#sudo nmap -sP -PR --dns-servers 192.168.0.1 192.168.0.0/24 | grep report | awk '{print $5,$6}' | sort > scan.txt

# Erster scan
# Mac+Gereatename 
#sudo nmap -sP -n 192.168.0.0/24 | grep MAC | awk '{print $3,$4,$5,$6,$7,$8,$9,$10,$11}' > whitelist.txt

API="" #add your api here
IDEN="" #add your iden here

#based on https://askubuntu.com/questions/398321/notification-when-someone-connects-to-my-local-network-arp-notification-file
#Script to monitor the network and put changes to notification
#Save previous scan

##cp scan.txt previousscan.txt
#cp scan.txt whitelist.txt

#get numeric list of online hosts
#nmap -n -sn 192.168.0.0-255 > scan.txt
#nmap -sP -PR --dns-servers 192.168.0.1 192.168.0.0/24 | grep report | awk '{print $5,$6}' > scan.txt
#sudo nmap -sP -n 192.168.0.0/24 | grep MAC | awk '{print $3,$4,$5,$6,$7,$8,$9,$10,$11}' > scan.txt
#sudo nmap -sP 192.168.0.0/24 | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{print " => "$3,$4,$5,$6,$7,$8,$9,$10;}' > scan.txt
# only mac
sudo nmap -sP -n 192.168.0.0/24 | grep MAC | awk {'print $3'} > scan.txt
WHITELIST=$(cat whitelist.txt)
#Mehrzeiler
#while read line
#do
#    echo $line
#done < whitelist.txt

#collect the difference, only the lines with ip-numbers
 ##message=$(diff previousscan.txt scan.txt | grep 192)
message=$(diff whitelist.txt scan.txt | grep ">")
#message=$(diff whitelist.txt scan.txt)

#Mehrzeiler
#while read line
#do
#    echo $line
#done < $message
#echo $message
#get first char which indicates if the host came up or went away
# iostring="${message:0:1}"
 iostring="${message}"

#get first ip-number from the list
#computer="${message:23:17}"
 computer="${message}"

if [ -n "$iostring" ]; then
#	echo "neue geräte gefunden."
curl -u $API: https://api.pushbullet.com/v2/pushes -d device_iden="$IDEN" -d type=note -d title="Network Alert" -d body="Neue Geräte im Netzwerk $computer" 1>/dev/null 2>/dev/null
	cp scan.txt whitelist.txt
	fi

#show ip-number in notify if host came up
# if [ "$iostring" = \> ]; then
#         echo "$computer online"
         #curl -u $API: https://api.pushbullet.com/v2/pushes -d device_iden="$IDEN" -d type=note -d title="Network Alert" -d body="$computer online"
#         fi
#show ip-number in notify if host went away
# if [ "$iostring" = \< ]; then
#         echo "$computer offline"
         #curl -u $API: https://api.pushbullet.com/v2/pushes -d device_iden="$IDEN" -d type=note -d title="Network Alert" -d body="$computer offline"
#         fi
