#!/bin/bash

APPNAME="Minecraft"
IPFILE=/usr/local/tcp-v4.txt

# Download the list of IPs from the website
wget https://tcpshield.com/v4 -O /usr/local/tcp-v4.txt

# Get the list of currently allowed IPs for your application
CURRENT_IPS=$(ufw status numbered | grep "$APPNAME" | awk -F"[][]" '{print $2}' | tr --delete [:blank:] | sort -rn)

# Create an array from the current IPs
IFS=$'\n' read -r -a CURRENT_IPS_ARRAY <<< "$CURRENT_IPS"

# Function to check if an IP is in the list
ip_in_list() {
  local ip_to_check="$1"
  for ip in "${CURRENT_IPS_ARRAY[@]}"; do
    if [[ "$ip" == "$ip_to_check" ]]; then
      return 0  # IP is in the list
    fi
  done
  return 1  # IP is not in the list
}

# Create arrays to track IPs to remove and add
IPS_TO_REMOVE=()
IPS_TO_ADD=()

# Loop through the IPs from the file and categorize them
while read -r IP; do
  if ! ip_in_list "$IP"; then
    IPS_TO_ADD+=("$IP")
  fi
done < "$IPFILE"

for current_ip in "${CURRENT_IPS_ARRAY[@]}"; do
  if ! grep -q "$current_ip" "$IPFILE"; then
    IPS_TO_REMOVE+=("$current_ip")
  fi
done

# Remove IPs that are no longer in the list
for IP in "${IPS_TO_REMOVE[@]}"; do
  ufw delete allow from "$IP" to any app "$APPNAME" comment 'Allow TCPShield Access to Minecraft Server'
done

# Add new IPs from the file
for IP in "${IPS_TO_ADD[@]}"; do
  ufw allow from "$IP" to any app "$APPNAME" comment 'Allow TCPShield Access to Minecraft Server'
done
