#!/bin/bash
APPNAME="Minecraft"
IPFILE=/usr/local/remixed-v4.txt
UFW_RULE_PREFIX="Allow Remixed Access to Minecraft Server"

# Download the list of IPs from the website
wget https://vps1.ny.remixed.pro/v4 -O "$IPFILE"

# Function to validate CIDR notation
is_valid_cidr() {
  local cidr="$1"
  local ip
  local mask
  IFS="/" read -r ip mask <<< "$cidr"
  if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && [[ $mask =~ ^[0-9]+$ ]] && ((mask >= 0 && mask <= 32)); then
    return 0  # CIDR is valid
  else
    return 1  # CIDR is invalid
  fi
}

# Loop through the IPs in the file and validate them
while read -r IP; do
  # Trim leading and trailing whitespace
  IP=$(echo "$IP" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  # Check if the line is empty or starts with a comment character (#)
  if [[ -z $IP || $IP =~ ^# ]]; then
    continue
  fi

  if is_valid_cidr "$IP"; then
    if ! ufw status | grep -q "$UFW_RULE_PREFIX" | grep -q "$IP"; then
      # IP is not in the current list, add it to UFW
      ufw allow from "$IP" to any app "$APPNAME" comment "$UFW_RULE_PREFIX"
    fi
  else
    echo "Invalid CIDR notation: $IP"
  fi
done < "$IPFILE"

# Remove IPs from UFW that are no longer in the list
ufw status | grep -o "$UFW_RULE_PREFIX from [0-9./]\+" | awk '{print $3}' | sort | uniq | while read -r IP; do
  if ! grep -q "$IP" "$IPFILE"; then
    ufw delete allow from "$IP" to any app "$APPNAME" comment "$UFW_RULE_PREFIX"
  fi
done
