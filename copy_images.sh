#!/bin/bash

# Copy Background Images Script
# This script helps you copy your background images to the correct locations in the Xcode project

echo "🎨 Daily Quote - Background Images Setup"
echo "========================================"
echo

# Check if we're in the right directory
if [ ! -d "daily-quote/daily-quote/Assets.xcassets" ]; then
    echo "❌ Error: Please run this script from the daily-quote project root directory"
    exit 1
fi

echo "📁 Available image asset folders:"
ls -la daily-quote/daily-quote/Assets.xcassets/bg_*.imageset/ 2>/dev/null | grep "^d" | awk '{print $NF}' | sort

echo
echo "📋 Image mapping guide:"
echo "bg_coffee.jpg    → Coffee/Study scenes (woman with coffee)"
echo "bg_mountains.jpg → Mountain landscapes"
echo "bg_ocean.jpg     → Ocean scenes"
echo "bg_rain.jpg      → Rainy day scenes (rain on window)"
echo "bg_clouds.jpg    → Sky with clouds"
echo "bg_activity.jpg  → Activity/Sports (basketball player)"
echo "bg_night.jpg     → Galaxy/Night sky (starry sky)"
echo "bg_coding.jpg    → Coding/Work scenes (person coding)"
echo "bg_sunset.jpg    → Sunset colors"
echo "bg_gradient.jpg  → Abstract gradient (create if needed)"
echo "bg_minimal.jpg   → Minimal design (create if needed)"
echo "bg_nature.jpg    → Nature scene (can use mountain image)"

echo
echo "📖 Instructions:"
echo "1. Save your images with the exact names shown above"
echo "2. Place them in a folder accessible to this script"
echo "3. Run: ./copy_images.sh <path_to_your_images_folder>"
echo
echo "Example: ./copy_images.sh ~/Downloads/quote_backgrounds/"

# If no argument provided, show instructions and exit
if [ $# -eq 0 ]; then
    echo
    echo "ℹ️  Usage: $0 <source_folder>"
    exit 0
fi

SOURCE_FOLDER="$1"

# Check if source folder exists
if [ ! -d "$SOURCE_FOLDER" ]; then
    echo "❌ Error: Source folder '$SOURCE_FOLDER' does not exist"
    exit 1
fi

echo
echo "🚀 Starting image copy process..."
echo "Source folder: $SOURCE_FOLDER"
echo

# List of image mappings
declare -a images=("bg_coffee" "bg_mountains" "bg_ocean" "bg_rain" "bg_clouds" "bg_activity" "bg_night" "bg_coding" "bg_sunset" "bg_gradient" "bg_minimal" "bg_nature")

copied=0
not_found=0

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
        dest_folder="daily-quote/daily-quote/Assets.xcassets/${img}.imageset/"
        if [ -d "$dest_folder" ]; then
            # Copy with .jpg extension regardless of source extension
            cp "$source_file" "${dest_folder}${img}.jpg"
            echo "✅ Copied: ${img} → ${dest_folder}"
            ((copied++))
        else
            echo "⚠️  Warning: Destination folder not found: $dest_folder"
        fi
    else
        echo "❌ Not found: ${img}.*"
        ((not_found++))
    fi
done

echo
echo "📊 Summary:"
echo "✅ Successfully copied: $copied images"
echo "❌ Not found: $not_found images"

if [ $copied -gt 0 ]; then
    echo
    echo "🎉 Images copied successfully!"
    echo "👉 Now build and run your app to see the new backgrounds!"
    echo "📱 Go to the quote sharing feature and select different styles"
fi

echo
echo "📝 Note: If some images were not found, you can manually copy them to:"
echo "   daily-quote/daily-quote/Assets.xcassets/bg_[name].imageset/"
echo "   Make sure to name them exactly as: bg_[name].jpg" 