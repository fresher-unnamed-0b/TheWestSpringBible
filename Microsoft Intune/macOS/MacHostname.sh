#!/bin/bash

# Get the serial number of the Mac
serialNumber=$(system_profiler SPHardwareDataType | awk '/Serial Number/{print $4}')

# Define the new hostname
newHostname="WS-${serialNumber}"

# Set the new hostname
sudo scutil --set HostName "$newHostname"
sudo scutil --set LocalHostName "$newHostname"
sudo scutil --set ComputerName "$newHostname"