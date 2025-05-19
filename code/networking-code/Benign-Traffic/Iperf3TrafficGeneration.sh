#!/bin/bash

# Author: Thomas Roethenbaugh
# Date: 26/02/2025

# This script is used to create traffic between two hosts on mininet,
# it will use iperf to simulate benign or safe trafic that can be used to
# train the model

# Create a random number of hosts to connect to each other
host1=10.0.0.$(($RANDOM%(10-1+1)+1))
host2=10.0.0.$(($RANDOM%(10-1+1)+1))
host3=10.0.0.$(($RANDOM%(10-1+1)+1))
host4=10.0.0.$(($RANDOM%(10-1+1)+1))
host5=10.0.0.$(($RANDOM%(10-1+1)+1))
host6=10.0.0.$(($RANDOM%(10-1+1)+1))
host7=10.0.0.$(($RANDOM%(10-1+1)+1))
host8=10.0.0.$(($RANDOM%(10-1+1)+1))

# On h1 to open a listening port
iperf3 -s

# On h2 to connect to h1
iperf3 -c $host1 # h1


# genrating UDP traffic
iperf3 -s # on h1
iperf3 -u -c $host1 # on h2

iperf3 -c $host1 -t 60 # h2

iperf3 -c $host1 -P 5

iperf3 --bidir -c $host1

# To run in the back round for an hour
iperf3 -u -b 5M -t 3600 -c $host1 -D 