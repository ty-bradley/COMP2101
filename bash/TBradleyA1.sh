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

# Assigns the current username to the 'USERNAME' variable.
USERNAME=$(whoami)

# Saves the current date in this format: Day of the week, Month, Day, Year.
CURRENTDATE=$(echo "$(date +%A), $(date +%B) $(date +%d), $(date +%+4Y)")

# Saves the current time in this format: Hour:Minute:Second AM/PM.
CURRENTTIME=$(echo "$(date +%I):$(date +%M):$(date +%S) $(date +%p)")

# Stores the current hostname (name for the machine) in the 'HOSTNAME' variable.
HOSTNAME=$(hostname)

# Retrieves information about the Linux Distro and version from /etc/os-release.
DISTROWITHVERSION=$(echo $PRETTY_NAME)

# Captures the current up time duration.
UPTIME=$(uptime -p | cut -d' ' -f2-)

# Extracts the processor information.
CPUINFO=$(cat LSHWOUTPUT.txt | grep CPU | grep product | head -n 1 | awk -F': ' '{print $2}')

# Extracts the processor make and model information.
CPUSPEEDMAX=$(cat /proc/cpuinfo | grep -w "model name" | head -n 1 | awk '{print $9}')
CPUSPEEDCURRENT=$(cat /proc/cpuinfo | grep -w "cpu MHz" | head -n 1 | awk '{print $4}')
CURRENTANDMAXSPEEDCPU=" ${LIGHTGREEN}Current:${RESET} (${CPUSPEEDCURRENT}MHz) ${LIGHTGREEN}Max:${RESET} (${CPUSPEEDMAX})"

# Obtains the RAM size and available memory.
SIZERObtains the RAM size and available memory.AM=$(free --giga -h | sed -n '2p' | awk '{print $2"igs alloted to VM. (" $4 " free)"}')

# Retrieves the video card make and model.
MODELVGU=$(grep -A 11 'display' LSHWOUTPUT.txt | grep product | head -n 1 | awk -F': ' '{print $2}')
# Captures the video card manufacturer.
MAKEVGU=$(grep -A 11 'display' LSHWOUTPUT.txt | grep vendor| head -n 1 | awk -F': ' '{print $2}')
# Combines the video card make and model into one variable.
MAKEMODELVGU="${PRODUCTVGU} ${MAKEVGU}"

# Gathers information about installed disks' names, models, and sizes.
MAKEMODELSIZEDISK=$(lsblk -io NAME,MODEL,SIZE | awk 'NF >= 3 {print}')

# Stores the fully qualified domain name (FQDN).
FQDN=$(hostname -f)

# Retrieves the IP address associated with the hostname.
IPHOST=$(hostname --ip-address)

# For storing the gateway IP address.
GATEWAYIP=$(ip route | awk 'default {print $3}')

# Grabs the IP addresses of DNS servers.
DNSIP=$(grep -w 'nameserver' /etc/resolv.conf | awk '{print $2}')

# Gets the network card description.
NETCARD=$(awk -F 'description: ' '/description:/ {print $2; exit}' LSHWOUTPUT.txt)

# Lists the IP addresses on network interfaces in CIDR format.
IPCIDR=$(ip a | grep 'inet .*' | awk '{print $2}')

# Provides a list of currently logged-in users
USERSLOGGEDIN=$(who -q)

# Displays free space on local filesystems in the format: / MOUNTPOINT N.
FREEDISKSPACE=$(df -h --output=source,avail)

# Counts the number of running processes.
PROCESSCOUNT=$(ps -e | wc -l)

# Presents the load averages from the uptime command.
LOADAVERAGES=$(uptime | grep -o 'load .*' | cut -d' ' -f3-)

# Lists memory allocation
MEMORYALLOCATION=$(free -h)

# Lists currently listening network ports.
LISTENINGNETWORKPORTS=$(ss -tuln | grep -w LISTEN)

# Retrieves and displays UFW (Uncomplicated Firewall) rules
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
$MAKEMODELSIZEDISK
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
${GREEN}IP Address(es) in CIDR Format:${RESET} 
$IPCIDR


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

sudo rm LSHWOUTPUT.txt

#End of File
