#!/bin/bash

echo "./rss-creator.sh /media/filme"
dir="$1"
# Entferne alle Leerzeichen im Verzeichnis/Dateinamen
find $dir -depth -execdir rename 's/ /_/g' {} +

rsstitle="test"
rssdescription="Rss-Feed Filme"
rsscopyright="Erstellt von ..."
rssimgurl="test.jpg"
rssfile="$dir/vdr.rss"
link="http://borgelite.homedns.org:88"
#datum=$(date +"%d-%m-%Y")
datum=$(date -u -R | sed 's/\+0000/GMT/')
video=( $(find "$dir" -iname "*.mp4") )
#video=`find ./motion -iname "*.ogv"`


# Beispiel SongtitelFilter
#songtitle="$(id3v2 --list "$file" | grep "TIT2" | sed 's%TIT2.*:\s*%%')"
# Beispiel length filesize in Bytes
#filesize=$(stat -c %s "$file")
# Beispiel duration Abspiellänge
#fileduration=$(exiftool -S -Duration "$file" | sed 's/Duration: //' | sed 's/ (approx)//')
# To get the current date in a suitable format for the date fields:
#currdate=$(date -u -R | sed 's/\+0000/GMT/')

# Thumpnails erstellen
#find "$dir" -name '*.mp4' -exec sh -c 'ffmpeg -i "$0" -an -ss 00:10:00 -r 1 -vframes 1 -f mjpeg -y "${0%%.mp4}.mp4.jpg" ' {} \;
##find "$dir" -name '*.mp4' -exec sh -c 'ffmpeg -itsoffset -4 -i "$0" -vcodec png -vframes 1 -an -f rawvideo -s 120x90  -y "${0%%.mp4}.mp4.png" ' {} \;
#ffmpeg -itsoffset -4 -i "/media/usb0/filme/pso-inferno.int_web.sd.mp4" -vcodec png -vframes 1 -an -f rawvideo -s 120x90 -y "/media/usb0/filme/pso-inferno.int_web.sd.mp4.png"
#command = "ffmpeg -i $video -an -ss 00:00:30 -r 1 -vframes 1 -f mjpeg -y $output"
#for((i=0;i<${#video};i++)); do echo ${video[$i]};done
#echo $video
#echo $image

echo > $rssfile
cat <<EOF > $rssfile
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0">
  <channel>
    <title>$rsstitle</title>
    <link>$link$rssfile</link>
    <description>$rssdescription</description>
    <language>"de-de"</language>
    <copyright>$rsscopyright</copyright>
    <pubDate>$datum</pubDate>
    <image>
      <url>$rssimgurl</url>
      <title>Bildtitel</title>
      <link>$link$rssfile</link>
    </image>
EOF

for video in ${video[@]}; do
#echo "$video"
#filedate=$(date -r "$video" +%H-%m-%F)
filedate=$(date -R -r "$video" | sed 's/\+0000/GMT/' )
filesize=$(stat -c %s "$video")
echo $filedate
echo $filesize
#echo ${video##*/}
echo '    <item>'>>$rssfile
echo '      <title>'${video##*/}'</title>'>>$rssfile
echo '      <description><![CDATA[Filename: <br><a href="'$link$video'">'$link$video'</a><br><img src="'$link$video'.png" width="200" height="150"><br>]]></description> '>>$rssfile
echo '      <enclosure url="'$link$video'" length="'$filesize'" type="video/mpeg" />'>>$rssfile
echo '      <link>'$link$video'</link> '>>$rssfile
echo '      <author>Marcus</author> '>>$rssfile
echo '      <guid>'$link$video'</guid> '>>$rssfile
echo '      <pubDate>'$filedate'</pubDate> '>>$rssfile
echo '    </item> '>>$rssfile
done
echo '  </channel> '>>$rssfile
echo '</rss> ' >>$rssfile

echo "Erstellt: $rssfile"
