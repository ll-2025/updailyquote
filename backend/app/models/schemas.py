from datetime import datetime
from typing import List, Optional, Union
from uuid import UUID
from pydantic import BaseModel, Field
from enum import Enum

# Enums
class QuoteLanguage(str, Enum):
    ENGLISH = "en"
    SPANISH = "es"
    CHINESE = "zh"

class QuoteCategory(str, Enum):
    SUCCESS = "success"
    LIFE = "life"
    MOTIVATION = "motivation"
    LEADERSHIP = "leadership"
    CREATIVITY = "creativity"
    HAPPINESS = "happiness"
    WISDOM = "wisdom"
    PERSEVERANCE = "perseverance"

class ImageStyle(str, Enum):
    COFFEE = "coffee"
    MOUNTAINS = "mountains"
    OCEAN = "ocean"
    RAINY_DAY = "rainyDay"
    CLOUDS = "clouds"
    ACTIVITY = "activity"
    GALAXY = "galaxy"
    STUDY = "study"
    SUNSET = "sunset"

class ImageFormat(str, Enum):
    PNG = "png"
    JPEG = "jpeg"

class ImageSize(str, Enum):
    SQUARE = "1080x1080"
    LANDSCAPE = "1920x1080"

# Base Models
class BaseResponse(BaseModel):
    success: bool = True
    message: Optional[str] = None

class ErrorResponse(BaseModel):
    error: dict
    success: bool = False

# Quote Models
class QuoteBase(BaseModel):
    text: str
    author: str
    category: QuoteCategory
    language: QuoteLanguage

class QuoteCreate(QuoteBase):
    pass

class QuoteUpdate(BaseModel):
    text: Optional[str] = None
    author: Optional[str] = None
    category: Optional[QuoteCategory] = None
    language: Optional[QuoteLanguage] = None

class Quote(QuoteBase):
    id: UUID
    created_at: datetime
    
    class Config:
        from_attributes = True

class QuoteFilter(BaseModel):
    language: Optional[QuoteLanguage] = None
    category: Optional[QuoteCategory] = None
    exclude_recent: bool = False

# User Models
class UserBase(BaseModel):
    email: str = Field(..., regex=r'^[^@]+@[^@]+\.[^@]+$')
    username: str = Field(..., min_length=3, max_length=50)

class UserCreate(UserBase):
    password: str = Field(..., min_length=8)

class UserUpdate(BaseModel):
    email: Optional[str] = None
    username: Optional[str] = None
    password: Optional[str] = None

class User(UserBase):
    id: UUID
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

class UserPreferences(BaseModel):
    language: QuoteLanguage = QuoteLanguage.ENGLISH
    categories: List[QuoteCategory] = Field(default_factory=lambda: list(QuoteCategory))
    theme: str = "system"

# Authentication Models
class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
    expires_in: int

class TokenData(BaseModel):
    user_id: Optional[UUID] = None

# Chat Models
class ChatMessageBase(BaseModel):
    content: str
    is_from_user: bool

class ChatMessageCreate(BaseModel):
    message: str
    user_id: UUID

class ChatMessage(ChatMessageBase):
    id: UUID
    conversation_id: UUID
    timestamp: datetime
    
    class Config:
        from_attributes = True

class ConversationCreate(BaseModel):
    quote_id: UUID
    user_id: UUID

class ConversationBase(BaseModel):
    quote_id: UUID
    user_id: UUID

class Conversation(ConversationBase):
    id: UUID
    created_at: datetime
    updated_at: datetime
    messages: List[ChatMessage] = []
    
    class Config:
        from_attributes = True

class ConversationResponse(BaseModel):
    conversation_id: UUID
    quote_context: Quote
    messages: List[ChatMessage]

class ChatResponse(BaseModel):
    message_id: UUID
    ai_response: ChatMessage

# Image Generation Models
class ImageGenerationRequest(BaseModel):
    quote_id: UUID
    style: ImageStyle = ImageStyle.COFFEE
    format: ImageFormat = ImageFormat.PNG
    size: ImageSize = ImageSize.SQUARE

class ImageGenerationResponse(BaseModel):
    image_url: str
    image_id: UUID
    expires_at: datetime

# Favorites Models
class FavoriteCreate(BaseModel):
    quote_id: UUID
    user_id: UUID

class Favorite(BaseModel):
    id: UUID
    user_id: UUID
    quote: Quote
    created_at: datetime
    
    class Config:
        from_attributes = True

# Analytics Models
class QuoteViewEvent(BaseModel):
    quote_id: UUID
    user_id: Optional[UUID] = None
    timestamp: datetime = Field(default_factory=datetime.utcnow)

class QuoteShareEvent(BaseModel):
    quote_id: UUID
    user_id: Optional[UUID] = None
    platform: str
    timestamp: datetime = Field(default_factory=datetime.utcnow)

# Health Models
class HealthCheck(BaseModel):
    status: str = "healthy"
    timestamp: datetime = Field(default_factory=datetime.utcnow)
    version: str
    database: str = "connected"
    redis: str = "connected"
    openai: str = "connected"

class APIStatus(BaseModel):
    app_name: str
    version: str
    uptime: float
    requests_count: int
    health: HealthCheck 