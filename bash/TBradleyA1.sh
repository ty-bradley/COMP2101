#!/bin/bash

# Name: Ty Bradley
# Course: COMP2137 - Linux Automation
# Professor: Dennis Simpson
# Date: October 4th, 2023

# The purpose of this script is to display some important identity information about a computer so that you can see that information quickly and concisely, without having to memorize mutliple commands or remember multiple command options.

# Run the source command to access distribution name and version for use later in the script.
source /etc/os-release

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


# Enstantiating variable names for script begins here
#-----------------------------------------------------

# Variable for current user name.
USERNAME=$(whoami)

# Variable for current date, by day of the week, numerical day, month, and year.
CURRENTDATE=$(echo "$(date +%A), $(date +%B) $(date +%d), $(date +%+4Y)")

# Variable for current date, by hour, minute, seconds, and AM or PM.
CURRENTTIME=$(echo "$(date +%I):$(date +%M):$(date +%S) $(date +%p)")

# Variable for current host.
HOSTNAME=$(hostname)

# Variable for current Linux Distrobution with version.
DISTROWITHVERSION=$(echo $PRETTY_NAME)

# Current uptime.
UPTIME=$(uptime -p | cut -d' ' -f2-)

# Current CPU information.
CPUINFO=$(hwinfo --short --cpu | sed -n '2p' | sed 's/^[ \t]*//' | awk '{print $1, $2, $3, $4}')

# Current and Max Speed of CPU
CPUSPEEDGHZ=$(hwinfo --short --cpu | sed -n '2p' | sed 's/^[ \t]*//' | awk '{print $6}')
CPUSPEEDMHZ=$(hwinfo --short --cpu | sed -n '2p' | sed 's/^[ \t]*//' | awk '{print "("$7}')
CURRENTANDMAXSPEEDCPU="${CPUSPEEDGHZ} ${CPUSPEEDMHZ}MHz)"

# Current size of RAM allotted to VM
SIZERAM=$(free --giga -h | sed -n '2p' | awk '{print $2"igs alloted to VM. (" $4 " free)"}')

# Make and model of video card
MAKEMODELVGU=$(echo "null")

# Make, model, and size for all installed disks.
MAKEMODELSIZEDISK=$(echo "null")

# Fully qualified domain name
FQDN=$(echo "null")

# Lists IP Address for the hostname
IPHOST=$(echo "null")

# Lists IP Adress for the Gateway
GATEWAYIP=$(echo "null")

# Lists IP Addreses of the DNS Server
DNSIP=$(echo "null")

# Lists IP Addreses of the DNS Server
NETCARD=$(echo "null")

# Lists IP Addreses of the DNS Server
IPCIDR=$(echo "null")

# Lists all users currently logged into the system
USERSLOGGEDIN=$(echo "null")

# Shows free space for local filesystems in format: / MOUNTPOINT N
FREEDISKSPACE=$(echo "null")

# Lists process count
PROCESSCOUNT=$(echo "null")

# Lists load averages
LOADAVERAGES=$(echo "null")

# Lists memory allocation
MEMORYALLOCATION=$(echo "null")

# Lists currently listening network ports
LISTENINGNETWORKPORTS=$(echo "null")

# Lists data from UFW Show
UFWRULES=$(echo "null")


# Enstantiating variable names for script ends here
#-----------------------------------------------------

echo -e "
    ${RED}System Report${RESET}

----------------------------------

${YELLOW}Report Generation Information${RESET}

----------------------------------
${YELLOW}User${RESET}: $USERNAME
----------------------------------
${YELLOW}Date${RESET}: $CURRENTDATE
----------------------------------
${YELLOW}Time${RESET}: $CURRENTTIME
----------------------------------

------------------ 

${CYAN}System Information${RESET}

------------------
`# Current Hostname within system.`
${GREEN}Hostname:${RESET} $HOSTNAME
`# Current Linux OS distribution within system.`
${GREEN}Operating System:${RESET} $DISTROWITHVERSION
`# Current uptime of system.`
${GREEN}Current uptime:${RESET} $UPTIME


--------------------

${CYAN}Hardware Information${RESET}

--------------------
`#cpu: PROCESSOR MAKE AND MODEL`
${GREEN}CPU:${RESET} $CPUINFO
`#Speed: CURRENT AND MAXIMUM CPU SPEED`
${GREEN}Speed:${RESET} $CURRENTANDMAXSPEEDCPU
`#Ram: SIZE OF INSTALLED RAM`
${GREEN}Ram:${RESET} $SIZERAM
`#disk(s): MAKE AND MODEL AND SIZE FOR ALL INSTALLED DISKS`
${GREEN}Disk(s):${RESET} $MAKEMODELSIZEDISK
`#Video: MAKE AND MODEL OF VIDEO CARD`
${GREEN}Video:${RESET} $MAKEMODELVGU


------------------- 

${CYAN}Network Information${RESET}

-------------------

`# Fully Qualified Domain Name`
${GREEN}FQDN:${RESET} $FQDN
`# IP Address for the hostname`
${GREEN}Host Address:${RESET} $IPHOST
`# IP Address for the Gateway`
${GREEN}Gateway IP:${RESET} $GATEWAYIP
`# IP Address of the DNS Server`
${GREEN}DNS Server:${RESET} $DNSIP
`# Make and model of network card`
${GREEN}InterfaceName:${RESET} $NETCARD
`# IP Address in CIDR FORMAT`
${GREEN}IP Address:${RESET} $IPCIDR


------------- 

${CYAN}System Status${RESET}

-------------
`# Lists all users currently logged into the system`
${GREEN}Users Logged In:${RESET} $USERSLOGGEDIN
`# Shows free space for local filesystems in format: / MOUNTPOINT N`
${GREEN}Disk Space:${RESET} $FREEDISKSPACE
`# Lists process count`
${GREEN}Process Count:${RESET} $PROCESSCOUNT
`# Lists load averages`
${GREEN}Load Averages:${RESET} $LOADAVERAGES
`# Lists memory allocation`
${GREEN}Memory Allocation:${RESET} $MEMORYALLOCATION
`# Lists currently listening network ports`
${GREEN}Listening Network Ports:${RESET} $LISTENINGNETWORKPORTS
`# Lists data from UFW Show`
${GREEN}UFW Rules:${RESET} $UFWRULES

"
#End of File