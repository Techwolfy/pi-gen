#!/bin/bash

#Blink power LED
echo gpio | sudo tee /sys/class/leds/led0/trigger
echo 1 | sudo tee /sys/class/leds/led0/brightness
sleep 1;
echo 0 | sudo tee /sys/class/leds/led0/brightness
sleep 1;
echo 1 | sudo tee /sys/class/leds/led0/brightness
sleep 1;


#Connect to mesh network; script runs once at reboot
#https://github.com/o11s/open80211s/wiki/HOWTO
MESH_ID="MESHNET"

ip link set down dev wlan0
iw dev wlan0 interface add mesh0 type mp
#ip link set dev mesh0 address $NEW_MAC_ADDR
ip link set up dev mesh0
iw dev mesh0 mesh join $MESH_ID
iw dev mesh0 station dump > /home/pi/mesh_stations

#TODO: Get/set IP addresses? IPv6 NDP?


#Set power LED on
echo 0 | sudo tee /sys/class/leds/led0/brightness
