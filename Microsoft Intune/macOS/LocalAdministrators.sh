#!/bin/bash

USERNAME="wsadmin"
FULLNAME="WestSpring IT Local Administrator"
PASSWORD="REDACTED"

if id "$USERNAME" &>/dev/null; then
    exit 0
fi

sysadminctl -addUser "$USERNAME" -fullName "$FULLNAME" -password "$PASSWORD" -admin
exit 0
