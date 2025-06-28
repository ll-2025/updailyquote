#!/bin/bash

# Create simple test images for verification
echo "🎨 Creating test images..."

# Create a temporary directory for test images
mkdir -p test_images

# Create simple colored squares as test images using ImageMagick (if available)
# If ImageMagick is not available, we'll create simple text files as placeholders

if command -v convert &> /dev/null; then
    echo "✅ ImageMagick found, creating colored test images..."
    
    # Create test images with different colors
    convert -size 1080x1080 xc:"#8B4513" test_images/bg_coffee.jpg      # Brown for coffee
    convert -size 1080x1080 xc:"#4682B4" test_images/bg_mountains.jpg   # Steel blue for mountains
    convert -size 1080x1080 xc:"#006994" test_images/bg_ocean.jpg       # Ocean blue
    convert -size 1080x1080 xc:"#708090" test_images/bg_rain.jpg        # Slate gray for rain
    convert -size 1080x1080 xc:"#87CEEB" test_images/bg_clouds.jpg      # Sky blue for clouds
    convert -size 1080x1080 xc:"#FF8C00" test_images/bg_activity.jpg    # Orange for activity
    convert -size 1080x1080 xc:"#191970" test_images/bg_night.jpg       # Midnight blue for night
    convert -size 1080x1080 xc:"#2F4F4F" test_images/bg_coding.jpg      # Dark slate gray for coding
    convert -size 1080x1080 xc:"#FF6347" test_images/bg_sunset.jpg      # Tomato for sunset
    
    echo "✅ Test images created in test_images/ folder"
    echo "📋 You can now run: ./daily-quote/copy_images.sh test_images/"
    
else
    echo "❌ ImageMagick not found. Please install it with: brew install imagemagick"
    echo "📝 Or manually add your images to the asset folders."
fi

echo ""
echo "🎯 Next steps:"
echo "1. Run: ./daily-quote/copy_images.sh test_images/"
echo "2. Build and test the app"
echo "3. Replace test images with your beautiful images" 