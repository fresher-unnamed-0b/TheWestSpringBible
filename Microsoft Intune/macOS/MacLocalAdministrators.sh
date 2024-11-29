#!/bin/bash

# Define the username and password
username="<USERNAME>"
password="<PASSWORD>"

# Create the user with the specified username and password
sudo dscl . -create /Users/$username
sudo dscl . -create /Users/$username UserShell /bin/bash
sudo dscl . -create /Users/$username RealName "<ACCOUNT NAME HERE>" # Enter the name of the account
sudo dscl . -create /Users/$username UniqueID "510"
sudo dscl . -create /Users/$username PrimaryGroupID 80
sudo dscl . -create /Users/$username NFSHomeDirectory /Users/$username
sudo dscl . -passwd /Users/$username $password

# Create the home directory
sudo createhomedir -c -u $username > /dev/null

# Add the user to the admin group
sudo dscl . -append /Groups/admin GroupMembership $username