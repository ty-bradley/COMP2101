# #!/bin/bash

# # Name: Ty Bradley
# # Course: COMP2137 - Linux Automation
# # Professor: Dennis Simpson
# # Date: November 22nd, 2023

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

#
# Begin Assignment 3 summary
#-----------------------------------------------------
#

# In this assignment, you will be modifying multiple systems remotely. In order to keep lab machine requirements to a minimum, we will be simulating remote machines using containers running inside of our existing VM. Be sure to delete any existing server1 container left over from the previous lab before starting this one using:

## lxc delete server1 --force

# Use the makecontainers.sh script to create the necessary containers before working on your script. Run it as

## makecontainers.sh --count 2 --fresh --target target

# for this lab. You will need 6GB of free space minimum in your existing VM in order to run this successfully. When it finishes, you will have a virtual network with 2 virtual server systems on it to remotely administer. The default it will create looks like the diagram in the presentation, with the router named openwrt. The script will print a summary of hosts and IP addresses when it runs. You can rerun it to remake the containers at any time using the same command.

# Create a script to run on your desktop Linux VM, which we will call the NMS. The script should perform the following tasks using ssh to the mgmt-net addresses of each of the target machines (e.g. ssh remoteadmin@target1-mgmt somecommand):

# target1-mgmt (172.16.1.10):

    # change system name from target1 to loghost (change both hostname and /etc/hosts files)
    # change ip address from host 10 to host 3 on the lan
    # Add a machine named webhost to the /etc/hosts file as host 4 on the lan
    # install ufw if necessary and allow connections to port 514/udp from the mgmt network
    # configure rsyslog to listen for UDP connections (look in /etc/rsyslog.conf for the configuration settings lines that say imudp, and uncomment both of them), then restart the rsyslog service using systemctl restart rsyslog
    
# target2-mgmt (172.16.1.11):

    # change system name from target2 to webhost (change both hostname and /etc/hosts files)
    # change ip address from host 11 to host 4 on the lan
    # add a machine named loghost to the /etc/hosts file as host 3 on the lan
    # install ufw if necessary and allow connections to port 80/tcp from anywhere
    # install apache2 in its default configuration
    # Configure rsyslog on webhost to send logs to loghost by modifying /etc/rsyslog.conf to add a line like this to the end of the file:

# *.* @loghost
# Before finishing, if the remote changes are successful, your script must update the NMS /etc/hosts file to have the name loghost with the correct IP address and the name webhost with the correct IP address. Verify you can retrieve the default Apache web page from the NMS using firefox with the URL http://webhost and that you can retrieve the logs showing webhost from loghost using the command ssh remoteadmin@loghost grep webhost /var/log/syslog. If the apache server responds properly and the syslog has entries from webhost, your script should let the user know that configuration update succeeded, otherwise it should tell them what did not work in a user-friendly way.

# Your script must run correctly without errors on our lab Ubuntu 22.04 desktop system. Your script must only use ssh to access the target1-mgtm and target2-mgmt machines. Using lxc to manage those machines from inside your script will not be accepted. We are trying to simulate actual remote servers.

# Submit your script as an attached file or by submitting your github link if you have one. Review the rubric linked above for details on how your work will be graded.

# You are done with the learning activity for this lesson and should proceed to writing the quiz for this lesson before the next class in this course begins.


# lxc exec containername command - FOR
# lxc list
# lxc exec containername bash

# Enstantiating variable names for script begins here
#-----------------------------------------------------

# Assigns the current username to the 'USERNAME' variable.
USERNAME=$(whoami)

# Saves the current date in this format: Day of the week, Month, Day, Year.
CURRENTDATE=$(echo "$(date +%A), $(date +%B) $(date +%d), $(date +%+4Y)")

# Saves the current time in this format: Hour:Minute:Second AM/PM.
CURRENTTIME=$(echo "$(date +%I):$(date +%M):$(date +%S) $(date +%p)")

# IP address for loghost
LOGHOSTIP="192.168.1.10"

# IP address for webhost
WEBHOSTIP="192.168.1.11"

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

#---------------------------------
#         NETWORK SERVICES
#---------------------------------

# target1-mgmt (172.16.1.10):

ssh-keyscan -t ed25519 "target1-mgmt" >>~/.ssh/known_hosts 2>/dev/null

# Set the hostname to loghost in /etc/hostname
ssh remoteadmin@target1-mgmt 'echo "loghost" > /etc/hostname'

# Update the current hostname on target1
echo -e "\n${GREEN}Updating hostname on target1...${RESET}"

ssh remoteadmin@target1-mgmt 'hostnamectl set-hostname loghost'

# Display the updated hostname on target1
echo -e "
${GREEN}Updated hostname on target1 to:${RESET} loghost"

# After commenting out information about the interface in other netplan files, we go about creating a Netplan configuration file for static IP
ssh remoteadmin@target1-mgmt "cat > /etc/netplan/50-cloud-init.yaml <<EOF
network:
    version: 2
    ethernets:
        eth0:
            addresses: [192.168.16.10/24]
            routes:
              - to: default
                via: 192.168.16.2
            nameservers:
                addresses: [192.168.16.2]
                search: [home.arpa, localdomain]
        eth1:
            addresses: [172.16.1.3/24]
EOF"

# Display the updated ip address on the LAN for target 1
echo -e "
${GREEN}Updated ip address on loghost to:${RESET} 172.16.1.3/24 on eth1."

# Run the new Netplan configuration
ssh remoteadmin@target1-mgmt 'sudo netplan apply &> /dev/null'

ssh-keyscan -t ed25519 "loghost" >>~/.ssh/known_hosts 2>/dev/null

# Updated /etc/hosts file on target1 with information regarding webhost so that it is host 4 on the LAN.
ssh remoteadmin@loghost 'echo '172.16.1.4 webhost' >> /etc/hosts &> /dev/null'

# Display the updated field on target1 in /etc/hosts
echo -e "
${GREEN}Updated /etc/hosts with webhost field:${RESET} 172.16.1.4 webhost"

#------------------------------------
#           FIREWALL SERVICES
#------------------------------------


# Check if UFW service is running

echo -e "
${GREEN}Checking if UFW is running on loghost...${RESET}"

if ! ssh remoteadmin@loghost 'sudo systemctl is-active ufw &> /dev/null'; then
    # Run a sudo apt-get update for compatibility.
    echo -e "
${RED}UFW service not found on loghost; Installing.${RESET}"

    ssh remoteadmin@loghost 'sudo apt-get update &> /dev/null && sudo apt-get install -y ufw &> /dev/null'

    ssh remoteadmin@loghost 'sudo ufw allow from 172.16.1.0/24 to any port 514 proto udp &> /dev/null'

    # Start UFW service after installation
    ssh remoteadmin@loghost 'sudo systemctl start ufw &> /dev/null'
else
    # If UFW service is already running, display that message to the user.
    echo -e "
${BLUE}UFW service already installed on loghost; Restarting..${RESET}"
    
    ssh remoteadmin@loghost 'sudo ufw allow from 172.16.1.0/24 to any port 514 proto udp &> /dev/null'
    ssh remoteadmin@loghost 'sudo ufw allow 22/tcp &> /dev/null'
    ssh remoteadmin@loghost 'sudo systemctl restart ufw &> /dev/null'

fi

# configure rsyslog to listen for UDP connections (look in /etc/rsyslog.conf for the configuration settings lines that say imudp, and uncomment both of them)

ssh remoteadmin@loghost "sudo sed -i 's/^#module(load=\"imudp\")/module(load=\"imudp\")/' /etc/rsyslog.conf"
ssh remoteadmin@loghost "sudo sed -i 's/^#input(type=\"imudp\" port=\"514\")/input(type=\"imudp\" port=\"514\")/' /etc/rsyslog.conf"

echo -e "
${GREEN}Configured rsyslog on loghost to listen for UDP connections.${RESET}"

#restart the rsyslog service using systemctl restart rsyslog

ssh remoteadmin@loghost "sudo systemctl restart rsyslog"

echo -e "
${GREEN}Restarting rsyslog on loghost.${RESET}"


# target2-mgmt (172.16.1.11):

ssh-keyscan -t ed25519 "target2-mgmt" >>~/.ssh/known_hosts 2>/dev/null

# Set the hostname to webhost in /etc/hostname
ssh remoteadmin@target2-mgmt 'echo "webhost" > /etc/hostname'

# Update the current hostname on target2
echo -e "\n${GREEN}Updating hostname on target2...${RESET}"

# Update the current hostname on target2
ssh remoteadmin@target2-mgmt 'hostnamectl set-hostname webhost'

# Display the updated hostname on target2
echo -e "
${GREEN}Updated hostname on target2 to:${RESET} webhost"

# After commenting out information about the interface in other netplan files, we go about creating a Netplan configuration file for static IP
ssh remoteadmin@target2-mgmt "cat > /etc/netplan/50-cloud-init.yaml <<EOF
network:
    version: 2
    ethernets:
        eth0:
            addresses: [192.168.16.11/24]
            routes:
              - to: default
                via: 192.168.16.2
            nameservers:
                addresses: [192.168.16.2]
                search: [home.arpa, localdomain]
        eth1:
            addresses: [172.16.1.4/24]
EOF"

# Display the updated ip address on the LAN for target 1
echo -e "
${GREEN}Updated ip address on loghost to:${RESET} 172.16.1.4/24 on eth1."

# Run the new Netplan configuration
ssh remoteadmin@target2-mgmt 'sudo netplan apply &> /dev/null'

ssh-keyscan -t ed25519 "webhost" >>~/.ssh/known_hosts 2>/dev/null

# Updated /etc/hosts file on target1 with information regarding webhost so that it is host 4 on the LAN.
ssh remoteadmin@webhost 'echo '172.16.1.4 webhost' >> /etc/hosts &> /dev/null'

# Display the updated field on target1 in /etc/hosts
echo -e "
${GREEN}Updated /etc/hosts with webhost field:${RESET} 172.16.1.4 webhost"

#------------------------------------
#           FIREWALL SERVICES
#------------------------------------

# Check if UFW service is running

echo -e "
${GREEN}Checking if UFW is running on webhost...${RESET}"

if ! ssh remoteadmin@webhost 'sudo systemctl is-active ufw &> /dev/null'; then    # Run a sudo apt-get update for compatibility.
    echo -e "
${RED}UFW service not found on webhost; Installing.${RESET}"

    ssh remoteadmin@webhost 'sudo apt-get update &> /dev/null && sudo apt-get install -y ufw &> /dev/null'

    ssh remoteadmin@webhost 'sudo ufw allow 80/tcp &> /dev/null'

    # Start UFW service after installation
    ssh remoteadmin@webhost 'sudo systemctl start ufw &> /dev/null'
else
    # If UFW service is already running, display that message to the user.
    echo -e "
${BLUE}UFW service already installed on webhost; Restarting..${RESET}"
    
    ssh remoteadmin@webhost 'sudo ufw allow 80/tcp &> /dev/null'
    ssh remoteadmin@webhost 'sudo ufw allow 22/tcp &> /dev/null'
    ssh remoteadmin@webhost 'sudo systemctl restart ufw &> /dev/null'

fi

# Install apache2 in its default configuration
#echo -e "${GREEN}Installing Apache2...${RESET} webhost"
#ssh remoteadmin@target2-mgmt 'sudo apt-get install -y apache2 &> /dev/null'

# Check if Apache2 web server service is running

echo -e "
${GREEN}Checking if Apache2 web service is running on webhost...${RESET}"

if ! ssh remoteadmin@webhost 'systemctl is-active --quiet apache2'; then
    
    # Run a sudo apt-get update for compatibility.
    echo -e "
    ${RED}Apache2 web server service not found on webhost; Installing.${RESET}"
    
    ssh remoteadmin@webhost "sudo apt-get update &> /dev/null && apt-get install -y apache2 &> /dev/null"

    # Start Apache2 service after installation
    ssh remoteadmin@webhost 'sudo systemctl start apache2 &> /dev/null'
else
    # If Apache2 web server service is already running, display that message to the user.
    echo -e "${BLUE}Apache2 web server service already installed on webhost; Restarting..${RESET}"
    
    ssh remoteadmin@webhost 'sudo systemctl restart apache2 &> /dev/null'
fi

# Configure rsyslog on webhost to send logs to loghost
ssh remoteadmin@webhost "sudo sed -i 's/^#module(load=\"imudp\")/module(load=\"imudp\")/' /etc/rsyslog.conf"
ssh remoteadmin@webhost "sudo sed -i 's/^#input(type=\"imudp\" port=\"514\")/input(type=\"imudp\" port=\"514\")/' /etc/rsyslog.conf"

echo -e "
${GREEN}Configured rsyslog on webhost to send logs to loghost.${RESET}"

# Configure rsyslog on webhost to send all log messages to the loghost.
ssh remoteadmin@webhost "echo '*.* @loghost' | sudo bash -c 'cat >> /etc/rsyslog.conf'"

#restart the rsyslog service using systemctl restart rsyslog

ssh remoteadmin@webhost "sudo systemctl restart rsyslog"

echo -e "
${GREEN}Restarting rsyslog on webhost.${RESET}"

# Update the NMS /etc/hosts file to have the name loghost with the correct IP address and the name webhost with the correct IP address.
#sudo bash -c 'echo "192.168.16.3 loghost" >> /etc/hosts'
#sudo bash -c 'echo "192.168.16.4 webhost" >> /etc/hosts'

# Check if an entry exists in /etc/hosts for the loghost's IP.
if grep -q "$LOGHOSTIP loghost" /etc/hosts; then
    # If the entry exists, update it with a new host name.
    sudo sed -i "s/^$LOGHOSTIP.*/$LOGHOSTIP loghost/" /etc/hosts
    LOGHOSTETC=$(grep "$LOGHOSTIP loghost" /etc/hosts)
    echo -e "
    ${GREEN}Updated entry in /etc/hosts:${RESET} $LOGHOSTETC"
else
    # Entry doesn't exist, add it to the file with a host name.
    sudo bash -c "echo '$LOGHOSTIP loghost' >> /etc/hosts"
    LOGHOSTETC=$(grep "$LOGHOSTIP loghost" /etc/hosts)
    echo -e "
    ${GREEN}Added entry to /etc/hosts:${RESET} $LOGHOSTETC"
fi

# Check if an entry exists in /etc/hosts for the webhosts's IP.
if grep -q "$WEBHOSTIP webhost" /etc/hosts; then
    # If the entry exists, update it with a new host name.
    sudo sed -i "s/^$WEBHOSTIP.*/$WEBHOSTIP webhost/" /etc/hosts
    WEBHOSTETC=$(grep "$WEBHOSTIP webhost" /etc/hosts)
    echo -e "
    ${GREEN}Updated entry in /etc/hosts:${RESET} $WEBHOSTETC"
else
    # Entry doesn't exist, add it to the file with a host name.
    sudo bash -c "echo '$WEBHOSTIP webhost' >> /etc/hosts"
    WEBHOSTETC=$(grep "$WEBHOSTIP webhost" /etc/hosts)
    echo -e "
    ${GREEN}Added entry to /etc/hosts:${RESET} $WEBHOSTETC"
fi

echo -e "
${GREEN}Updating /etc/hosts with entries for loghost and webhost.${RESET}"

# Retrieve the logs showing webhost from loghost
ssh remoteadmin@webhost "grep webhost /var/log/syslog"
