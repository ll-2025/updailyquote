#!/bin/bash

# Fix User Images Script
echo "🎨 Fixing and copying your beautiful images..."

SOURCE_FOLDER="share-image"

# Check if source folder exists
if [ ! -d "$SOURCE_FOLDER" ]; then
    echo "❌ Error: share-image folder not found"
    echo "📁 Current directory contents:"
    ls -la
    exit 1
fi

echo "📂 Found share-image folder!"
echo "📋 Contents:"
ls -la "$SOURCE_FOLDER"
echo ""

# Copy images directly using individual commands to avoid array issues
copied=0
not_found=0

echo "🔄 Processing images..."

# Define image mappings and copy them one by one
copy_image() {
    local source_name="$1"
    local target_name="$2"
    local source_file="$SOURCE_FOLDER/$source_name"
    
    if [ -f "$source_file" ]; then
        # Extract the target base name (without extension)
        target_base=$(echo "$target_name" | sed 's/\.jpg$//')
        dest_folder="daily-quote/daily-quote/Assets.xcassets/${target_base}.imageset/"
        
        if [ -d "$dest_folder" ]; then
            # Copy the image with the correct name
            cp "$source_file" "${dest_folder}${target_name}"
            echo "✅ Copied: $source_name → ${dest_folder}${target_name}"
            ((copied++))
        else
            echo "⚠️  Warning: Destination folder not found: $dest_folder"
        fi
    else
        echo "❌ Not found: $source_name"
        ((not_found++))
    fi
}

# Copy each image
copy_image "coffee.jpeg" "bg_coffee.jpg"
copy_image "mountain.jpeg" "bg_mountains.jpg"
copy_image "Ocean.jpeg" "bg_ocean.jpg"
copy_image "rainny day.jpeg" "bg_rain.jpg"
copy_image "sky.jpeg" "bg_clouds.jpg"
copy_image "sports.jpeg" "bg_activity.jpg"
copy_image "star.jpeg" "bg_night.jpg"
copy_image "study.jpeg" "bg_coding.jpg"
copy_image "sunset.jpeg" "bg_sunset.jpg"

echo ""
echo "📊 Summary:"
echo "✅ Successfully copied: $copied images"
echo "❌ Not found: $not_found images"

if [ $copied -gt 0 ]; then
    echo ""
    echo "🎉 Images copied successfully!"
    echo "👉 Now build and run your app to see the new backgrounds!"
    echo "📱 Go to the quote sharing feature and select different styles"
    
    # Show what's now in the asset folders
    echo ""
    echo "📁 Asset folders now contain:"
    for target_name in "bg_coffee.jpg" "bg_mountains.jpg" "bg_ocean.jpg" "bg_rain.jpg" "bg_clouds.jpg" "bg_activity.jpg" "bg_night.jpg" "bg_coding.jpg" "bg_sunset.jpg"; do
        target_base=$(echo "$target_name" | sed 's/\.jpg$//')
        dest_folder="daily-quote/daily-quote/Assets.xcassets/${target_base}.imageset/"
        if [ -f "${dest_folder}${target_name}" ]; then
            echo "✅ ${dest_folder}${target_name}"
        fi
    done
fi 