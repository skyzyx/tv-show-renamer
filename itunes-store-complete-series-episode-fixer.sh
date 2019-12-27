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
# find /path/to/shows -type f -name "*.m4v" -print0 | xargs -0 --no-run-if-empty -I% ./itunes-store-complete-series-episode-fixer.sh "%"
##

_cut=/usr/local/opt/coreutils/libexec/gnubin/cut
_echo=/usr/local/opt/coreutils/libexec/gnubin/echo
_grep=/usr/local/opt/grep/libexec/gnubin/grep
_mp4info=/usr/local/bin/mp4info
_mp4tags=/usr/local/bin/mp4tags
_read=/usr/bin/read
_sed=/usr/local/opt/gnu-sed/libexec/gnubin/sed
_xargs=/usr/local/opt/findutils/libexec/gnubin/xargs

title=$($_mp4info "$1" | $_grep --color=never "^ Name:" | $_sed -r "s/^ Name: //")
title=$($_echo $title | $_sed -r "s/ & / and /g")

# Fancy double-quotes
title=$($_echo $title | $_sed -r "s/ \"/ “/g")
title=$($_echo $title | $_sed -r "s/\"/”/g")

# Fancy single-quotes/apostrophes
title=$($_echo $title | $_sed -r "s/([a-zA-Z])'([a-zA-Z])/\1’\2/g")

# Em-dash all the things
title=$($_echo $title | $_sed -r "s/([a-zA-Z])\s?---?\s?([a-zA-Z])/\1 — \2/g")

# Grab Season and Episode identifiers
season=$($_echo $title | $_cut -d ',' -f1 | $_cut -d ' ' -f2)
episode=$($_echo $title | $_cut -d ',' -f2 | $_cut -d ' ' -f3 | $_cut -d ':' -f1)

# Strip Season and Episode off the title
newtitle=$($_echo $title | $_cut -d ':' -f2-9 | $_xargs $_echo -n)

$_echo "SEASON for $1:"
$_echo $season
$_echo " "
$_echo "EPISODE for $1:"
$_echo $episode
$_echo " "
$_echo "TITLE for $1:"
$_echo $newtitle
$_echo "------------------------------------------------------------"
$_read -p "Press any key to continue, or press Control+C to cancel. " x;

# Write the data back to the file
$_echo "Updating season..."
$_mp4tags -season "$season" "$1"

$_echo "Updating episode..."
$_mp4tags -episode "$episode" "$1"

# $_echo "Updating title..."
# $_mp4tags -song "$newtitle" "$1"
