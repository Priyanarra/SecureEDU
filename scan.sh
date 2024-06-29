#!/bin/bash

# Path to log file to monitor
LOG_FILE="/var/log/auth.log"

# Path to NFS-mounted directory
NFS_MOUNT="/var/webserver_log"

# Grep command to filter unauthorized SSH access and extract IP addresses
UNAUTHORIZED_ATTEMPTS=$(grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" "$LOG_FILE" | sort | uniq)

# Loop through each unauthorized attempt
for IP_ADDRESS in $UNAUTHORIZED_ATTEMPTS; do
    # Use geoiplookup to find country (install geoip-bin package if not installed)
    COUNTRY=$(geoiplookup "$IP_ADDRESS" | awk -F ", " '{print $2}')
    
    # Current date
    DATE=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Format: IP_ADDRESS COUNTRY DATE
    echo "$IP_ADDRESS $COUNTRY $DATE" >> "$NFS_MOUNT/unauthorized.log"
done