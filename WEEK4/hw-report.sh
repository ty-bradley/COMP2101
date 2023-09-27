#!/bin/bash

# Show information about the current host including static hostname, machine ID, and operating system.

sudo hostnamectl

# Show the time date information including local time, time zone, and system clock information.

sudo timedatectl

# lshw lists the hardware infromation on the hardware configuration of the machine.

# sudo lshw -short

# Used to examine or control the kernel ring buffer. By default it prints all messages from the kernel buffer.

#dmesg -H

hwinfo --short

#lsblk -d -o NAME,MODEL

#lspci -m
