#!/bin/bash
WIHTELIST=whitelist.txt
# WIHTELIST list erstellen
# nmap -sP -R --dns-servers 192.168.0.1 192.168.0.0/24 | egrep -o '([[:xdigit:]]{2}[:-]){5}[[:xdigit:]]{2}' > whitelist.txt
nmap -sP -R --dns-servers 192.168.0.1 192.168.0.0/24 | egrep -o '([[:xdigit:]]{2}[:-]){5}[[:xdigit:]]{2}' > scan.txt
NEWLIST=scan.txt

# Einstellung für Pushbullet Dienst
API="" #add your api here
IDEN="" #add your iden here

#echo whitelist
#for a in `cat $WIHTELIST`; do
#echo $a;
#done

#echo Newlist
for b in `cat $NEWLIST`; do
	echo $b;
	if [ $(grep -c "^$b$" $WIHTELIST) -eq 0 ]; then
       	echo "neue Mac gefunden Speichere in done.txt"
       	nmap -sP 192.168.0.0/24 | grep -v "Host" | tail -n +3 | tr '\n' ' ' | sed 's|Nmap|\nNmap|g' | grep "MAC Address" | cut -d " " -f5,8-15 | grep "$b" > newmac.txt
NEWMAC=`cat newmac.txt` 	
curl -u $API: https://api.pushbullet.com/v2/pushes -d device_iden="$IDEN" -d type=note -d title="Network Alert" -d body="Neue Geräte im Netzwerk $NEWMAC" 1>/dev/null 2>/dev/null
	echo "$b" >> whitelist.txt;
	#else echo "alles gut keine änderung"
	fi
done

# Variablen in datei vergleichen
#if [ $(grep -c "^$SCAN$" $WIHTELIST) -eq 0 ]; then
#    	echo "neue Mac gefunden Speichere in done.txt"
#	echo "$SCAN" >> done.txt;
#fi

#Variablen Vergleichen
#if [ -eq $var1 $var2 ]; then
#echo "Die Dateien sind gleich."
#else
#echo "WARNUNG: Die Dateien sind NICHT gleich."
#fi

