# Daily Quote - Multi-Platform Project

A beautifully designed daily quote application with iOS app and FastAPI backend server.

## 📱 Project Structure

```
daily-quote/
├── 📱 daily-quote/           # iOS App (Swift/SwiftUI)
│   ├── daily-quote/          # Main app source code
│   ├── daily-quote.xcodeproj # Xcode project file
│   ├── Assets.xcassets/      # App icons & background images
│   └── share-image/          # Source images for backgrounds
│
├── 🚀 backend/               # FastAPI Server (Python)
│   ├── app/                  # FastAPI application code
│   ├── data/                 # Quote database (JSON)
│   ├── api_design.md         # API documentation
│   ├── requirements.txt      # Python dependencies
│   ├── FASTAPI_SUCCESS.md    # Server setup guide
│   ├── simple_server.py      # Quick start server
│   └── README.md             # Backend documentation
│
└── README.md                 # This file - project overview
```

## 🚀 Quick Start

### iOS App
1. Open `daily-quote/daily-quote.xcodeproj` in Xcode
2. Build and run on iOS Simulator or device

### Backend Server  
1. Navigate to backend directory: `cd backend`
2. Install dependencies: `pip install -r requirements.txt`
3. Start server: `python simple_server.py`
4. Visit: `http://localhost:8000/docs`

## ✨ Features

### iOS App
- 📖 **Daily Inspirational Quotes** with beautiful backgrounds
- 🎨 **9 Stunning Background Themes** (coffee, mountains, ocean, etc.)
- 🤖 **AI Chat Integration** for philosophical discussions
- 🌍 **Multi-language Support** (English, Spanish, Chinese)
- 📱 **Modern SwiftUI Design** with animations
- 📊 **Smart Categorization** (success, motivation, wisdom, etc.)
- ❤️ **Favorites System** to save beloved quotes
- 📤 **Share Beautiful Quote Images** on social media

### Backend API
- 🚀 **FastAPI REST API** with automatic documentation
- 🧠 **Smart Quote Engine** with categorization
- 🤖 **AI Chat Service** for contextual conversations
- 🌐 **Multi-language API** support
- 📊 **Health Monitoring** and analytics
- ⚡ **High Performance** async architecture

## 🔗 Integration

The iOS app and backend share the same quote database and can work together:
- **Standalone Mode**: iOS app works independently with local quotes
- **Connected Mode**: iOS app can integrate with backend API for enhanced features
- **Shared Data**: Both use the same `QuoteData.json` format

## 📚 Documentation

- **iOS Setup**: See `daily-quote/README_AI_INTEGRATION.md`
- **Backend Setup**: See `backend/README.md`
- **API Documentation**: See `backend/api_design.md`
- **Background Images**: See `daily-quote/README_BACKGROUND_IMAGES.md`

## 🛠 Technologies

**iOS App:**
- SwiftUI for modern UI
- Combine for reactive programming
- Core Graphics for image generation
- OpenAI integration for AI chat

**Backend:**
- FastAPI for REST API
- Pydantic for data validation
- SQLAlchemy for database (optional)
- OpenAI API for enhanced AI features

## 🎯 Next Steps

1. **Development**: Both iOS and backend can be developed independently
2. **Integration**: Connect iOS app to backend API for cloud features
3. **Deployment**: Deploy backend to cloud, distribute iOS app via App Store
4. **Enhancement**: Add user accounts, analytics, and social features

---

**Note**: This clean structure separates platform-specific code while maintaining shared data and documentation. 