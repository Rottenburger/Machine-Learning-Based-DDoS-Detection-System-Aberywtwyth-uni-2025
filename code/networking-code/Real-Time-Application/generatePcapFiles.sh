#!/bin/bash

# Author: Thomas Roethenbaugh
# Date: 2025-03-04
# Version: 0.2

# Network interface (e.g. eth0, wlan0)
INTERFACE="eth0"
# Capture for 60 seconds
DURATION=1
# Output file name
OUTPUT="capture.pcap"

# Run tshark with a duration limit and write to file
sudo tshark -i "$INTERFACE" -a duration:$DURATION -w "$OUTPUT"
echo "Capture complete. PCAP saved to $OUTPUT"
