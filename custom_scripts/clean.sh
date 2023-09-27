#!/bin/bash

# Get the last line of the xauth list
last_line=$(xauth list | tail -1)

# Extract the display number, protocol, and cookie from the last line
display_number=$(echo "$last_line" | awk '{print $1}')
protocol=$(echo "$last_line" | awk '{print $2}')
cookie=$(echo "$last_line" | awk '{print $3}')

# Check if "/unix" already exists in the display number
if [[ "$display_number" != *"/unix"* ]]; then
  # Modify the display number format
  modified_display_number=$(echo "$display_number" | awk -F ":" '{print $1 "/unix:" $2}')

  # Remove each entry individually
  xauth list | awk '{print $1}' | while read -r entry; do
    xauth remove "$entry"
  done

  # Add the modified line using the correct xauth add command
  xauth add "$modified_display_number" "$protocol" "$cookie"

  # Print the modified line for verification
  echo "Modified line: $modified_display_number $protocol $cookie"
else
  echo "No modification needed. '/unix' already exists in the display number."
fi

# In any case export correct DISPLAY value
export DISPLAY=:10.0
