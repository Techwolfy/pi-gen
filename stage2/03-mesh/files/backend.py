#!/usr/bin/python

#Settings
MULTICAST_GROUP='ff02::42'
MULTICAST_IFACE='mesh0'
MULTICAST_PORT=4242
DATADIR='/var/lib/mesh'

#Libraries
import socket;
import struct;
import errno;
import os;
import time;
import json;
import RPi.GPIO as gpio;

import ctypes, ctypes.util;
libc = ctypes.CDLL(ctypes.util.find_library('c'));

#Convert interface name to usable index
def if_nametoindex(name):
	return libc.if_nametoindex(name);

#Connect to multicast group
def connect(group, interface, port):
	#Create a socket
	s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM);

	#Bind it to the port
	s.bind(('', port));

	iface = if_nametoindex(interface);
	s.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_MULTICAST_IF, struct.pack("I", iface));

	#Join multicast group
	sa = socket.inet_pton(socket.AF_INET6, group) + struct.pack("I", iface);
	s.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_JOIN_GROUP, sa);

	#Set socket as nonblocking
	s.setblocking(False);

	#Return created socket and multicast address
	return s, (group, port, 0, iface);

#Send data to multicast group
def broadcast(s, baddr, data):
	s.sendto(data + '\0', baddr);

#Recieve data from multicast group
def receive(s):
	while(True):
		try:
			data, sender = s.recvfrom(1024);
			saveData(sender[0], data);
		except socket.timeout:
			break;
		except socket.error, e:
			if(e.args[0] == errno.EAGAIN or e.args[0] == errno.EWOULDBLOCK):
				break;

#Remove old files from data directory
def clearData():
	for f in os.listdir(DATADIR):
		os.remove(DATADIR + '/' + f);

#Save incoming data to data directory
def saveData(node, data):
	with open(DATADIR + '/' + node, 'w') as f:
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
		state.append(gpio.input(pin));
	return state;

#Python entry point
def main():
	initGPIO();
	sock, baddr = connect(MULTICAST_GROUP, MULTICAST_IFACE, MULTICAST_PORT);
	clearData();
	while(True):
		gpioData = readGPIO();
		nodeData = {'time':long(time.time()), 'gpio':gpioData};
		broadcast(sock, baddr, json.dumps(nodeData));
		receive(sock);
		time.sleep(0.5);

#Script entry point
if __name__ == '__main__':
	main();
