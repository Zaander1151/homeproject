#!/bin/bash

# Script to extract all zip files in Warhammer-40K directory and remove them after extraction
# Each zip is extracted in its current directory

BASE_DIR="/mnt/storage/models/Warhammer-40K"
LOG_FILE="/home/hazzard/homeproject/warhammer_extraction.log"
ERROR_LOG="/home/hazzard/homeproject/warhammer_extraction_errors.log"

# Initialize logs
echo "Starting extraction at $(date)" > "$LOG_FILE"
echo "Errors during extraction at $(date)" > "$ERROR_LOG"

# Counter variables
total=0
success=0
failed=0

# Find all zip files
echo "Finding all zip files..." | tee -a "$LOG_FILE"
mapfile -t zip_files < <(find "$BASE_DIR" -type f -name "*.zip")
total=${#zip_files[@]}

echo "Found $total zip files to extract" | tee -a "$LOG_FILE"
echo ""

# Process each zip file
for zip_file in "${zip_files[@]}"; do
    # Get directory containing the zip file
    dir_name=$(dirname "$zip_file")
    file_name=$(basename "$zip_file")

    echo "Processing: $file_name in $dir_name" | tee -a "$LOG_FILE"

    # Extract zip file in its current directory
    if unzip -q -o "$zip_file" -d "$dir_name" 2>> "$ERROR_LOG"; then
        echo "  ✓ Extracted successfully" | tee -a "$LOG_FILE"

        # Remove the zip file after successful extraction
        if rm "$zip_file" 2>> "$ERROR_LOG"; then
            echo "  ✓ Removed zip file" | tee -a "$LOG_FILE"
            ((success++))
        else
            echo "  ✗ Failed to remove zip file" | tee -a "$LOG_FILE" "$ERROR_LOG"
            ((failed++))
        fi
    else
        echo "  ✗ Extraction failed" | tee -a "$LOG_FILE" "$ERROR_LOG"
        ((failed++))
    fi

    # Progress indicator
    processed=$((success + failed))
    if ((processed % 50 == 0)); then
        echo "Progress: $processed/$total files processed ($success successful, $failed failed)" | tee -a "$LOG_FILE"
    fi
done

# Final summary
echo "" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
echo "Extraction Complete at $(date)" | tee -a "$LOG_FILE"
echo "Total files: $total" | tee -a "$LOG_FILE"
echo "Successfully extracted and removed: $success" | tee -a "$LOG_FILE"
echo "Failed: $failed" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"

# Show error log if there were failures
if ((failed > 0)); then
    echo ""
    echo "Errors occurred. Check $ERROR_LOG for details"
fi
