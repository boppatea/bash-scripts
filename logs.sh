#!/bin/bash

# Count the number of failed logins by IP.
# If there are any IPs over LIMIT failures, display the count, IP, and location.

LIMIT='10'
LOG_FILE="${1}"

# Make sure file was supplied as an argument.
if [[ ! -e "${LOG_FILE}" ]]
then
  echo "Cannot open log file: ${LOG_FILE}"
  exit 1
fi

# Run as root.
if [[ "${UID}" -ne 0 ]]
then
  echo 'Permission denied.'
  exit 1
fi

# Display the CSV header.
echo 'Count,IP,Location'

# Loop through list of failed attempts & IP addresses.
grep Failed syslog-sample | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | while read COUNT IP
do
  # If the number of failed attempts is greater than the limit, display all info.
  if [[ $"{COUNT}" -gt "${LIMIT}" ]]
  then
    LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
    echo "${COUNT},${IP},${LOCATIOIN}"
  fi
done
exit 0
