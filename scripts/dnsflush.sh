#!/bin/bash

echo "Resetting DNS and network interfaces..."

# Flush DNS cache
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

# Get primary network service (usually Wi-Fi)
PRIMARY_SERVICE=$(networksetup -listallnetworkservices | grep -i "Wi-Fi" | head -n 1)

if [ -z "$PRIMARY_SERVICE" ]; then
  echo "Wi-Fi interface not found. Please update the script with your interface name."
  exit 1
fi

# Clear DNS servers for the primary interface
sudo networksetup -setdnsservers "$PRIMARY_SERVICE" empty

echo "DNS reset complete. If issues persist, try toggling your Wi-Fi or rebooting."
