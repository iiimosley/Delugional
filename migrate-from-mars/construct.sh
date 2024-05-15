#!/bin/bash

# Load environment variables and flags
source ./shared/_setup.sh "$@"

sample_dir="$DELUGE_SD_DIR/SAMPLES/SfM"
kits_dir="$DELUGE_SD_DIR/KITS"

find "$sample_dir" -mindepth 2 -maxdepth 2 -type d | while read -r dir; do
    parent_dir=$(dirname "$dir" | xargs basename)
    child_dir=$(basename "$dir")
    kit_name=$(echo "$parent_dir $child_dir" | tr '/' ' ' | awk '!seen[$0]++')

    # Dedupe words in the kit name
    result=()
    read -a arr <<< "$kit_name"
    for word in ${arr[@]}; do
      if [[ ! $result[@] =~ $word ]]; then result+=($word); fi
    done
    kit_name=$(printf "%s " "${result[@]}" | sed 's/[[:space:]]*$//')

    # Create a new kit file in temporary directory
    mkdir -p .tmp
    kit_file=".tmp/$kit_name.xml"

    echo "Creating $kit_file"
    cp ./templates/kit/head.xml.sample "$kit_file"

    find "$dir" -type f -name "*.wav" | while read -r wav; do
        sound_name=$(basename "$wav" | sed 's/.wav//')
        end_ms=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$wav" | awk '{print int($1*1000+0.5)}')
        local_sample_path=$(echo "$wav" | sed "s|$DELUGE_SD_DIR/||")

        echo "--> Adding '$sound_name' sound for $local_sample_path ($end_ms ms)"

        # Create a sound_xml_block by copying the content of ./templates/sound.xml
        sound_xml_block=$(<./templates/kit/sound.xml.sample)

        # Replace {{SOUND_NAME}}, {{SAMPLE_PATH}}, and {{SAMPLE_END_MS}} with the actual values
        sound_xml_block=${sound_xml_block//SOUND_NAME/$sound_name}
        sound_xml_block=${sound_xml_block//SAMPLE_PATH/$local_sample_path}
        sound_xml_block=${sound_xml_block//SAMPLE_END_MS/$end_ms}

        # #### RUFF STUFF - xml(starlet) is not a fun package. Reverting to dumb soluton.
        # # Add the sound_xml_block to the <soundSources> in the $kit_file
        # xml esc "$kit_file"
        # xml ed -L -a '/kit/soundSources' -t elem -n sound -v "$sound_xml_block" "$kit_file"
        # xml fo -R -H "$kit_file"

        echo $sound_xml_block >> "$kit_file"
    done

    # Close tags on the kit file xml
    cat ./templates/kit/tail.xml.sample >> "$kit_file"

    # Format XML & send this on to the Deluge SD card
    xml fo "$kit_file" > "$kits_dir/$kit_name.xml"

    ### only create one kit if we are testing ###
    if [ "$is_test" == "1" ]; then
        echo "Test complete:" 
        echo "Review migrated Kit XML at $kits_dir/$kit_name.xml"
        echo "Review source Kit XML at $kit_file"
        break
    fi
done

if [ "$is_test" != "1" ]; then
    rm -rf .tmp
fi
