#!/usr/bin/python 

# Author: Thomas Roethenbaugh
# Date: 14/03/2025
# Version: 0.6
# Description: This is the real-time DDoS dection script that will
# run in the backround while I perfom some DDoS tests 

import requests
import pickle
import time
import csv
import numpy as np

from mininet.topo import Topo
from mininet.net import Mininet
from mininet.util import dumpNodeConnections
from mininet.log import setLogLevel
from mininet.util import customClass
from mininet.link import TCLink

from mininet.node import RemoteController

# Include the sflow-rt python files 
execfile('sflow-rt/extras/sflow.py') 

# Rate limit links to 10Mbps
link = customClass({'tc':TCLink}, 'tc,bw=10')

# sFlow-RT endpoint
SFLOW_RT_URL = 'http://10.0.0.17:8008/flow/json'

# ONOS REST API endpoint
#ONOS_BASE_URL = 'http://10.0.0.17:8181/onos/v1/flows'
#ONOS_AUTH = ('onos', 'rocks')  # default ONOS credentials

# Path to the saved Random Forest model
MODEL_PATH = 'trainedModel.pkl'

# Threshold for triggering the mitigation
DDOS_LABEL = 1 

# Checking interval
CHECK_INTERVAL = 5

# Simple topology class
class SingleSwitchTopo(Topo):
    "Single switch connected to n hosts."
    def build(self, n=2):
        switch = self.addSwitch('s1')
        # Python's range(N) generates 0..N-1
        for h in range(n):
            host = self.addHost('h%s' % (h + 1))
            self.addLink(host, switch)

# Test iperf traffic
def simpleTest():

    "Create and test a simple network"
    topo = SingleSwitchTopo(n=4)
    net = Mininet(topo,link=link)
    net.start()
    print ("Dumping host connections")
    dumpNodeConnections(net.hosts)

    print ("Testing bandwidth between h1 and h4")
    h1, h4 = net.get( 'h1', 'h4' )
    net.iperf( (h1, h4) )
    net.stop()

    print ("Testing network connectivity")
    net.pingAll()
    net.stop()

# collect traffic data function
def collectTheTraffic():
    net.tcpdump((h1, h2))

    with open('trafficData.csv', 'rb') as dataFile:
        data = list(csv.reader(dataFile))


    np.savetxt('trafficData.csv', (col1_array, col2_array, col3_array), delimiter=',')
    

# determine if the traffic is ddos function
def checkIfDDoS():

    with open ('trainedModel.pkl', 'rb') as mlf:
        trainedMlModel = pickle.load(mlf)
    



def blockDDoSTraffic():
    net.link.stop(h1, h2) # stop link



if __name__ == '__main__':
    # Tell mininet to print useful information
    
    setLogLevel('info')
    #simpleTest()