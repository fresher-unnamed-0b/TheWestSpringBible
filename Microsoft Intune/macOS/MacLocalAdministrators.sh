#!/bin/bash

# Define the username and password
username="<USERNAME>"
password="<PASSWORD>"

# Ensure UniqueID is available and doesn't conflict (you might want to change this ID based on your system)
uniqueID=$(dscl . -list /Users UniqueID | tail -n 1)
uniqueID=$((uniqueID + 1))  # Increment the last ID by 1 to ensure a unique ID

# Create the user with the specified username and password
sudo dscl . -create /Users/$username
sudo dscl . -create /Users/$username UserShell /bin/bash
sudo dscl . -create /Users/$username RealName "<ACCOUNT NAME HERE>"  # Enter the name of the account
sudo dscl . -create /Users/$username UniqueID "$uniqueID"
sudo dscl . -create /Users/$username PrimaryGroupID 80
sudo dscl . -create /Users/$username NFSHomeDirectory /Users/$username
sudo dscl . -passwd /Users/$username $password

# Create the home directory (alternative method if createhomedir doesn't exist)
sudo mkdir /Users/$username
sudo chown $username:staff /Users/$username
sudo chmod 700 /Users/$username

# Add the user to the admin group
sudo dscl . -append /Groups/admin GroupMembership $username

echo "User $username created successfully and added to the admin group."
