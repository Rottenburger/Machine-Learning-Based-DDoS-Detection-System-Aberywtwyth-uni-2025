#!/usr/bin/python 

# Author: Thomas Roethenbaugh
# Date: 04/04/2025
# Version: 1.2
# The data features calculated in this program are based off of the 
# paper - FMDADM: A Multi-Layer DDoS Attack Detection
# and Mitigation Framework Using Machine
# Learning for Stateful SDN-Based IoT Networks
# all credit goes to the authors for their novel technique

import os
import csv
import math
import argparse

from datetime import datetime
from collections import defaultdict, Counter
import numpy as np
from scapy.all import rdpcap
from scapy.layers.inet import IP, TCP, UDP

# Packet window size
WINDOWSIZE = 32
# Packet time
WINDOWTIME = 0.1

"""
Calculates enthropy for pcap file's data, used to help when writing
the data features used by the paper FMDADM
"""
def entrophyCalculation(data):
    # default value
    if not data:
        print("ERROR no data found! setting to default")
        return 0.0

    # get item counts
    itemCounts = Counter(data)
    totalItems = len(data )

    entropy = 0.0 # defult
    for count in itemCounts.values():

        probability = count / totalItems

        if probability > 0:
            entropy -= probability * math.log2(probability)

    return entropy

def extractFlowId(packet):
    # handle if there is no packet
    if IP not in packet:
        print("ERROR! No packet found!")
        return None

    # extract data from packet
    src_ip = packet[IP].src
    dst_ip = packet[IP].dst 
    proto = packet[IP].proto
    sport, dport = None, None


    # 
    if TCP in packet:
        sport, dport = packet[TCP].sport, packet[TCP].dport

    elif UDP in packet:
        sport, dport = packet[UDP].sport,packet[UDP].dport

    # Sort IPs and ports for bidirectional flow ID
    sortedIps = tuple(sorted((src_ip, dst_ip)))
    sortedPorts = tuple(sorted((sport, dport))) if sport is not None else (None, None)

    return (sortedIps, sortedPorts, proto)

"""
Main function to handle calculating the data features from the pcap
file and coverting them into usefull data features
"""
def covertPcapIntoDataFeatures(pcapPath, csvPath, windowSize=WINDOWSIZE, monitoringIinterval=WINDOWTIME):
    # handle if no file
    if not os.path.exists(pcapPath):
        print("ERROR! No file found!")
        return

    print("------START------")

    try:
        rawPackets = rdpcap(pcapPath)
        print("successfuly found file! now begining data processing ")
    except Exception as e:
        print("ERROR! Could not process packets ")
        return

    allPacketsData = []
    processedFlowIds = set() # to track  new flows across the entire pcap

    # Initial Packet Parsing and Flow ID generation
    for i, pkt in enumerate(rawPackets):
        if IP not in pkt:
            continue # Skip non-IP packets

        flowId = extractFlowId(pkt)
        if flowId is None:
            continue

        isNewFlow = flowId not in processedFlowIds
        if isNewFlow:
            processedFlowIds.add(flowId)

        packetInfo = {
            'timestamp': float(pkt.time),
            'dst_ip': pkt[IP].dst,
            'size': len(pkt),
            'flowId': flowId,
            'isNewFlow': isNewFlow # Mark if this is the first packet seen for this flow globally
        }
        allPacketsData.append(packetInfo)

    if not allPacketsData:
        print("No valid IP packets found in the PCAP file")
        return

    # Sort packets chronologically
    allPacketsData.sort(key=lambda p: p['timestamp'])

    windowFeatures = []
    #  Process packets in windows
    for i in range(0, len(allPacketsData), windowSize):
        windowPackets = allPacketsData[i : i + windowSize]

        # Skip incomplete windows at the end
        if len(windowPackets) < windowSize:
            print("Skipping incomplete window!")
            continue

        #windowId = len(windowFeatures) # re-add this if timestamps are needed
        startTime = windowPackets[0]['timestamp']
        endTime = windowPackets[-1]['timestamp']
        # IMPORTANT! Avoid division by zero use monitoring interval if duration is  zero
        duration = max(endTime - startTime, 1e-9) # Use a tiny positive value instead of 0

        # --- Calculate the features for this window ---
        flowStatsInWindow = defaultdict(lambda: {'packetCount': 0, 'byteCount': 0})
        dstIpsInWindow = []
        newFlowsInWindowCount = 0

        # Aggregate stats within the window
        windowFlowIdsSeen = set() # Track new flows *within this window*

        for pkt in windowPackets:

            flowId = pkt['flowId']
            flowStatsInWindow[flowId]['packetCount'] += 1
            flowStatsInWindow[flowId]['byteCount'] += pkt['size']
            dstIpsInWindow.append(pkt['dst_ip'])
            # Count flows whose first packet (globally) appears in this window
            if pkt['isNewFlow'] and flowId not in windowFlowIdsSeen:

                 newFlowsInWindowCount += 1
                 windowFlowIdsSeen.add(flowId)


        """
        Each of these are the data features mentioned in the paper
        """

        # CPWE - Computed Particular Window Entropy
        cpwe = entrophyCalculation(dstIpsInWindow)

        # Prepare data for std dev calculations
        flowPacketCounts = [stats['packetCount'] for stats in flowStatsInWindow.values()]
        flowByteCounts = [stats['byteCount'] for stats in flowStatsInWindow.values()]

        # RFPSD - Received Flow Packets Standard Deviation
        rfpsd = np.std(flowPacketCounts) if len(flowPacketCounts) > 1 else 0.0

        # RFBSD - Received Flow Bytes Standard Deviation
        rfbsd = np.std(flowByteCounts) if len(flowByteCounts) > 1 else 0.0

        # CPRF - Computed Packet Rate Feature (Average rate across flows in window)

        # CPRF = FPCount / (T * MInt), averaged over flows. T = window duration.
        flowPacketRates = []

        if duration > 0 and monitoringIinterval > 0:

             denominator = duration * monitoringIinterval
             for stats in flowStatsInWindow.values():
                 rate = stats['packetCount'] / denominator
                 flowPacketRates.append(rate)

        cprf = np.mean(flowPacketRates) if flowPacketRates else 0.0


        # CFER - Computed Flow Entry Rate
        # FCount / MInt. FCount = number of new flows in this windo
        cfer = newFlowsInWindowCount / monitoringIinterval if monitoringIinterval > 0 else 0.0

        # Store the features for this window of packets
        windowFeatures.append({

            #'windowId': windowId,
            #'timestamp': startTime, # these are in the original dataset but have been removed
            #'datetime': datetime.fromtimestamp(startTime).strftime( '%Y-%m-%d %H:%M:%S.%f' ),

            'duration': duration if duration > 1e-9 else 0.0, # Report 0 if it was close to this number to avoid invalid data
            'flow_count': len(flowStatsInWindow),
            'CPWE': cpwe, 
            'CPRF': cprf,
            'RFPSD': rfpsd,
            'RFBSD': rfbsd ,
            'CFER': cfer
        })

    # Write features to CSV
    if not windowFeatures:
        print(" ERROR! No complete windows were processed and no CSV file was generated")
        return

    try:
        outputDir = os.path.dirname(csvPath)
        if outputDir and not os.path.exists(outputDir):
            os.makedirs(outputDir)
            print("SUCCESS! found directory!")

        fieldnames = [#'windowId', 'timestamp', 'datetime', # re-add if needed
                      'duration', 'flow_count',
                      'CPWE', 'CPRF', 'RFPSD', 'RFBSD', 'CFER']

        with open(csvPath, 'w', newline='') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(windowFeatures)

        print("SUCCESS! Created csv file!")
        print("------END------")

    except Exception as e:
        print("ERROR! had an issue when writing the csv file!")
        print("------END------")


"""
Main function 
"""
if __name__ == '__main__':
    
    parser = argparse.ArgumentParser(description="PCAP Feature Extractor for DDoS Detection")

    parser.add_argument("pcapFile", help="Path to the input PCAP file")
    parser.add_argument("csvFile", help="Path to the output CSV file")


    parser.add_argument("-w", "--windowSize", type=int, default=WINDOWSIZE,
                        help=f"Number of packets per window (default: {WINDOWSIZE})")

    parser.add_argument("-i", "--interval", type=float, default=WINDOWTIME,
                        help=f"Monitoring interval in seconds for rate calculations (default: {WINDOWTIME})")

    parser.add_argument("-q", "--quiet", action="store_true", help="Suppress informational messages")
    args = parser.parse_args()

    # write output to file!
    covertPcapIntoDataFeatures(args.pcapFile, args.csvFile, args.windowSize, args.interval)
