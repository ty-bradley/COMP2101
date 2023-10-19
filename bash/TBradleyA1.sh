#!/bin/bash

# Name: Ty Bradley
# Course: COMP2137 - Linux Automation
# Professor: Dennis Simpson
# Date: October 4th, 2023

# The purpose of this script is to display some important identity information about a computer so that you can see that information quickly and concisely, without having to memorize mutliple commands or remember multiple command options.

# Run the source command to access distribution name and version for use later in the script.
source /etc/os-release

sudo lshw > LSHWOUTPUT.txt

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
CPUINFO=$(awk -F: '/description/ {print $2}' LSHWOUTPUT.txt | sed 's/^ *//')

# Current and Max Speed of CPU
CPUSPEEDMAX=$(cat /proc/cpuinfo | grep -w "model name" | head -n 1 | awk '{print $9}')
CPUSPEEDCURRENT=$(cat /proc/cpuinfo | grep -w "cpu MHz" |head -n 1 | awk '{print $4}')
CURRENTANDMAXSPEEDCPU=" ${LIGHTGREEN}Current:${RESET} (${CPUSPEEDCURRENT}MHz) ${LIGHTGREEN}Max:${RESET} (${CPUSPEEDMAX})"

# Current size of RAM allotted to VM
SIZERAM=$(free --giga -h | sed -n '2p' | awk '{print $2"igs alloted to VM. (" $4 " free)"}')

# Make and model of video card
MODELVGU=$(awk -F: '/product/ {print $2}' lshw_output.txt | sed 's/^ *//')
MAKEVGU=$(awk -F: '/vendor/ {print $2}' lshw_output.txt | sed 's/^ *//')
MAKEMODELVGU="${PRODUCTVGU} ${MAKEVGU}"

# Make, model, and size for all installed disks
MAKEMODELSIZEDISK=$(lsblk -io NAME,MODEL,SIZE | awk 'NF >= 3 {print}')

# Get the list of available disk names from lsblk -io NAME
AVAILABLEDISKS=$(lsblk -io NAME)

# Initialize a variable to store matched lines
INSTALLEDDISKS=""

# Loop through the available disks and store matching entries
for DISKS in $AVAILABLEDISKS; do
  MATCHEDISK=$(echo "$MAKEMODELSIZEDISK" | grep -w "$DISKS")
  if [ -n "$MATCHEDISK" ]; then
    INSTALLEDDISKS+="$MATCHEDISK\n"
  fi
done

# Fully qualified domain name
FQDN=$(hostname -f)

# Lists IP Address for the hostname
IPHOST=$(host $(hostname) | head -n 1 | awk '{print $NF}')

# Lists IP Adress for the Gateway
GATEWAYIP=$(ip route | awk '/default/ {print $3}')

# Lists IP Addreses of the DNS Server
DNSIP=$(grep -w 'nameserver' /etc/resolv.conf | awk '{print $2}')

# Lists IP Addreses of the DNS Server
NETCARD=$(awk -F 'description: ' '/description:/ {print $2; exit}' lshw_output.txt)

# Lists IP Addresses of the DNS Server
IPCIDR=$(ip a | awk '/inet .* brd / {print $2; exit}')

# Lists all users currently logged into the system
USERSLOGGEDIN=$(who -u | awk '{print $1}')

# Shows free space for local filesystems in format: / MOUNTPOINT N
FREEDISKSPACE=$(df -h --output=source,avail)

# Lists process count
PROCESSCOUNT=$(ps -e | wc -l)

# Lists load averages
LOADAVERAGES=$(uptime | awk -F'[a-zA-Z: ]+' '{print $2, $3, $4}')

# Lists memory allocation
MEMORYALLOCATION=$(free -h)

# Lists currently listening network ports
LISTENINGNETWORKPORTS=$(ss -tuln | grep -w LISTEN)

# Lists data from UFW Show
UFWRULES=$(sudo ufw status)


# Enstantiating variable names for script ends here
#-----------------------------------------------------

echo -e "
----------------------------------

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
${GREEN}Disk(s): ${RESET} 
$INSTALLEDDISKS
`#Video: MAKE AND MODEL OF VIDEO CARD`
${GREEN}Video Card Make:${RESET} $MAKEVGU
`#Video: MAKE AND MODEL OF VIDEO CARD`
${GREEN}Video Card Model:${RESET} $MODELVGU


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
${GREEN}Interface Name:${RESET} $NETCARD
`# IP Address in CIDR FORMAT`
${GREEN}IP Address:${RESET} $IPCIDR


------------- 

${CYAN}System Status${RESET}

-------------
`# Lists all users currently logged into the system`
${GREEN}Users Logged In:${RESET} $USERSLOGGEDIN
`# Shows free space for local filesystems in format: / MOUNTPOINT N`
${GREEN}Disk Space:${RESET} 
$FREEDISKSPACE
`# Lists process count`
${GREEN}Process Count:${RESET} $PROCESSCOUNT
`# Lists load averages`
${GREEN}Load Averages:${RESET} $LOADAVERAGES
`# Lists memory allocation`
${GREEN}Memory Allocation:${RESET} 
$MEMORYALLOCATION
`# Lists currently listening network ports`
${GREEN}Listening Network Ports:${RESET} 
$LISTENINGNETWORKPORTS
`# Lists data from UFW Show`
${GREEN}UFW Rules:${RESET} $UFWRULES

"

sudo rm LSHWOUTPUT.txt.txt

#End of File
