from sqlalchemy import Column, String, DateTime, Boolean, Text, ForeignKey, Integer
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import UUID
from datetime import datetime
import uuid

Base = declarative_base()

class QuoteDB(Base):
    __tablename__ = "quotes"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    text = Column(Text, nullable=False)
    author = Column(String(200), nullable=False)
    category = Column(String(50), nullable=False)
    language = Column(String(5), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    favorites = relationship("FavoriteDB", back_populates="quote")
    conversations = relationship("ConversationDB", back_populates="quote")

class UserDB(Base):
    __tablename__ = "users"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = Column(String(255), unique=True, index=True, nullable=False)
    username = Column(String(50), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    favorites = relationship("FavoriteDB", back_populates="user")
    conversations = relationship("ConversationDB", back_populates="user")
    preferences = relationship("UserPreferencesDB", back_populates="user", uselist=False)

class UserPreferencesDB(Base):
    __tablename__ = "user_preferences"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), unique=True)
    language = Column(String(5), default="en")
    categories = Column(Text)  # JSON string of selected categories
    theme = Column(String(20), default="system")
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    user = relationship("UserDB", back_populates="preferences")

class ConversationDB(Base):
    __tablename__ = "conversations"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    quote_id = Column(UUID(as_uuid=True), ForeignKey("quotes.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    user = relationship("UserDB", back_populates="conversations")
    quote = relationship("QuoteDB", back_populates="conversations")
    messages = relationship("ChatMessageDB", back_populates="conversation", cascade="all, delete-orphan")

class ChatMessageDB(Base):
    __tablename__ = "chat_messages"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    conversation_id = Column(UUID(as_uuid=True), ForeignKey("conversations.id"), nullable=False)
    content = Column(Text, nullable=False)
    is_from_user = Column(Boolean, nullable=False)
    timestamp = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    conversation = relationship("ConversationDB", back_populates="messages")

class FavoriteDB(Base):
    __tablename__ = "favorites"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    quote_id = Column(UUID(as_uuid=True), ForeignKey("quotes.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    user = relationship("UserDB", back_populates="favorites")
    quote = relationship("QuoteDB", back_populates="favorites")

class GeneratedImageDB(Base):
    __tablename__ = "generated_images"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    quote_id = Column(UUID(as_uuid=True), ForeignKey("quotes.id"), nullable=False)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    style = Column(String(50), nullable=False)
    format = Column(String(10), nullable=False)
    size = Column(String(20), nullable=False)
    file_path = Column(String(500), nullable=False)
    expires_at = Column(DateTime, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

class AnalyticsEventDB(Base):
    __tablename__ = "analytics_events"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    event_type = Column(String(50), nullable=False)  # 'quote_viewed', 'quote_shared', etc.
    quote_id = Column(UUID(as_uuid=True), ForeignKey("quotes.id"), nullable=True)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    metadata = Column(Text)  # JSON string for additional event data
    timestamp = Column(DateTime, default=datetime.utcnow)

class APIKeyDB(Base):
    __tablename__ = "api_keys"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    key_name = Column(String(100), nullable=False)
    key_hash = Column(String(255), nullable=False, unique=True)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    is_active = Column(Boolean, default=True)
    rate_limit = Column(Integer, default=1000)  # requests per hour
    created_at = Column(DateTime, default=datetime.utcnow)
    last_used = Column(DateTime, nullable=True) 