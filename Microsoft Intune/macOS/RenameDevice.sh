#!/bin/bash

SERIAL=$(system_profiler SPHardwareDataType | awk '/Serial Number/{print $4; exit}')
if [[ -z "$SERIAL" ]]; then
    exit 1
fi

NEWNAME="WS-${SERIAL}"
scutil --set ComputerName "$NEWNAME"
scutil --set HostName "$NEWNAME"
scutil --set LocalHostName "$NEWNAME"
exit 0
