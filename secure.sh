#!/bin/bash

# Display '/var/log/secure' for jpark 

LOG_FILE="/var/log/secure"

if [[ ! -e "${LOG_FILE}" ]]
then 
  echo "Cannot open ${LOG_FILE}" >&2
  exit 1
fi

if [[ "${UID}" -ne 0 ]]
then
  echo "Permission denied. You're ${UID}." >&2
  exit 1
fi

sudo cut -d ' ' -f 5-25 ${LOG_FILE} | grep -E 'jpark|var|secure' | sort | uniq -c | sort -n 
