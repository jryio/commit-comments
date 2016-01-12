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

IGNORED=( ".ccignore" )

# If the script is deployed to the .git directory,
# move to the repository directory so .ccignore file
# can be found
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if echo "$DIR" | grep -qs 'git'; then
  cd "$( echo "$DIR" | grep -Po '^.*(?=(\.git))' )" 
fi

if [ -f ".ccignore" ]; then
 while IFS='' read -r line || [[ -n "$line" ]]; do
   IGNORED+=( "$line" )
  done < ".ccignore"
fi

if which pcregrep > /dev/null; then
  grep_search="pcregrep -o2 '((?:[#;*]|(?:\/{2}))(?:\s+)?@commit(?:[-:.\s]+)?)([^\r\n*\/]+)'"
else
  grep_search="grep -Po '(?:[#;*]|(?:\/{2}))(?:\s+)?@commit(?:[-:.\s]+)?\K([^\r\n*\/]+)'"
fi

IFS=$'\n' ADDED_FILES=( $(git ls-files) )
for i in ${!ADDED_FILES[@]}; do
  
  file_path=${ADDED_FILES["$i"]}
  filename=$( basename "$file_path" )
  extension="${filename##*.}"
  # File should be removed if filename or extension type has been specified in .ccignore
  if [[ "${IGNORED[*]}" =~ "${filename}" || "${IGNORED[*]}" =~ "${extension}" ]]; then
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
