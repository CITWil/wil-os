#!/bin/bash
# 
# Copy data from a Time Machine volume mounted on a Linux box.
#
# Usage: copy-from-time-machine.sh <source> <target>
#
# source: the source directory inside a time machine backup
# target: the target directory in which to copy the reconstructed
#         directory trees. Created if it does not exists.
#
# Details:
#
# Time machine implements directory hard links by creating an
# empty file in place of the directory and storing in its
# "number of hard links" metadata attribute a pointer to a
# real directory in "/.HFS Private directory data^M" named
# "dir_$number".
#
# This script reconstructs a plain directory tree from this
# really ugly apple hack. Tested on a 650GB backup from OSX
# 10.6 mounted on a Linux 3.2.0-38 Ubuntu box. YMMV.
#
# MIT License.
# 
#  - vjt@openssl.it
#

self="$0"
source="$1"
target="$2"
hfsd="$3"

set -e

if [ -z "$source" -o -z "$target" ]; then
  echo "Usage: $self <source> <target>"
  exit -1
fi

if [ ! -d "$target" ]; then
  mkdir -p "$target"
fi

if [ -z "$hfsd" ]; then
  # Look for HFS Private directory data
  sysname="$(echo -ne '.HFS+ Private Directory Data\r')"
  hfsd=$source
  while [ "$hfsd" != "/" -a ! -d "$hfsd/$sysname" ]; do
    hfsd=`dirname "$hfsd"`;
  done

  if [ "$hfsd" = '/' ]; then
    echo "HFS Private Directory Data not found in $source, is it an HFS filesystem?"
    exit -2
  else
    echo "HFS Private Directory Data found in '$hfsd'"
    hfsd="$hfsd/$sysname"
  fi
fi

find "$source" -mindepth 1 -maxdepth 1 -and -not -name . -and -not -name .. | while read entry; do
  dest="$target/`basename "$entry"`"
  read hlnum type <<<$(stat -c '%h %F' "$entry")

  case $type in
    'regular file'|'symbolic link')
      cp -van "$entry" "$dest"
      ;;

    'directory')
      # Recurse
      $self "$entry" "$dest" "$hfsd"
      ;;

    'regular empty file')
      if [ -d "$hfsd/dir_$hlnum" ]; then
        # Recurse
        $self "$hfsd/dir_$hlnum" "$dest" "$hfsd"
      else
        echo "Skipping empty file $entry"
      fi
      ;;
  esac

done
