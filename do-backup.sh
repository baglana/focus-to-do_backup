# A bash script to backup Focus To-Do Chrome extension files
#!/bin/bash

# Check if dir with today's date exists
base_dir=$(pwd)
username=$(whoami)
today=$(date +'%Y-%m-%d')
backup_dir="${base_dir}/${today}"

if [ -d $backup_dir ]
then
  echo "Directory ${today}/ exists. No new backup done."
else
  echo "Starting backup..."

  # Create backup directory
  mkdir $backup_dir

  chrome_dir="/home/${username}/.config/google-chrome"
  # Uncomment next line for macos
  chrome_dir="/Users/${username}/Library/Application Support/Google/Chrome"

  profile_name="Default"

  # Cannot use list from find because of space characters in extension folder names
  #paths_list=$(find $chrome_dir -name "*ngceodoilcgpmkijopinlkmohnfifjfb*")

  # Declare a string array with type
  declare -a rDelPathsArray=(
  "${profile_name}/IndexedDB/chrome-extension_ngceodoilcgpmkijopinlkmohnfifjfb_0.indexeddb.leveldb"
  "${profile_name}/Local Extension Settings/ngceodoilcgpmkijopinlkmohnfifjfb"
  "${profile_name}/Sync Extension Settings/ngceodoilcgpmkijopinlkmohnfifjfb"
  #"${profile_name}/Extensions/ngceodoilcgpmkijopinlkmohnfifjfb"
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
fi
