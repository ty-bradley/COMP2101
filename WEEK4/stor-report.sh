#!/bin/bash

# Show information about the current storage space available.

# Get current user and store it within a variable. 'whoami' command prints the current user's username to the terminal.

USER=$(whoami)

# use 'date' command with the '+%T"' format specifier to format the current output in 24-hour format (HH:MM:SS)

TIME=$(date +"%T")

echo
echo "--------------------------------------"
echo "Storage summary report for" $USER ":"
echo "--------------------------------------"
echo "Report generated at:" $TIME
echo "_______________________________________"
echo
# df is a command that assists to identify mounted local disk filesystems.
# add -h to make it print in human readable format.
# The same command identifies free space within your filesystem holding your home directory.

df -h

# To see how much your home directory is taking up we use du.
# We can specify the directory for du, and by default it does not show current user home directory.
# -s option is used to specify a summary
# -h is used to specify display sizes within a human readable format.

  # du -sh /path/to/directory

# We can specify our home directory with a tilde.
echo
echo "Free space available on home directory: "
echo "_____________________________________________"
echo
du -sh ~
echo
echo "Number of regular files in home directory: "
echo "_______________________________________"
echo
find ~ -type f | wc -l
echo
