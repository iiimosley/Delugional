#!/bin/bash

# Load environment variables
. .env

is_test="0"

# Check for --test flag
for arg in "$@"
do
    if [ "$arg" == "--test" ]; then
        is_test=1
    fi
done

if [ "$is_test" == "1" ]; then
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo "!!                                                 !!"
  echo "!!   Test flag is set ---- Running in test mode    !!"
  echo "!!      No files will be written to SD Card        !!"
  echo "!!                                                 !!"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

  sleep 2
fi

export is_test
