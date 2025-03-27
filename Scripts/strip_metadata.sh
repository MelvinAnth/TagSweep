#!/bin/bash

# Check if a file path is provided
if [ $# -eq 0 ]; then
    echo "Error: No file path provided"
    echo "Usage: $0 <file_path>"
    exit 1
fi

# Get the file path from command line argument
file_path="$1"

# Check if the file exists
if [ ! -f "$file_path" ]; then
    echo "Error: File '$file_path' does not exist"
    exit 1
fi

# Strip all metadata using exiftool
exiftool -all= "$file_path"

# Check if exiftool command was successful
if [ $? -eq 0 ]; then
    echo "Successfully stripped metadata from '$file_path'"
else
    echo "Error: Failed to strip metadata from '$file_path'"
    exit 1
fi