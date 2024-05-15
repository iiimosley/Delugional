#!/bin/bash

# Load environment variables and flags
source ./shared/_setup.sh "$@"

# Set source and target directories
source_dir="$SFM_SAMPLES_DIR"
target_dir="$DELUGE_SD_DIR/SAMPLES/SfM"

cd "$source_dir"

# Find directories ending with "Kits"
find . -type d -path '*/WAV/*Kits' | while read -r dir; do
  # Get the immediate root DfM directory for the found "*Kits" subdirectory
  # & remove " From Mars" for the new deluge sample directory name
  ### E.G. "808 From Mars/WAV/02. Kits" -> "808"
  child_dir=$(echo "$dir" | cut -d '/' -f 2)
  new_dir_name=${child_dir//" From Mars"/}

  echo "############################################"
  echo "       Migrating $new_dir_name Kits         "
  echo "############################################"
  
  # Create a new directory in the samples destination
  sample_dir="$target_dir/$new_dir_name"
  echo "$dir --> $sample_dir"

  if [ "$is_test" != "1" ]; then
    mkdir -p "$sample_dir"
  fi

  find "$dir" -type d -exec sh -c '(ls -p "{}"|grep />/dev/null)||echo "{}"' \; | while read -r kit_dir; do
    # Model a new directory name from sub path
    new_dir=`echo "$kit_dir" | awk '{
      gsub(/.*\/WAV\/((Drums|One Shots)\/)?([0-9]*\. )?Kits\//, "");
      print
    }' |                       # <-- Remove path prefix
    tr '/' ' ' |               # <-- Replace slashes with spaces
    tr '&' '+' |               # <-- Replace ampersands with pluses (for XML path reads)
    sed -E 's/[0-9]{2}\.//g' | # <-- Remove any leading numbers
    tr -s ' ' |                # <-- Remove extra spaces
    awk '{$1=$1};1'`           # <-- Trim leading/trailing whitespace

    deluge_kit_dir="$sample_dir/$new_dir"
    echo "$kit_dir/* --> $deluge_kit_dir/"
    
    if [ "$is_test" != "1" ]; then
      ## TODO
      # - Remove trailing digits at end of wav file name
      # - Number any duplicate wav names (post-trailing digits removal)  

      # Copy the kit directory content to the new destination
      mkdir -p "$deluge_kit_dir"
      cp -R "$kit_dir"/*.wav "$deluge_kit_dir/"

      # Remove/merge any hidden files from resource forks
      dot_clean "$deluge_kit_dir"
    fi
  done
done
