#!/bin/bash
#
# This script is for the bash lab on variables, dynamic data, and user input
# Download the script, do the tasks described in the comments
# Test your script, run it on the production server, screenshot that
# Send your script to your github repo, and submit the URL with screenshot on Blackboard

# Get the current hostname using the hostname command and save it in a variable
oldname=$(hostname)
# Tell the user what the current hostname is in a human friendly way
echo "hostname is $oldname"
# Ask for the user's student number using the read command
read -p "Please enter the student number!: " auser
# Use that to save the desired hostname of pcNNNNNNNNNN in a variable, where NNNNNNNNN is the student number entered by the user
newname=pc$auser
# If that hostname is not already in the /etc/hosts file, change the old hostname in that file to the new name using sed or something similar and
sudo sed -i "s/$oldname/$newname/" /etc/hosts
#     tell the user you did that
echo "Hostname changed to $newname"
#e.g. sed -i "s/$oldname/$newname/" /etc/hosts

# If that hostname is not the current hostname, change it using the hostnamectl command and
hostnamectl set-hostname $newname
#     tell the user you changed the current hostname and they should reboot to make sure the new name takes full effect
echo "Hostname successfully changed, reboot your pc to make sure changes take effect"
#e.g. hostnamectl set-hostname $newname
