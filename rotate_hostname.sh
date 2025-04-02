#!/bin/bash

# Hostname Rotator Script for macOS
# Run this script with sudo: sudo ./rotate_hostname.sh

# Hostname template file
HOSTNAME_FILE="hostnames.txt"

# Check if hostname file exists
if [ ! -f "$HOSTNAME_FILE" ]; then
  echo "Error: Hostname template file '$HOSTNAME_FILE' not found."
  exit 1
fi

# Read hostnames into an array using a while loop
declare -a hostname_templates
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines or lines starting with # (comments)
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    hostname_templates+=("$line")
done < "$HOSTNAME_FILE"

# Get the number of templates
num_templates=${#hostname_templates[@]}

# Select a random template index
random_index=$(( RANDOM % num_templates ))

# Get the random template
template=${hostname_templates[$random_index]}

# Function to generate random character (digit or hex)
generate_random_char() {
  local type=$1
  if [[ "$type" == "NUM" ]]; then
    echo $(( RANDOM % 10 ))
  elif [[ "$type" == "HEX" ]]; then
    printf "%X" $(( RANDOM % 16 ))
  fi
}

# Process the template to generate the final hostname
new_hostname=""
current_placeholder=""
placeholder_active=false

for (( i=0; i<${#template}; i++ )); do
  char="${template:$i:1}"

  if [[ "$char" == "{" ]]; then
    placeholder_active=true
    current_placeholder=""
  elif [[ "$char" == "}" && "$placeholder_active" == true ]]; then
    placeholder_active=false
    random_char=$(generate_random_char "$current_placeholder")
    new_hostname+="$random_char"
  elif [[ "$placeholder_active" == true ]]; then
    current_placeholder+="$char"
  else
    new_hostname+="$char"
  fi
done

# Handle case where template ends mid-placeholder (shouldn't happen with valid templates)
if [[ "$placeholder_active" == true ]]; then
    echo "Warning: Malformed template detected - unterminated placeholder: $template"
    # Append the incomplete placeholder part as-is or handle differently?
    # For now, just append what was read:
    new_hostname+="{$current_placeholder"
fi




echo "Selected new hostname: $new_hostname"

# --- macOS Specific Commands --- 

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root (use sudo)."
   exit 1
fi

# Set the new hostname using scutil
echo "Setting HostName to $new_hostname..."
scutil --set HostName "$new_hostname"

echo "Setting LocalHostName to $new_hostname..."
scutil --set LocalHostName "$new_hostname"

echo "Setting ComputerName to $new_hostname..."
scutil --set ComputerName "$new_hostname"

# --- End macOS Specific Commands ---

echo "Hostname updated successfully to $new_hostname."
echo "Based on template: $template"
echo "Note: A restart might be required for all applications and services to recognize the change."

exit 0
