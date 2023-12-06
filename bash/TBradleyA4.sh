# #!/bin/bash

# # Name: Ty Bradley
# # Course: COMP2137 - Linux Automation
# # Professor: Dennis Simpson
# # Date: December 6th, 2023

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
# Begin Assignment 4 summary
#-----------------------------------------------------
#

# In this assignment, yyou will demonstrate creating an Ansible management system and then using it to deploy configuration controls to multiple systems.

# In order to perform these activities, Ansible must be installed on the management system, and target systems must be created. Ansible uses python, so you may need to install python as well. Ansible and python can be installed using apt on Ubuntu. You can reuse your existing course VM if it has enough free disk space. You will need at least 8GB for this lab. If you do not have at least 8GB free on your VM, make a new one with a larger disk.

# Install Ansible

# Add the Ansible ppa to your apt confiugration

# sudo add-apt-repository --yes --update ppa:ansible/ansible
# Install Ansible

# sudo apt install ansible
# Create the target systems for this lab and verify ssh access to the targets. The script to download and run will create multiple container systems (looking like this) with hostnames of target1, target2, etc. Those containers will already have ssh access enabled for your account to remotely run commands using the username remoteadmin on those targets. Those targets and your VM will all know the hostnames and IP addresses for the target machines. You may find it interesting to review the content of the makecontainers.sh script.

# wget https://zonzorp.github.io/COMP2137/makecontainers.sh
# bash makecontainers.sh --prefix target --count 2 --fresh
# ssh remoteadmin@target1 echo hello from target 1
# ssh remoteadmin@target2 echo hello from target 2
# Update the ansible hosts inventory file to add our targets

# printf "\n[targets]\n"|sudo tee -a /etc/ansible/hosts
# lxc list|grep -o -w target. |sudo tee -a /etc/ansible/hosts
# Review what the commands above put into your Ansible hosts inventory file.

# cat /etc/ansible/hosts
# Run the Ansible ping module on each host in our targets group to verify we can send modules to them.

# ansible targets -m ping -u remoteadmin
# Create a playbook file. Specify the name of the only play in the playbook, the targets it applies to, the remote user account to use, and the task list for the play. This one will ensure the fortune and cowsay packages are installed on the machines in the targets group.

# cat > testplay.yaml <<EOF
# - name: test play - install the cow
#   hosts: targets
#   remote_user: remoteadmin
#   tasks:
#     - name: fortune and cowsay package install
#       apt:
#         name:
#           - fortune
#           - cowsay
#         state: present
#         update_cache: yes
# EOF
# Run the playbook. You should see it gathering facts, and then running the play on each of the targets.

# ansible-playbook testplay.yaml
# Create a play in a playbook to install apache2 on target1. Also enable the ufw firewall and make sure it has a rule to allow ssh and another rule to allow http on port 80. These are both tcp only.

# Create a play in a playbook to install mysql on target2. Also enable the ufw firewall and make sure it has a rule to allow ssh and another rule to allow mysql on port 3306. These are both tcp only.

# To test your Ansible plays, run them, and then try opening http://target1 in a browser, and try running ufw status and ss -tlpn on both targets (you can just use ssh remoteadmin@targetN to get onto targetN to run these commands).

# Submit screenshots showing the browser successfully accessing http://target1 and the ufw and ss commands correctly running on both targets, along with your playbook files once you have them tested and working properly.

# Review the rubric linked above for details on how your work will be graded.

# You are done with the learning activity for this lesson and can start reviewing the course materials and activities from the second half of the course in preparation for the final exam.

# End Assignment 4 summary
#-----------------------------------------------------
#


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

    ${RED}ASSIGNMENT 4 SCRIPT${RESET}

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

