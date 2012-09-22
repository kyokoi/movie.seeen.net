#!/bin/bash

RUBY_PATH=/usr/local/ruby-1.9.3-p125/bin/
SCRIPT_PATH=/usr/local/apps/movie_seen/tool

export MS_ENV=development
export MS_HOST=movie.seeen.net
export MS_ROOT=/usr/local/apps/movie_seen/tool

RUBY_HOME=/usr/local/ruby-1.9.3-p125/
PATH=/bin/:${RUBY_PATH}:${SCRIPT_PATH}:${RUBY_HOME}

COMMAND=$1
#if [ ! -e "${SCRIPT_PATH}/${COMMAND}" ]; then
#  echo "${SCRIPT_PATH}/${COMMAND}"
#  echo "This script must be needed to a argument command name."
#  echo "End of script."
#  exit 1
#fi


echo "`date '+%F %T'`	Start \"${COMMAND}\"" > /dev/stderr

ruby $COMMAND $2 $3 $4

echo "`date '+%F %T'`	End \"${COMMAND}\"" > /dev/stderr
