#!/bin/bash

# This script generates a random password.
# The user can set the password length with -l & add a special character with -s.
# Verbose mode can be enabled with -v.

usage() {
  echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
  echo 'Generate a random password.'
  echo '  -l LENGTH Specify the password length.'
  echo '  -s        Append a special character to the password.'
  echo '  -v        Increase verbosity.'
  exit 1
}

log() {
  local MESSAGE="${@}"
  
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
}
# Set a default password length.
LENGTH=48

# : after option to set requirement.
while getopts vl:s OPTION
do 
  case ${OPTION} in 
    v)
      VERBOSE='true'
      log 'Verbose mode is on.'
      ;;
    l)
      LENGTH="${OPTARG}"
      ;;
    s)
      USE_SPECIAL_CHAR='true'
      ;;
    ?)
      usage 
      ;;
  esac
done

echo "Number of args: ${#}"
echo "All args: ${@}"
echo "First arg: ${1}"
echo "Second arg: ${2}"
echo "Third arg: ${3}"

# Inspect OPTIND
echo "OPTIND: ${OPTIND}"

# Remove the options while leaving the remaining arguments.
# Use if you want to run command on arguments, not options.
shift "$(( OPTIND -1 ))"

echo 'After the shift:'
echo "All args: ${@}"
echo "First arg: ${1}"
echo "Second arg: ${2}"
echo "Third arg: ${3}"


log 'Generating a password.'

PASSWORD=$(date +%s%N%{RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

# Append a special character if requested to do so.
if [[ "${USE_SPECIAL_CHAR}" -eq 'true' ]]
then
  log 'Selecting random special character.'
  SPECIAL_CHARACTER=$(echo '!@#$%^&*()-+=' | fold -w1 | shuf | head -c1)
  PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

log 'Done.'
log 'Generated password:'

# Display the password.
echo "${PASSWORD}"

exit 0
