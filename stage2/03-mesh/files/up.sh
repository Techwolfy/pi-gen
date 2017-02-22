#!/bin/bash

#Connect to mesh network; script runs once at reboot
#https://github.com/o11s/open80211s/wiki/HOWTO
MESH_ID="meshnet"

iw dev wlan0 interface add mesh0 type mp
#ip link set dev mesh0 address $NEW_MAC_ADDR
ip link set up dev mesh0
iw dev mesh0 mesh join $MESH_ID
#iw dev mesh0 station dump

#TODO: Get/set IP addresses? IPv6 NDP?
