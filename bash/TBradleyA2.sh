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



# Define color variables to be used for formatting.
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



# Enstantiating variable names for script begins here
#-----------------------------------------------------

# Assigns the current username to the 'USERNAME' variable.
USERNAME=$(whoami)

# Saves the current date in this format: Day of the week, Month, Day, Year.
CURRENTDATE=$(echo "$(date +%A), $(date +%B) $(date +%d), $(date +%+4Y)")

# Saves the current time in this format: Hour:Minute:Second AM/PM.
CURRENTTIME=$(echo "$(date +%I):$(date +%M):$(date +%S) $(date +%p)")

# Defines the static IP address for a specific interface.
STATICINTERFACEIP="192.168.16.21/24"

# Retrieves the default route interface from the routing table.
DEFAULTROUTEINTERFACE=$(ip route | grep default | awk '{print $5}')

# Lists all network interfaces on the system.
ALLINTERFACES=($(ls /sys/class/net/))

# Stores the name of the interface that is not the default route.
FREEINTERFACE=""

# Retrieves the hostname associated with the static IP from /etc/hosts.
STATICHOSTNAME=$(grep "$STATICINTERFACEIP" /etc/hosts | awk '{print $2}')

# Takes output from ufw commands and stores them. Used to format for user readability.
UFWMESSAGE=""

# # User configuration: List of usernames for account creation.
USERNAMES=("dennis" "aubrey" "captain" "snibbles" "brownie" "scooter" "sandy" "perrier" "cindy" "tiger" "yoda")


# Enstantiating variable names for script ends here
#-----------------------------------------------------

#Begin script template for user

echo -e "
---------------------------------------------

    ${RED}System Modification Script${RESET}

---------------------------------------------

${YELLOW}Report Generation Information${RESET}

----------------------------------
${YELLOW}User${RESET}: $USERNAME
----------------------------------
${YELLOW}Date${RESET}: $CURRENTDATE
----------------------------------
${YELLOW}Time${RESET}: $CURRENTTIME
----------------------------------
"

## SECTION 1: INTERNET INTERFACES AND NETPLAN.

echo -e "
------------------------------------

${CYAN}NETWORK CONFIGURATION${RESET}

------------------------------------"

# Finds an interface that is not used as the default route, when it finds one it exits the loop.
# When this runs unless there are no interfaces and just the loopback interface, it should always find an interface to use that isn't the default route interface.
for INTERFACE in "${ALLINTERFACES[@]}"; do
    if [[ "$INTERFACE" != "$DEFAULTROUTEINTERFACE" ]]; then
        FREEINTERFACE="$INTERFACE"
        break
    fi
done

# Displays the interface chosen for the static configuration.
echo -e "
${GREEN}Configured Interface:${RESET} $FREEINTERFACE"

# Check if the entry associated with FREEINTERFACE is already commented out in netplan configuration.
for NETPLANFILE in /etc/netplan/*.yaml; do
    if ! grep -q "^#" "$NETPLANFILE"; then
        # Dear Dennis,
        # This took some time to get working but what I have here seems to work, I tried using sed to comment out entries starting from the specified interface (which is eth1),
        # Then from there it will add a hastag to the beginning of each line after until it finds a line with an indent (or whitespace), and after that indent starts with an e.
        # I figured that the interface we should use would be eth or ens and no other entry within netplan starts with e between my specifications.
        # To get it to function like intended I have to specify to specifically comment out lines that start with the interface (which is why it comments twice, without this it doesn't seem to work at all weirdly enough.)
        # I also have to specify that I specifically don't want to comment on the line where it finds the indent with the e after it.
        # I think I over complicated but my solution seems to work as intended.
        sed -i "/$FREEINTERFACE/, /^\s*e/ {/$FREEINTERFACE/ s/^/#/; /^\s*e/! s/^/#/}" "$NETPLANFILE"
    fi
done

# After commenting out information about the interface in other netplan files, we go about creating a Netplan configuration file for static IP
cat > /etc/netplan/01-static-int.yaml <<EOF
network:
    version: 2
    ethernets:
        $FREEINTERFACE:
            addresses: [192.168.16.21/24]
            routes:
                via: 192.168.16.1
            nameservers:
                addresses: [192.168.16.1]
                search: [home.arpa, localdomain]
EOF

# Displaying a message about the created Netplan file and showing the name and file location for the user to inspect.
echo -e "
${GREEN}Created Netplan file for static configuration:${RESET} /etc/netplan/01-static-int.yaml"

# Check if an entry exists in /etc/hosts for the static interface's IP.
if grep -q "$STATICINTERFACEIP" /etc/hosts; then
    
    # If the entry exists within, we update it and give it a new host name.
    
    sed -i "s/^\(192.168.16.21\s\+\).*$/\1generic-host/" /etc/hosts
    
    ETCHOSTSENTRY=$(cat /etc/hosts | grep $STATICINTERFACEIP)
    
    echo -e "
${GREEN}Updated entry to /etc/hosts:${RESET} $ETCHOSTSENTRY"
else
    
    # Entry doesn't exist, add it to the file with a host name.
    echo "$STATICINTERFACEIP generic-host" >> /etc/hosts
    
    ETCHOSTSENTRY=$(cat /etc/hosts | grep $STATICINTERFACEIP)
    
    echo -e "
${GREEN}Added entry to /etc/hosts:${RESET} $ETCHOSTSENTRY"
fi


# Set the hostname to static-interface in /etc/hostname
echo "generic-host" > /etc/hostname

# Update the current hostname
hostnamectl set-hostname generic-host

# Display the updated hostname
echo -e "
${GREEN}Updated hostname to:${RESET} generic-host"

## SECTION 2: INSTALLING SOFTWARE

echo -e "
------------------------------------

${CYAN}SOFTWARE CONFIGURATION${RESET}

------------------------------------"

# Check if openssh-server service is running
if ! service ssh status &> /dev/null; then
    echo -e "
${RED}OpenSSH-server service not found; Installing.${RESET}"
    sudo apt install -y openssh-server &> /dev/null
else
 # If OpenSSH server service is already running, display that message to the user.
    echo -e "
${BLUE}OpenSSH server service already installed; Restarting..${RESET}"
fi

# Configure OpenSSH for key-based authentication and disable password authentication, then restart the service.
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart ssh &> /dev/null

# Check if Apache2 web server service is running
if ! service apache2 status &> /dev/null; then
    echo -e "
${RED}Apache2 web server service not found; Installing.${RESET}"
    sudo apt install -y apache2 &> /dev/null
else
 # If Apache2 web server service is already running, display that message to the user.
    echo -e "
${BLUE}Apache2 web server service already installed; Restarting..${RESET}"
fi

# Check if Squid web proxy service is running
if ! service squid status &> /dev/null; then
    echo -e "
${RED}Squid web proxy service not found; Installing.${RESET}"
    sudo apt install -y squid &> /dev/null
else
 # If Squid web proxy service is already running, display that message to the user.
    echo -e "
${BLUE}Squid web proxy service already installed; Restarting.. ${RESET}"
fi

# Configure Squid to listen on port 3128, then restart the service.
sudo sed -i 's/http_port 3128/http_port 3128/' /etc/squid/squid.conf &> /dev/null
sudo systemctl restart squid &> /dev/null


## SECTION 3: FIREWALL RULES AND PORTS

echo -e "
------------------------------------

${CYAN}FIREWALL CONFIGURATION${RESET}

------------------------------------
"

# Enable UFW (Uncomplicated Firewall) and if already running display a message for the user.

UFWMESSAGE=$(sudo ufw --force enable)
echo -e "
${GREEN}Enabling UFW (Uncomplicated Firewall):${RESET} $UFWMESSAGE"

# Allow SSH on port 22: Displays a message if the rule is already active.

UFWMESSAGE=$(sudo ufw allow 22/tcp)
echo -e "
${GREEN}Enabling UFW (Uncomplicated Firewall):${RESET} $UFWMESSAGE"

# Allow HTTP on port 80: Displays a message if the rule is already active.

UFWMESSAGE=$(sudo ufw allow 80/tcp)
echo -e "
${GREEN}Enabling UFW (Uncomplicated Firewall):${RESET} $UFWMESSAGE"

# Allow HTTPS on port 443: Displays a message if the rule is already active.

UFWMESSAGE=$(sudo ufw allow 443/tcp)
echo -e "
${GREEN}Enabling UFW (Uncomplicated Firewall):${RESET} $UFWMESSAGE"

# Allow web proxy on port 3128: Displays a message if the rule is already active.

UFWMESSAGE=$(sudo ufw allow 3128/tcp)
echo -e "
${GREEN}Enabling UFW (Uncomplicated Firewall):${RESET} $UFWMESSAGE"

## SECTION 4: USER ACCOUNTS AND SSH SETUP

echo -e "
------------------------------------

${CYAN}USER CONFIGURATION${RESET}

------------------------------------
"

# Creates users with home directory and bash as default shell

for USERNAME in "${USERNAMES[@]}"; do
    if id "$USERNAME" &>/dev/null; then
        echo -e "
${YELLOW}User already exists:${RESET} $USERNAME"
    else
        sudo useradd -m -s /bin/bash "$USERNAME" > /dev/null 2>&1
        echo -e "${GREEN}Creating user:${RESET} $USERNAME"
    fi
done

# SSH key configuration

for USERNAME in "${USERNAMES[@]}"; do
    
    # Generate SSH keys (RSA and Ed25519)
    
    echo -e "
${GREEN}Generating SSH key:${RESET}"
    echo -e "y\n" | sudo -u "$USERNAME" ssh-keygen -t rsa -b 2048 -f "/home/$USERNAME/.ssh/id_rsa" -N "" > /dev/null
    echo -e "y\n" | sudo -u "$USERNAME" ssh-keygen -t ed25519 -f "/home/$USERNAME/.ssh/id_ed25519" -N "" > /dev/null

# Check if the SSH key directory exists
if [ -d "/home/$USERNAME/.ssh" ]; then
    # Check if the SSH key files already exist and print a message
    if [ -f "/home/$USERNAME/.ssh/id_rsa" ] || [ -f "/home/$USERNAME/.ssh/id_ed25519" ]; then
        echo -e "${YELLOW}SSH keys already exist for:${RESET} $USERNAME. ${RED}Overwriting...${RESET}"
    fi
else
    # This is the first time keys are being generated
    echo -e "${GREEN}Generating SSH keys for:${RESET} $USERNAME"
fi

    # Add the provided public key and grant sudo access to dennis by appending to authorized_keys.
    
    if [ "$USERNAME" == "dennis" ] && ! grep -q "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4rT3vTt99Ox5kndS4HmgTrKBT8SKzhK4rhGkEVGlCI student@generic-vm" "/home/dennis/.ssh/authorized_keys"; then
    sudo usermod -aG sudo dennis
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4rT3vTt99Ox5kndS4HmgTrKBT8SKzhK4rhGkEVGlCI student@generic-vm" | sudo -u dennis tee -a "/home/dennis/.ssh/authorized_keys" > /dev/null
fi
    
    # Add the generated public keys to authorized_keys
    
    cat "/home/$USERNAME/.ssh/id_rsa.pub" >> "/home/$USERNAME/.ssh/authorized_keys"
    cat "/home/$USERNAME/.ssh/id_ed25519.pub" >> "/home/$USERNAME/.ssh/authorized_keys"

    # Set permissions for the .ssh directory and authorized_keys file.
    
    chmod 700 "/home/$USERNAME/.ssh"
    chmod 600 "/home/$USERNAME/.ssh/authorized_keys"

    # Set ownership for the user so that they may have access to the key folders.
    
    chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.ssh"
done