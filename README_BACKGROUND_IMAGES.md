# Background Images Setup

This document explains how to add your beautiful background images to the Daily Quote app.

## Image Mapping

Based on your provided images, here's how they should be mapped to the background styles:

1. **Coffee/Study Scene** (woman with coffee) → `bg_coffee.jpg`
2. **Mountains** (mountain landscape) → `bg_mountains.jpg`
3. **Ocean** (blue ocean scene) → `bg_ocean.jpg`
4. **Rainy Day** (rain on window) → `bg_rain.jpg`
5. **Clouds** (sky with clouds) → `bg_clouds.jpg`
6. **Activity/Sports** (basketball player) → `bg_activity.jpg`
7. **Galaxy/Night** (starry night sky) → `bg_night.jpg`
8. **Coding/Work** (person coding) → `bg_coding.jpg`
9. **Sunset** (sunset colors) → `bg_sunset.jpg`

## How to Add Images

### Step 1: Save Your Images
Save each of your images with the following exact names:
- `bg_coffee.jpg` (for coffee/study scenes)
- `bg_mountains.jpg` (for mountain landscapes)
- `bg_ocean.jpg` (for ocean scenes)
- `bg_rain.jpg` (for rainy day scenes)
- `bg_clouds.jpg` (for cloud scenes)
- `bg_activity.jpg` (for activity/sports scenes)
- `bg_night.jpg` (for galaxy/night scenes)
- `bg_coding.jpg` (for coding/work scenes)
- `bg_sunset.jpg` (for sunset scenes)
- `bg_gradient.jpg` (create a simple gradient as fallback)
- `bg_minimal.jpg` (create a minimal design)
- `bg_nature.jpg` (use a nature scene, can be the mountain one)

### Step 2: Add to Xcode Project
Copy each image file to its corresponding folder in the Assets:

1. Copy `bg_coffee.jpg` to `daily-quote/daily-quote/Assets.xcassets/bg_coffee.imageset/`
2. Copy `bg_mountains.jpg` to `daily-quote/daily-quote/Assets.xcassets/bg_mountains.imageset/`
3. Copy `bg_ocean.jpg` to `daily-quote/daily-quote/Assets.xcassets/bg_ocean.imageset/`
4. Copy `bg_rain.jpg` to `daily-quote/daily-quote/Assets.xcassets/bg_rain.imageset/`
5. Copy `bg_clouds.jpg` to `daily-quote/daily-quote/Assets.xcassets/bg_clouds.imageset/`
6. Copy `bg_activity.jpg` to `daily-quote/daily-quote/Assets.xcassets/bg_activity.imageset/`
7. Copy `bg_night.jpg` to `daily-quote/daily-quote/Assets.xcassets/bg_night.imageset/`
8. Copy `bg_coding.jpg` to `daily-quote/daily-quote/Assets.xcassets/bg_coding.imageset/`
9. Copy `bg_sunset.jpg` to `daily-quote/daily-quote/Assets.xcassets/bg_sunset.imageset/`
10. Copy `bg_gradient.jpg` to `daily-quote/daily-quote/Assets.xcassets/bg_gradient.imageset/`
11. Copy `bg_minimal.jpg` to `daily-quote/daily-quote/Assets.xcassets/bg_minimal.imageset/`
12. Copy `bg_nature.jpg` to `daily-quote/daily-quote/Assets.xcassets/bg_nature.imageset/`

### Step 3: Image Requirements
- **Format**: JPG or PNG
- **Size**: Recommended 1080x1080 pixels (square format for Instagram sharing)
- **Quality**: High resolution for best results

### Step 4: Test the App
After adding the images:
1. Build and run the app
2. Go to the quote sharing feature
3. Try different background styles to see your images

## Fallback Behavior
If an image is not found, the app will automatically fall back to a gradient background that matches the theme of the selected style.

## Background Styles Available

The app now includes these background options:
- **Gradient** - Abstract colorful gradient
- **Minimal** - Clean, simple design
- **Nature** - Natural landscapes
- **Abstract** - Artistic abstract designs
- **Sunset** - Beautiful sunset colors
- **Ocean** - Ocean and water scenes
- **Galaxy** - Space and night sky
- **Geometric** - Modern geometric patterns
- **Rainy Day** - Cozy rainy atmospheres
- **Study Home** - Coffee and study scenes
- **Coffee** - Coffee shop vibes
- **Mountains** - Mountain landscapes
- **Activity** - Sports and active scenes
- **Clouds** - Sky and cloud scenes
- **Coding** - Work and coding environments

Each style will now use your beautiful images as backgrounds for the quotes! 