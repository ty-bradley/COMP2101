#!/bin/bash

# Name: Ty Bradley
# Course: COMP2137 - Linux Automation
# Professor: Dennis Simpson
# Date: November 1st, 2023

# Network configuration must be static for the interface which does not connect to the internet and have the following persistent configuration using netplan. The interface which provides internet reachability must not be affected or altered. If there was a name in /etc/hosts for the existing address before your changes, then that entry in /etc/hosts should be updated to have the new address when your changes are made.
    # Address: 192.168.16.21/24
    # Gateway: 192.168.16.1
    # DNS Server :192.168.16.1
    # DNS search domains: home.arpa and localdomain


# Software installed must include the following.
    # open-ssh server allowing ssh key authentication and not allowing password authentication
    # apache2 web server listening for http on port 80 and https on port 443
    # squid web proxy on port 3128


# Firewall should be implemented and enabled using ufw with rules to allow the following services on their typical ports (any existing ufw configuration should not be altered).
    # ssh port 22
    # http port 80
    # https port 443
    # web proxy port 3128


# User accounts created with the following configuration.
    # all users have a home directory and bash as their default shell
    # all users have ssh keys for rsa and ed25519 algorithms, with both of their own public keys added to their authorized_keys file

# The account list must include the following:

    # dennis
        # this is the only user who should have sudo access
        # should allow access using ssh with the following public key as well as their generated public keys:
        # ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4rT3vTt99Ox5kndS4HmgTrKBT8SKzhK4rhGkEVGlCI student@generic-vm

    # aubrey
    # captain
    # snibbles
    # brownie
    # scooter
    # sandy
    # perrier
    # cindy
    # tiger
    # yoda


# Your script must run correctly without errors on a Ubuntu 22.04 server system.

# To submit this assignment, you will need 2 files. The script file which you have created and a PDF containing screenshots of your script running. To create the screenshots, you must do the following:


# Start a fresh terminal window on your VM. Run the following commands and screenshot the output:

# generic-vm% ~/makecontainers.sh --target server --count 1 --fresh
# generic-vm% scp assignment2.sh remoteadmin@server1:/root/
# generic-vm% ssh remoteadmin@server1
# server1# /root/assignment2.sh
# server1# /root/assignment2.sh



# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
LIGHTYELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
RESET='\033[0m' # Reset text formatting and color

# Usage: echo -e "${COLOR}Your colored text here${RESET}"
# echo -e "${RED}This is red text.${RESET}"
# echo -e "${GREEN}This is green text.${RESET}"
# echo -e "${YELLOW}This is yellow text.${RESET}"

echo -e "${RED}Hello!${RESET}"


ls /etc/netplan | sort | wc -l

DEFAULTROUTEINTERFACE=$(ip route | grep default | awk '{print $5}')

ALLINTERFACES=($(ls /sys/class/net/))

FREEINTERFACE=""
for INTERFACE in "${ALLINTERFACES[@]}"; do
    if [[ "$INTERFACE" != "$DEFAULTROUTEINTERFACE" ]]; then
        FREEINTERFACE="$INTERFACE"
        break
    fi
done

echo "Internet Interface: $FREEINTERFACE"

echo "Internet Interface:$DEFAULTROUTEINTERFACE


# while ! lxc exec "$container" -- systemctl is-active --quiet ssh 2>/dev/null; do sleep 1; done

#     lxc exec "$container" -- sh -c "cat > /etc/netplan/50-cloud-init.yaml <<EOF
# network:
#     version: 2
#     ethernets:
#         eth0:
#             addresses: [$containerlanip/24]
#             routes:
#               - to: default
#                 via: $lannetnum.2
#             nameservers:
#                 addresses: [$lannetnum.2]
#                 search: [home.arpa, localdomain]
#         eth1:
#             addresses: [$containermgmtip/24]
# EOF
