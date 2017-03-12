#!/usr/bin/python

#Settings
MULTICAST_GROUP='ff15:7079:7468:6f6e:6465:6d6f:6d63:6173'	#TODO: Pick one?
MULTICAST_IFACE='mesh0'
MULTICAST_PORT=4242
DATADIR='/var/lib/mesh'

#Libraries
import socket;
import select;
import time;
import json;
import RPi.GPIO as gpio;

#Connect to multicast group
def connect(group, interface, port):
	#Get addrinfo struct
	addrinfo = socket.getaddrinfo(group + '%' + interface, port, socket.AF_INET6, socket.SOCK_DGRAM);
	af, socktype, proto, canonname, sa = addrinfo;

	#Create a socket
	s = socket.socket(af, socktype, proto);

	#Bind it to the port
	s.bind(sa);

	#Join multicast group
	s.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_JOIN_GROUP, socket.inet_pton(af, sa) + '\0'*4);

	#Set socket as nonblocking
	s.setblocking(False);

	#Return created socket and multicast address
	return s, sa;

#Send data to multicast group
def broadcast(s, sa, data):
	s.sendto(data + '\0', sa);

#Recieve data from multicast group
def receive(s):
	while True:
		try:
			data, sender = s.recvfrom(1024);
			saveData(sender, data);
		except socket.timeout:
			break;

#Remove old files from data directory
def clearData():
	for f in os.listdir(DATADIR):
		os.remove(f);

#Save incoming data to data directory
def saveData(node, data):
	with open(node, 'w') as f:
		f.write(data);

#Set up GPIO pins
def initGPIO():
	gpio.setmode(gpio.BCM);
	for pin in range(0, 26):
		gpio.setup(pin, gpio.IN);

#Read status of GPIO pins
def readGPIO():
	state = [];
	for pin in range(0, 26):
		state[pin] = gpio.input(pin);
	return state;

#Python entry point
def main():
	initGPIO();
	sock, sockaddr = connect(MULTICAST_GROUP, MULTICAST_IFACE, MULTICAST_PORT);
	while(true):
		gpioData = readGPIO();
		nodeData = {'time':long(time.time()), 'gpio':gpioData};
		broadcast(sock, sockaddr, json.dumps(nodeData));
		recieve(sock);
		time.sleep(0.25);

#Script entry point
if __name__ == '__main__':
	main();
