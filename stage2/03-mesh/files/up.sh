#!/bin/bash

#Blink power LED
echo gpio > /sys/class/leds/led0/trigger
echo 1 > /sys/class/leds/led0/brightness
sleep 1;
echo 0 > /sys/class/leds/led0/brightness
sleep 1;
echo 1 > /sys/class/leds/led0/brightness
sleep 1;


#Connect to mesh network; script runs once at reboot
#https://github.com/o11s/open80211s/wiki/HOWTO
MESH_ID="MESHNET"

/sbin/ip link set down dev wlan0
/sbin/iw dev wlan0 interface add mesh0 type mp
#/sbin/ip link set dev mesh0 address $NEW_MAC_ADDR
/sbin/ip link set up dev mesh0
/sbin/iw dev mesh0 mesh join $MESH_ID
/sbin/iw dev mesh0 station dump > /home/pi/mesh_stations

#TODO: Get/set IP addresses? IPv6 NDP?


#Set power LED on
echo 0 > /sys/class/leds/led0/brightness
