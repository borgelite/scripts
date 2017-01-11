#!/bin/bash
API_KEY=''
#DEV_ID=''
TITLE="$1"
MSG="$2"
CHANNEL="$3"

#echo "push.sh <TITLE> <MSG>"
#curl https://api.pushbullet.com/v2/pushes \
#      -u $API_KEY: \
#      -d device_iden="$DEV_ID" \
#      -d type="note" \
#      -d title="$TITLE" \
#      -d body="$MSG" \
#      -X POST
# 1>/dev/null 2>/dev/null
echo "pushtoch.sh TITLE MSG CHANNEL"
#curl -u $API_KEY: -X GET https://api.pushbullet.com/v2/devices
#curl -u v1WevDuA2TPMImWjInVh6x7pOeLfr: -X GET https://api.pushbullet.com/v2/devices | tr "," "\n"
curl -k https://api.pushbullet.com/v2/pushes -X POST -u $API_KEY: \
--header "Content-Type: application/json" \
--data-binary "{\"type\": \"note\", \"title\":\"$TITLE\", \"body\": \"$MSG\", \"channel_tag\": \"$CHANNEL\"}" ;
