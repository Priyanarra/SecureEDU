#!/bin/bash

# Path to monitor log file
LOG_FILE="/var/webserver_monitor/unauthorized.log"

# Email address of the admin
ADMIN_EMAIL="HN1009672@wcupa.edu"

# Temporary file to store last read position
LAST_READ="/tmp/last_read_position"

# Check if last read position file exists, if not create it
if [ ! -f "$LAST_READ" ]; then
    echo 0 > "$LAST_READ"
fi

# Get the last read position
last_position=$(cat "$LAST_READ")

# Check if the log file has new content since last read
new_content=$(tail -n +$((last_position + 1)) "$LOG_FILE")

if [ -n "$new_content" ]; then
    # Send email with new entries
    echo -e "Subject: Unauthorized SSH Access Detected\n\n$new_content" | /usr/sbin/sendmail "$ADMIN_EMAIL"

    # Update last read position
    echo $(($(wc -l < "$LOG_FILE"))) > "$LAST_READ"
else
    # No new entries, send notification
    echo -e "Subject: No Unauthorized Access Detected\n\nNo unauthorized access detected in $LOG_FILE" | /usr/sbin/sendmail "$ADMIN_EMAIL"
fi