#!/bin/bash

echo "🔍 Verifying Asset Catalog Setup..."
echo ""

# Check if all required imagesets exist
imagesets=("bg_coffee" "bg_mountains" "bg_ocean" "bg_rain" "bg_clouds" "bg_activity" "bg_night" "bg_coding" "bg_sunset")

echo "📁 Checking imageset folders:"
for imageset in "${imagesets[@]}"; do
    folder="daily-quote/Assets.xcassets/${imageset}.imageset"
    if [ -d "$folder" ]; then
        echo "✅ $imageset.imageset exists"
    else
        echo "❌ $imageset.imageset missing"
    fi
done

echo ""
echo "🖼️ Checking image files:"
for imageset in "${imagesets[@]}"; do
    image_file="daily-quote/Assets.xcassets/${imageset}.imageset/${imageset}.jpg"
    if [ -f "$image_file" ]; then
        size=$(ls -lh "$image_file" | awk '{print $5}')
        echo "✅ ${imageset}.jpg exists (${size})"
    else
        echo "❌ ${imageset}.jpg missing"
    fi
done

echo ""
echo "📄 Checking Contents.json files:"
for imageset in "${imagesets[@]}"; do
    json_file="daily-quote/Assets.xcassets/${imageset}.imageset/Contents.json"
    if [ -f "$json_file" ]; then
        if jq empty "$json_file" 2>/dev/null; then
            echo "✅ ${imageset} Contents.json valid"
        else
            echo "⚠️ ${imageset} Contents.json invalid JSON"
        fi
    else
        echo "❌ ${imageset} Contents.json missing"
    fi
done

echo ""
echo "🎯 Asset verification complete!" 