Used this video to help me understand - https://www.youtube.com/watch?v=bDAY-oUP0DQ&ab_channel=IBMTechnology

And this article - https://www.esecurityplanet.com/networks/types-of-ddos-attacks/

# Some notes:
# Types of DDoS attacks 🌐

### UDP Flood attacks

The User Datagram Protocol (UDP) does not establish a two-way session with a server. Instead, UDP simply sends data packets without waiting for a reply.

This characteristic provides the perfect setup for flood attacks that attempt to send enough packets to overwhelm a host that is listening to its ports for genuine UDP traffic. Attackers know that upon receiving a UDP packet at any port, the server must check for an application that corresponds to that port, and the protocols will trigger automatic processes within the server.

Attackers target servers on the internet or within a network specifically through the IP address and port embedded in the UDP packets. The attack seeks to overwhelm the server with that process request or consome the bandwidth of the network.

Specific UDP Flood Attacks can use:

- [Domain Name Service (DNS)](https://www.esecurityplanet.com/networks/how-to-secure-dns/)
- Network Time Protocol (NTP)
- Simple Service Discovery Protocol (SSDP)
- Media data such as audio or video packets
- Voice over IP (VoIP) telephone packets
- NetBIOS
- Peer-to-peer (P2P) networks like BitTorrent or Kad packets
- Simple Network Management Protocol (SNMP)
- Quote of the day (QOTD)
- Video game specific protocols like Quake and Steam

Variants of the UDP Flood attack include:

- **UDP Fragmentation Flood:** This variation of the UDP Flood attack sends larger, but fragmented packets to the victim server. The server will attempt to assemble the unrelated, forged, and fragmented UDP packets and may become overwhelmed in the process.
- **Specific UDP Amplification Attacks:** Instead of using a large number of compromised devices, attackers can send a legitimate UDP request to a large number of legitimate servers with the victim server as a spoofed IP address. The responses from these legitimate servers suddenly overwhelms the targeted device. Protocols often used in amplification attacks include: NTP, SNMP, and SSDP

### Protocol DDoS Attacks

Instead of strictly using sheer volume, protocol DDoS attacks abuse protocols to overwhelm a specific resource, usually a server but sometimes firewalls or load balancers. These attacks will often be measured in packets per second.

### IP Null attack

All packets conforming to Internet Protocol version 4 contain headers that should specify if the transport protocol used for that packet is TCP, ICMP, etc. However, attackers can set the header to a null value, and without specific instructions to discard those packets, the server will consume resources attempting to determine how to deliver those packets.

### TCP Flood attacks

The Transmission Control Protocol (TCP) regulates how different devices communicate through a network. Various TCP flood attacks abuse the basic TCP protocol to overwhelm resources through spoofing or malformed packets.

To understand the different attacks, it is helpful to understand how TCP works. The Transmission Control Protocol requires three communication sequences to establish a connection:

- **SYN:** The requesting device (endpoint or server) sends a synchronized sequence number in a packet to a server or other destination device (endpoint).
- **SYN-ACK:** The server responds to the SYN packet with a response consisting of the synchronized sequence number plus an acknowledgement number (ACK).
- **ACK:** The requesting device sends a response acknowledgement number (original ACK number + 1) back to the server.

Transmission is ended through a four-part termination sequence consisting of:

- **FIN:** The requesting device sends a session termination request (FIN) to the server.
- **ACK:** The server responds with an ACK response to the requesting device, and the requesting device will wait to receive the FIN packet.
- **FIN:** The server responds with a FIN packet (may be nearly simultaneous) to the requesting device.
- **ACK:** The requesting device returns a final ACK response to the server, and the session is closed.

When servers receive an unexpected TCP packet, the server will send a RST (reset) packet back to reset the communication.

Flood attacks abusing the TCP protocol attempt to use malformed TCP transmissions to overwhelm system resources.

- **SYN Flood:** The attacker sends many SYN request packets either from a spoofed IP address or from a server set up to ignore responses. The victim server responds with SYN-ACK packets and holds open the communication bandwidth waiting for the ACK response.
- **SYN-ACK Flood:** Attackers send a large number of spoofed SYN-ACK responses to the victim server. The targeted server will tie up resources attempting to match the responses to non-existent SYN requests.
- **ACK Flood:** Attackers send a large number of spoofed ACK responses to a server, which will tie up resources attempting to match the ACK response with non-existent SYN-ACK packets. The TCP PUSH function can also be used for this type of attack.
- **ACK Fragmentation Flood:** A variation of the ACK Flood attack, this method uses fragmented packets of the maximum size of 1,500 bytes to abuse the maximum IP packet length of 65,535 bytes (including the header). When servers and other resources such as routers attempt to reconstruct the fragmented packets, the reconstruction exceeds the allocated resources and can cause memory overflow errors or crash the resource.
- **RST/FIN Flood:** Attackers use spoofed RST or FIN packets to flood servers and consume resources with attempts to match the packets to non-existent open TCP sessions.
- **Multiple ACK Spoofed Session Flood:** In this variation attackers send multiple ACK packets followed by RST or FIN packets to more thoroughly mimic actual TCP traffic and fool defenses. Of course, the packets are spoofed, and the server will consume its resources trying to match the fake packets with non-existent open TCP sessions.
- **Multiple SYN-ACK Spoofed Session Flood:** This variation uses multiple SYN and ACK packets also followed by RST or FIN packets. As with the Multiple ACK Spoofed Session Flood, the spoofed packets attempt to mimic legitimate TCP traffic and waste server resources with attempts to match fake packets to legitimate traffic.
- **Synonymous IP Attack:** To execute this method, attackers spoof SYN packets that use the victim server’s IP address for both the source and destination IP address of the packet. The nonsense packet then consumes resources as the server attempts to either respond to itself (AKA: local area network denial, or LAND, attack) or resolve the contradiction of receiving a packet from itself related to open communication with itself for TCP sessions that it cannot match.