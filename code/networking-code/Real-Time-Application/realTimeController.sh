#!/bin/bash

# Author: Thomas Roethenbaugh
# Date: 04/04/2025
# Version: 1.4
# this was written based on the CollectE.sh file
# given to me by Muhammad


# run continusly
for i in {1..10}
do

# capture 32 packet chunk
sudo tcpdump -i s1-eth1 -c 40 -w packetChunk.pcap # set to 40 to hopefully avoid a bug

python3 dataApp.py packetChunk.pcap packetChunk.csv -w 32 -i 0.1 # process packets into data

echo $i # show iterations 

python3 trainedModel.py

# read the output to see if an attack
isThereAnAttack=$(awk '{print $0;}' isddos.txt)

if [ $isThereAnAttack -eq 1 ]; then
echo "There is DDoS traffic"

# block traffic from malicious ip address
sudo ovs-ofctl add-flow s2 ip,nw_dst=10.0.0.17,priority=50000,actions=drop

else

echo "There is no ddos traffic :D"

fi

sleep 3
done
