#!/bin/bash

APPNAME="BungeeCord"
IPFILE=/usr/local/v4.txt

RULES_DESC=$(ufw status numbered | grep "$APPNAME" \
  | awk -F"[][]" '{print $2}' | tr --delete [:blank:] | sort -rn)
for NUM in $RULES_DESC; do
  yes | ufw delete $NUM
done

for IP in $(cat $IPFILE); do
  ufw route allow from $IP to any app "$APPNAME"
done