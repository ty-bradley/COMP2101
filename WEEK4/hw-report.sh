#!/bin/bash

USER=$(whoami)
TIME=$(date +"%T")

echo
echo "-------------------------------------"
echo "Hardware summarry report for:" $USER
echo "-------------------------------------"
echo "Report generated at:" $TIME
echo "_____________________________________"
echo
# Show information about the current host including static hostname, machine ID, and operating system.
echo
echo "Show system information about current host:"
echo "_____________________________________"

sudo hostnamectl

# Show the time date information including local time, time zone, and system clock information.
echo
echo "Show time date information:"
echo "____________________________"
echo

sudo timedatectl

# lshw lists the hardware infromation on the hardware configuration of the machine.

# sudo lshw -short

# Used to examine or control the kernel ring buffer. By default it prints all messages from the kernel buffer.

#dmesg -H

# hwinfo probes the system for hardware present within the system. It can be used to generate a system overview log
echo
echo "Show summary of hardware present within system:"
echo "_________________________________________________"
echo

hwinfo --short

# hwinfo probes the system for hardware present within the system. It can be used to generate a system overview log

# lsblk

  # lsblk can specify information about the sda device only with "-d"
  # You can have lsblk print information in the output field of a specific device with -o
  # You can get information about which devices you can search for with --HELP

  # This command specifies in the output of the name of the device and model if available.

# lsblk -d -o NAME,MODEL

# lspci displays information about PCI buses in the system and the devices connected to them.
# By default, it will show a brief list of all devices.

# lspci -m
