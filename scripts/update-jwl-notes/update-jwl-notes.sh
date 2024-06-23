#!/bin/bash

# Check if the zip file path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <path_to_zip_file>"
    exit 1
fi

# Paths
ZIP_FILE="$1"
UNZIP_DIR="/tmp/unzipped_jwlibrary"
NEW_ZIP_PATH="/tmp/UpdatedBackup.jwlibrary"
DB_PATH="$UNZIP_DIR/userData.db"

# Create the unzip directory if it does not exist
mkdir -p "$UNZIP_DIR"

# Step 1: Unzip the file
echo "Unzipping the file..."
unzip -o "$ZIP_FILE" -d "$UNZIP_DIR"

# Step 2: Verify the database file exists
if [ ! -f "$DB_PATH" ]; then
    echo "Database file not found at path: $DB_PATH"
    exit 1
fi

# Step 3: Run the Node.js script to process the database
echo "Processing the database with Node.js script..."
node update-jwl-notes.js "$DB_PATH"

# Step 4: Create a new zip file with the modified SQLite database
echo "Creating a new zip file with the modified database..."
cd "$UNZIP_DIR" || exit
zip -r "$NEW_ZIP_PATH" .

echo "Database updated and new zip file created at $NEW_ZIP_PATH"
