#!/bin/bash
#
# Copyright (c) 2016 Jacob Young
# MIT License
#
# This script will append a list of added/removed features to a commit message.
# It reads comments following a '@commit' symbol and constructs an unordered list of them.
# After comments are read, they are removed from the file they are found
#
# Example:
# //@commit: Added new link parsing function
#
# Output (in commit message):
# - Added new link parsing funciton

# ADD FILES TO SEARCH
# Example: 
EXTENSIONS=( ".cpp" ".html" ".css" ".js" )

which -s pcregrep 
if [ $? -eq 0 ]; then
  # Assuming Mac OS X (pcregrep available)
  grep_search="pcregrep -o2 '((?:[#;*]|(?:\/{2}))(?:\s+)?@commit(?:[-:.\s]+)?)([^\r\n*\/]+)'"
else
  grep_search="grep -Po '(?:[#;*]|(?:\/{2}))(?:\s+)?@commit(?:[-:.\s]+)?\K([^\r\n*\/]+)'"
fi

GITLS=$(git ls-files)
# String Replace: newline with space (to match default IFS variable)
# Then construct an array with the new string (space separated)
ADDED_FILES=( ${GITLS//$'\n'/ } )

for i in ${!ADDED_FILES[@]}; do
  
  file_path=${ADDED_FILES["$i"]}
  filename=$( basename "$file_path" )
  extension="${filename##*.}"
  if [[ "${EXTENSIONS[*]}" =~ "${extension}" ]]; then
    # File type is matched
    continue
  else
    # File should not be read - remove
    unset ADDED_FILES["$i"]
  fi
done

comments=""
for fn in "${ADDED_FILES[@]}"; do
  temp=$( cat "$fn" | eval "$grep_search" | tr -s '[:space:]' )
  if [[ "$temp" != ""  ]]; then
    comments+="$temp"
    comments+="\n"
  fi
  # Uncomment sed command to remove '// @commit' comments in all files
  # sed -ri 's/(([#;*]|\/{1,2})?(\s+)?@commit([-:.\s]+)?)([^\r\n*\/]+)//' "$fn" # GNU sed compatible only 
  # Uncomment sed command to replace multiple empty lines with a single empty line
  # sed '/^$/N;/^\n$/D' "$fn" # GNU sed compatible only
done
comments=$(echo -en "$comments" | sed -e 's/^/- /')
echo -n "$comments"
