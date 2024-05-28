#!/bin/bash

# Function to check if a file contains the word "test"
check_file_content() {
    local file=$1
    if grep -iq "test" "$file"; then
        return 0
    else
        return 1
    fi
}

# Function to check files and directories
check_files_and_dirs() {
    local dir=$1
    local success=1
    local found_files=()
    local script_name=$(basename "$0")

    # Traverse the directory and its subdirectories
    while IFS= read -r -d '' file; do
        local basename=$(basename "$file")

        # Exclude the script itself
        if [[ "$basename" == "$script_name" ]]; then
            continue
        fi

        # Exclude .git directories
        if [[ "$file" == *".git"* ]]; then
            continue
        fi

        # Check if the file name contains the word "test"
        if [[ "$basename" == *test* ]]; then
            success=0
            found_files+=("$file")
            continue
        fi

        # Check if the file content contains the word "test"
        if check_file_content "$file"; then
            success=0
            found_files+=("$file")
            continue
        fi
    done < <(find "$dir" -type f -print0)

    # Display found files if any
    if [ "$success" -eq 0 ]; then
        echo "Found files:"
        for file in "${found_files[@]}"; do
            echo "$file"
        done
    fi

    return $success
}

# Directory to be analyzed
directory_to_check="$(pwd)"

# Run the check function
if check_files_and_dirs "$directory_to_check"; then
    echo "Success"
else
    echo "Not Success"
fi
