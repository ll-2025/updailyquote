#!/usr/bin/env python3
"""
Daily Quote FastAPI Server Startup Script
"""

import os
import sys
import asyncio
import uvicorn
from pathlib import Path

# Add the backend directory to Python path
sys.path.insert(0, str(Path(__file__).parent))

from app.config import settings
from app.main import app

def setup_directories():
    """Create necessary directories"""
    os.makedirs("storage/images", exist_ok=True)
    os.makedirs("logs", exist_ok=True)
    print("✅ Created necessary directories")

def check_dependencies():
    """Check if all required dependencies are available"""
    try:
        import fastapi
        import uvicorn
        import sqlalchemy
        import openai
        import redis
        print("✅ All dependencies are available")
        return True
    except ImportError as e:
        print(f"❌ Missing dependency: {e}")
        print("Please install dependencies with: pip install -r requirements.txt")
        return False

def show_startup_info():
    """Display startup information"""
    print("\n" + "="*60)
    print("🚀 Daily Quote FastAPI Server")
    print("="*60)
    print(f"📱 App Name: {settings.app_name}")
    print(f"🔖 Version: {settings.app_version}")
    print(f"🌍 Host: {settings.host}")
    print(f"🔌 Port: {settings.port}")
    print(f"🐛 Debug Mode: {settings.debug}")
    print(f"📊 Log Level: {settings.log_level}")
    print("\n📍 API Endpoints:")
    print(f"   🏠 Root: http://{settings.host}:{settings.port}/")
    print(f"   📖 Docs: http://{settings.host}:{settings.port}/docs")
    print(f"   💬 Quotes: http://{settings.host}:{settings.port}/api/v1/quotes")
    print(f"   🤖 Chat: http://{settings.host}:{settings.port}/api/v1/chat")
    print(f"   ❤️ Health: http://{settings.host}:{settings.port}/api/v1/health")
    print("\n🔧 Configuration:")
    print(f"   🗄️ Database: {settings.database_url.split('@')[-1] if '@' in settings.database_url else 'Not configured'}")
    print(f"   🔴 Redis: {settings.redis_url}")
    print(f"   🧠 OpenAI: {'Configured' if settings.openai_api_key and settings.openai_api_key != 'your-openai-api-key-here' else 'Not configured'}")
    print("="*60)
    
    if not settings.openai_api_key or settings.openai_api_key == "your-openai-api-key-here":
        print("\n⚠️  WARNING: OpenAI API key not configured!")
        print("   Set OPENAI_API_KEY environment variable for AI chat functionality")
    
    print("\n🚀 Starting server...\n")

def main():
    """Main startup function"""
    print("Starting Daily Quote FastAPI Server...")
    
    # Check dependencies
    if not check_dependencies():
        sys.exit(1)
    
    # Setup directories
    setup_directories()
    
    # Show startup information
    show_startup_info()
    
    # Start the server
    try:
        uvicorn.run(
            "app.main:app",
            host=settings.host,
            port=settings.port,
            reload=settings.debug,
            log_level=settings.log_level.lower(),
            access_log=True,
            reload_dirs=["app"] if settings.debug else None,
        )
    except KeyboardInterrupt:
        print("\n👋 Server stopped by user")
    except Exception as e:
        print(f"\n❌ Server failed to start: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main() 