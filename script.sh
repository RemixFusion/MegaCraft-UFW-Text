#!/bin/bash

APPNAME="Minecraft"
IPFILE=/usr/local/tcp-v4.txt

wget https://tcpshield.com/v4 -O /usr/local/tcp-v4.txt

RULES_DESC=$(ufw status numbered | grep "$APPNAME" \
  | awk -F"[][]" '{print $2}' | tr --delete [:blank:] | sort -rn)
for NUM in $RULES_DESC; do
  yes | ufw delete $NUM
done

for IP in $(cat $IPFILE); do
  ufw allow from $IP to any app "$APPNAME"
done