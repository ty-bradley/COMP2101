#!/bin/bash

# The purpose of this script is to show commands within the hardware, storage, and network categories that make modifications to the system, rather than just reporting on them.

# Get current user and store it within a variable. 'whoami' command prints the current user's username to the terminal.

USER=$(whoami)

# use 'date' command with the '+%T"' format specifier to format the current output in 24-hour format (HH:MM:SS)

TIME=$(date +"%T")

echo
echo "-------------------------------------------"
echo " System Modification Script ran by:" $USER
echo "-------------------------------------------"
echo
echo " Report generated at:" $TIME
echo "___________________________________________"
echo

# Commands for hardware modification:

# Important to remember that modifying settings usually requires running with sudo

# ----------------
# Storage Devices:
# ----------------

# Commands used to create, delete, or modify partitions on storage devices.
# __________________________________________________________________________

# 'fdisk' - manipulate disk partition table

# 'parted' - a partition manipulation program.

# Commands used to format storage partitions with specific file systems.
# ______________________________________________________________________

# (DEPRECATED) 'mkfs' - mkfs - build a Linux filesystem.

# 'mkfs.extX' -

# Commands used to mount and unmount filesystems.
# _______________________________________________

# 'mount' - mount a filesystem.

# 'umount' - unmount a filesystem.

# Commands used to modify hard disk drivie parameters, such as power management settings.
# _____________________________________________________________________________

# 'hdparm' - get/set SATA/IDE device parameters


# ------------------
# Network Interfaces
# ------------------

# Commands used to configure network interfaces, set IP addresses, and enable/disable interfaces, etc.

# 'ip' -

# 'ifconfig' -

# Commands used to configure ethernet adapter settings like speed and duplex mode.

# 'ethtool' -

# --------------------
# Graphics and display
# --------------------

# 'xrandr' - Used to configure display settings, resolution, and screen layout in X Window System.

# -----
# Sound
# -----

# 'alsamixer' - Used to configure sound card settings, volume levels, and audio controls for ALSA-based systems.

# -------------------
# CPU and Performance
# -------------------

# 'cpufreq-set' - Used to modify CPU frequency and govenor settings.

# 'taskset' - Used to set CPU affinity for processes.

# 'nice' and 'renice' - Used to adjust process priority and scheduling.

# -------------------
# Hardware Monitoring
# -------------------

# 'sensors' - Used to monitor hardware sensor readings like temperature and fan speed.

# ----------------
# Power Management
# ----------------

# 'systemctl' - used to configure system power settings, including sleep, hibernation, and power-saving modes.
