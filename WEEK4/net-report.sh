#!/bin/bash

USER=$(whoami)
TIME=$(date +"%T")

echo
echo "-------------------------------------"
echo "Network summary report for:" $USER
echo "-------------------------------------"
echo "Report generated at:" $TIME
echo "_____________________________________"
echo

# lshw lists hardware information on the hardware configuration of the machine.
# lshw doesn't show all info unless ran with sudo or root. You can specify specific devices with -class or -C followed by the class of device you are searching for.

echo
echo "Display current system network information."
echo "____________________________________________"
echo

sudo lshw -short -C network

# lspci displays information about PCI buses in the system and the devices connected to them.
# By default, it will show a brief list of all devices.

# Using grep we can filter specific information from the lspci command, even finding network interface names.

# lspci displays information about PCI buses in the system and the devices connected to them.
# By default, it will show a brief list of all devices.
 # Using grep we can filter specific information from the lspci command, even finding network interface names.

echo
echo "Display current network PCI buses available within the system."
echo "_________________________________________________________________"
echo

lspci | grep -i vga

# You can use the 'ifconfig' and 'ip' command to idenify the LAN, IP address, subnet mask size and the name of the network interface used for your LAN.
# When running these commands look for eth0, enpXsY, where the X and Y numbers.
# Within details for the LAN interface, the entry for inet will be your LAN IP address, and the entry under 'inet' for the subnet mask size, typically written as '/XX'
echo
echo "Display current network configuration of system"
echo "________________________________________________"
echo

ifconfig
