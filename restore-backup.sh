# A bash script to restore Focus To-Do Chrome extension files from a backup
# Usage: bash restore-backup.sh backup-folder-name/
#!/bin/bash

# Build path to backup directory
base_dir=$(pwd)
backup_dir="${base_dir}/$1"
echo "$backup_dir"

chrome_dir="/home/bag/.config/google-chrome"
#Uncomment next line for macos
chrome_dir="/Users/bag/Library/Application Support/Google/Chrome"

# Copy files from backup directory to chrome directory
cp -a "${backup_dir}/." "${chrome_dir}/"
