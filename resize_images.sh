#!/bin/bash

# Image Resize Script for Daily Quote App
echo "📐 Resizing images for optimal performance..."

if [ $# -eq 0 ]; then
    echo "Usage: $0 <source_folder> [output_folder]"
    echo "Example: $0 ~/Downloads/my_images/ ~/Downloads/resized_images/"
    exit 0
fi

SOURCE_FOLDER="$1"
OUTPUT_FOLDER="${2:-${SOURCE_FOLDER}/resized}"

# Check if ImageMagick is available
if ! command -v convert &> /dev/null; then
    echo "❌ ImageMagick not found. Install with: brew install imagemagick"
    exit 1
fi

# Create output folder
mkdir -p "$OUTPUT_FOLDER"

echo "📂 Source: $SOURCE_FOLDER"
echo "📂 Output: $OUTPUT_FOLDER"
echo ""

# List of images to resize
images=("bg_coffee" "bg_activity" "bg_coding" "bg_sunset" "bg_clouds" "bg_night" "bg_rain" "bg_ocean" "bg_mountains")

for img in "${images[@]}"; do
    # Look for the image with different extensions
    source_file=""
    for ext in "jpg" "jpeg" "png" "JPG" "JPEG" "PNG"; do
        if [ -f "$SOURCE_FOLDER/${img}.${ext}" ]; then
            source_file="$SOURCE_FOLDER/${img}.${ext}"
            break
        fi
    done
    
    if [ -n "$source_file" ]; then
        output_file="$OUTPUT_FOLDER/${img}.jpg"
        
        # Resize to 1080x1080 (square format for quote sharing)
        convert "$source_file" -resize 1080x1080^ -gravity center -extent 1080x1080 -quality 85 "$output_file"
        
        echo "✅ Resized: ${img} → ${output_file}"
    else
        echo "❌ Not found: ${img}.*"
    fi
done

echo ""
echo "🎉 Resizing complete!"
echo "📁 Resized images are in: $OUTPUT_FOLDER"
echo "📋 Now run: ./daily-quote/copy_images.sh \"$OUTPUT_FOLDER\"" 