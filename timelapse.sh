#!/bin/bash
#firt run wget http://admin:password@192.168.0.54/snapshot.jpg -O file.1.jpg
WebcamAdress='http://'
Dir='/media/usb0/timelapse'
	# Pruefe ob jpeg schon vorhanden
	#checkjpg=$(find . -name *.jpg | wc -l)
	#if [ $checkjpg -eq 0 ]; then
	#echo "kein bild vorhanden"
	#fi
cd $Dir
# find the last sequential file:
i=$(ls -t file.*.jpg | head -1 | awk -F. '{ print $2}')
# gefundener wert um eins erhöhen
((i++))
# get the file and save it
wget -O file.$i.jpg $WebcamAdress

#create video
#mencoder "mf://*.jpg" -mf fps=10 -o timelapse.mp4 -ovc x264

#crontab jeden tag Funf minuten nach jeder vollen Stunde zwischen 9 und 18 uhr (also 9:05,10:05,...18:05)
#5    9-18 * * *  /media/usb0/timelapse.sh 
