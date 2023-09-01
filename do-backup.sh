# A bash script to backup Focus To-Do Chrome extension files
#!/bin/bash

# Create backup directory
base_dir="/home/bag/focus-to-do_backup"
today=$(date +'%Y-%m-%d')
backup_dir="${base_dir}/${today}"
mkdir $backup_dir

chrome_dir="/home/bag/.config/google-chrome"

# Cannot use list from find because of space characters in extension folder names
#paths_list=$(find $chrome_dir -name "*ngceodoilcgpmkijopinlkmohnfifjfb*")

# Declare a string array with type
declare -a relPathsArray=(
"Default/IndexedDB/chrome-extension_ngceodoilcgpmkijopinlkmohnfifjfb_0.indexeddb.leveldb"
"Default/Local Extension Settings/ngceodoilcgpmkijopinlkmohnfifjfb"
"Default/Sync Extension Settings/ngceodoilcgpmkijopinlkmohnfifjfb"
"Default/Extensions/ngceodoilcgpmkijopinlkmohnfifjfb"
"extensions_crx_cache/ngceodoilcgpmkijopinlkmohnfifjfb_1.856545d6bcb2063e33bddbd9365c86c6e1df8a673a6cf6aa46e42c2d9bf9698d"
)

# Loop through needed extension directories
for rel_path in "${relPathsArray[@]}"
  do
    part1=$(dirname "$rel_path")
    part2=$(basename "$rel_path")
#    echo "part1: $part1"
#    echo "part2: $part2"

    # Create destinaiton directory tree
    dest="${backup_dir}/${part1}"
    echo -e "dest: $dest"
    mkdir -p "$dest"

    # Copy files from chrome directory to created backup directory
    src="${chrome_dir}/${rel_path}"
    echo -e "src: $src\n\n"
    cp -a "${src}" "${dest}/"
  done
