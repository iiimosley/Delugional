#!/bin/bash

source ./shared/_setup.sh "$@"

# Directory to scan
dir="$DELUGE_SD_DIR/KITS"
tmp_dir=./.tmp

mkdir -p $tmp_dir

# Find all XML files in the directory
find "$dir" -type f -iname "*.xml" | while read -r file_path; do
  file=$(basename "$file_path")
  echo "Scanning $file"

  sound_count=$(xmlstarlet sel -t -v "count(//sound)" "$file_path")

  # Extract each <sound> tag into its own XML file
  for ((i=1; i<=$sound_count; i++)); do
    xmlstarlet sel -t -c "(//sound)[$i]" "$file_path" > "$tmp_dir/$file\_sound_$i.xml"
  done

  # # Use xmlstarlet to extract the <sound> tags and save to a temporary file
  # xmlstarlet sel -t -c "//sound" "$file_path" > "$tmp_dir/$file"
done

# # Compare the temporary files
# find "$tmp_dir" -type f -iname "*.xml" | while read -r file1; do
#   find "$tmp_dir" -type f -iname "*.xml" | while read -r file2; do
#     if [ "$file1" != "$file2" ]; then
#       # Use xmldiff to compare the files
#       xmldiff "$file1" "$file2"
#     fi
#   done
# done

# # Clean up the temporary files
# rm -rf $tmp_dir
