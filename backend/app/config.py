import os
from typing import Optional
from pydantic_settings import BaseSettings
from pydantic import Field

class Settings(BaseSettings):
    # API Configuration
    app_name: str = "Daily Quote API"
    app_version: str = "1.0.0"
    debug: bool = Field(default=False, env="DEBUG")
    host: str = Field(default="0.0.0.0", env="HOST")
    port: int = Field(default=8000, env="PORT")
    
    # Database Configuration
    database_url: str = Field(env="DATABASE_URL", default="postgresql+asyncpg://postgres:password@localhost:5432/daily_quotes")
    
    # Redis Configuration
    redis_url: str = Field(env="REDIS_URL", default="redis://localhost:6379")
    
    # OpenAI Configuration
    openai_api_key: str = Field(env="OPENAI_API_KEY")
    openai_model: str = Field(default="gpt-3.5-turbo", env="OPENAI_MODEL")
    openai_max_tokens: int = Field(default=500, env="OPENAI_MAX_TOKENS")
    
    # JWT Configuration
    secret_key: str = Field(env="SECRET_KEY", default="your-secret-key-here-change-in-production")
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    
    # Rate Limiting
    rate_limit_quotes: str = "100/minute"
    rate_limit_chat: str = "20/minute"
    rate_limit_images: str = "10/minute"
    
    # Image Generation
    image_storage_path: str = Field(default="./storage/images", env="IMAGE_STORAGE_PATH")
    image_max_age_hours: int = 24
    
    # Logging
    log_level: str = Field(default="INFO", env="LOG_LEVEL")
    
    class Config:
        env_file = ".env"
        case_sensitive = False

# Global settings instance
settings = Settings() 