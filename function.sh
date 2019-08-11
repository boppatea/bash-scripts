#!/bin/bash

# This script demonstrates the use of functions.
# Function is simply a group of commands - little script within script
# Purpose: DRY
# help function
# function <name> or <name>()
# local - variables local to a function

# Make sure to use return, not exit in function

log() {
  # This function sends a message to syslog and to STDOUT if VERBOSE is true.
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
  logger -t function.sh "${MESSAGE}"
}

backup_file() {
 # This function creates a backup of a file. Returns non-zero status on error.
 local FILE="${1}"
 
 # Make sure the file exists.
 if [[ -f "${FILE}" ]]
 then
  local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
  log "Backing up ${FILE} to ${BACKUP_FILE}"

  # The exist status of function will be the exit status of the cp command.
  cp -p ${FILE} ${BACKUP_FILE}
 else
  # The file doesn't exist, so return a non-zero exit status.
  return 1
 fi
}


log 'Hello!'
# const variable using 'readonly'
readonly VERBOSE='true'
log 'This is a function!'
backup_file './test'

if [[ "${?}" -eq 0 ]]
then 
 echo 'File backup was successful.'
else
 echo "File backup failed."
 exit 1
fi
