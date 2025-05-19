#!/bin/bash

# Author: Thomas Roethenbaugh
# Date: 13/03/2025


# Setup basic web service for testing on port 80
cd ~
mkdir webserver
cd webserver
echo "<h1>Hello!!!</h1>" > index.html
sudo python3 -m http.server 80 &

# access the web service

curl http://h1
# Or
wget -q -O - http://h1

# to run every 5 seconds over and over again
while : ; do curl http://10.0.0.1 ; sleep 5 ; done