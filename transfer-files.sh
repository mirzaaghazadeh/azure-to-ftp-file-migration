#!/bin/bash

# CSV file to be parsed
csv_file="file_data.csv"

# FTP credentials and server information
ftp_user="username"
ftp_pass="password"
ftp_host="ip-or-domain"
ftp_remote_prefix=""  # The prefix for the remote directory , it can be empty

# Check if the file exists
if [[ ! -f "$csv_file" ]]; then
    echo "CSV file not found!"
    exit 1
fi

# Read each line of the CSV (skipping header)
tail -n +2 "$csv_file" | while IFS=, read -r file_path url; do
    # Remove quotes around file path and url (if any)
    file_path=$(echo "$file_path" | tr -d '"')
    url=$(echo "$url" | tr -d '"')

    # Create directory if it doesn't exist
    dir_path=$(dirname "$file_path")
    if [[ ! -d "$dir_path" ]]; then
        echo "Creating directory: $dir_path"
        mkdir -p "$dir_path"
    fi

    # Download the file using curl if URL is provided
    if [[ -n "$url" ]]; then
        echo "Downloading from $url to $file_path"
        curl -o "$file_path" "$url"

        # Check if the download was successful
        if [[ $? -eq 0 ]]; then
            echo "File saved successfully to $file_path"
            
            # Construct the remote directory structure, prepend the prefix
            remote_dir="$ftp_remote_prefix$(dirname "$file_path" | sed 's|/|_|g')"  # Replace '/' with '_'

            # FTP file transfer using lftp
            echo "Syncing file $file_path to FTP server at $remote_dir"
            lftp -u "$ftp_user,$ftp_pass" -e "put $file_path -o /$remote_dir/$(basename $file_path); quit" ftp://$ftp_host

            # Check if the file upload was successful
            if [[ $? -eq 0 ]]; then
                echo "File uploaded successfully to FTP server"
                
                # Remove the file from the local system
                echo "Removing $file_path from local system"
                rm "$file_path"
            else
                echo "Failed to upload $file_path to FTP server"
            fi
        else
            echo "Failed to download $url"
        fi
    fi
done
