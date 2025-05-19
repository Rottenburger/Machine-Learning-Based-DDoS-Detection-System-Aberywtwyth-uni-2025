#!/bin/bash

# This script demonstrates how to start the given network topology with sflow-rt and mininet

# Author: Thomas Roethenbaugh
# Date: 26/02/2025
# version 1.0

cd /sflow-rt/

# Change depth and fanout to change the network topology
sudo mn --nat --custom extras/sflow.py --link tc,bw=10 --topo tree,depth=2,fanout=2

# topology 2
sudo mn --nat --custom extras/sflow.py --link tc,bw=10 --topo tree,depth=3,fanout=3

# sFlowRT topology
sudo mn --nat --custom extras/sflow.py --link tc,bw=10 --topo tree,depth=2,fanout=4