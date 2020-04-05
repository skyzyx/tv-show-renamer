#! /usr/bin/env bash

##
# Copyright (c) 2019 Ryan Parman <https://ryanparman.com>
# License: MIT <https://opensource.org/licenses/MIT>
#
# Assumes GNU tools instead of BSD tools: <https://flwd.dk/31ELAKJ>
# Also: brew install mp4v2
#
# Written to be easy to adapt into a macOS Automator action.
#
# find /path/to/shows -type f -name "*.mp4" -print0 | xargs -0 --no-run-if-empty -I% ./strip-html-from-descriptions.sh "%"
##

_echo=/usr/local/opt/coreutils/libexec/gnubin/echo
_grep=/usr/local/opt/grep/libexec/gnubin/grep
_mp4info=/usr/local/bin/mp4info
_mp4tags=/usr/local/bin/mp4tags
_read=/usr/bin/read
_sed=/usr/local/opt/gnu-sed/libexec/gnubin/sed

description=$($_mp4info "$1" | $_grep --color=never "^ Long Description:" | $_sed -r "s/^ Long Description: //")

# Clean-up real names after character names
description=$($_echo $description | $_sed -r "s/ \((guest star )?(\w+ )?\w+,? \w+\.?\)//g")

# Strip HTML from descriptions
description=$($_echo $description | $_sed -r "s/<\/?([^>])>//g")
description=$($_echo $description | $_sed -r "s/ &amp; / and /g")

# Fancy double-quotes
description=$($_echo $description | $_sed -r "s/ \"/ “/g")
description=$($_echo $description | $_sed -r "s/\"/”/g")

# Fancy single-quotes/apostrophes
description=$($_echo $description | $_sed -r "s/([a-zA-Z])'([a-zA-Z])/\1’\2/g")

# Em-dash all the things
description=$($_echo $description | $_sed -r "s/([a-zA-Z])\s?---?\s?([a-zA-Z])/\1 — \2/g")

$_echo "DESCRIPTION for $1:"
$_echo " "
$_echo $description
$_echo "------------------------------------------------------------"
$_read -p "Press any key to continue, or press Control+C to cancel. " x;

# Write the data back to the file
$_echo "Updating long description..."
$_mp4tags -longdesc "$description" "$1"

$_echo "Updating short description..."
$_mp4tags -description "$description" "$1"

$_echo "Removing some nuisance tags..."
$_mp4tags -r eE "$1"
