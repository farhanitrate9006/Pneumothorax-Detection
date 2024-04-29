#!/bin/bash

# Define folder paths
png_images_folder="png_images"
train_csv="train.csv"
test_csv="test.csv"

data_folder="dataset"
train_folder="$data_folder/train"
test_folder="$data_folder/test"

# Create folders if they don't exist
mkdir -p "$train_folder/Control"
mkdir -p "$train_folder/Disease"
mkdir -p "$test_folder/Control"
mkdir -p "$test_folder/Disease"

# Function to read CSV file and copy images accordingly
populate_folders() {
    csv_file="$1"
    destination_folder="$2"
    
    # Skip the first line (header) of the CSV file
    { read; while IFS=, read -r new_filename dummy has_pneumo; do
        # echo "Processing $new_filename $has_pneumo"
        if [[ "$has_pneumo" == "0" ]]; then
            cp "$png_images_folder/$new_filename" "$destination_folder/Control/$new_filename"
        elif [[ "$has_pneumo" == "1" ]]; then
            cp "$png_images_folder/$new_filename" "$destination_folder/Disease/$new_filename"
        else
            echo "Invalid CSV file format"
            exit 1
        fi
    done; } < "$csv_file"
}

# Populate train folders
populate_folders "$train_csv" "$train_folder"

# Populate test folders
populate_folders "$test_csv" "$test_folder"

echo "Folders populated successfully!"
