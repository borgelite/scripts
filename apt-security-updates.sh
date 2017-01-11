#!/bin/bash
#sudo nano /etc/cron.weekly/apt-security-updates
#sudo chmod +x /etc/cron.weekly/apt-security-updates
#und am besten in logrotate einbinden um die log datei klein zu halten
#nano /etc/logrotate.d/apt-security-updates
# Inhalt:
#/var/log/apt-security-updates {
#        rotate 2
#        weekly
#        size 250k
#        compress
#        notifempty
#}
#Rotiere Wöchentlich oder wenn datei grösser als 250kb komprimiere alte datei behalte nur 2 Dateien

SCRIPTDIR="/home/pi/scripts/"
INFO=$(cat /var/log/apt-security-updates | grep "Pakete aktualisiert" | tail -n1)

echo "**************" >> /var/log/apt-security-updates
/bin/date >> /var/log/apt-security-updates
/usr/bin/aptitude update >> /var/log/apt-security-updates
#aptitude safe-upgrade -o Aptitude::Delete-Unused=false --assume-yes --target-release `lsb_release -cs`-security >> /var/log/apt-security-updates
#aptitude safe-upgrade -o Aptitude::Delete-Unused=false --assume-yes >> /var/log/apt-security-updates || echo "Installation failed"
/usr/bin/aptitude safe-upgrade -o Aptitude::Delete-Unused=false --assume-yes >> /var/log/apt-security-updates
#echo "Security updates (if any) installed"
#SCRIPTPATH=$(dirname "$SCRIPT")
if [[ $? > 0 ]]
then
    echo "The command failed, exiting."
    $SCRIPTDIR./push.sh "Smarthome:aptitude update Fail" "check apt-security-update.sh on Smarthome Machine"
   # echo $SCRIPTPATH
    exit
else
    echo "The command ran succesfuly, continuing with script."
   $SCRIPTDIR./push.sh "Smarthome:aptitude Security updates" "Smarthome Machine UP to Date $INFO"
   #echo $SCRIPTPATH
fi
