#!/usr/bin/env python3
"""
Simplified Daily Quote FastAPI Server for Initial Testing
"""

import json
import random
import uvicorn
from datetime import datetime
from typing import List, Optional
from uuid import uuid4, UUID
from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel

# Simple data models
class Quote(BaseModel):
    id: str
    text: str
    author: str
    category: str
    language: str
    created_at: str

class ConversationCreate(BaseModel):
    quote_id: str
    user_id: str

class ChatMessage(BaseModel):
    id: str
    content: str
    is_from_user: bool
    timestamp: str

class ConversationResponse(BaseModel):
    conversation_id: str
    quote_context: Quote
    messages: List[ChatMessage]

class ChatMessageCreate(BaseModel):
    message: str
    user_id: str

class ChatResponse(BaseModel):
    message_id: str
    ai_response: ChatMessage

# Create FastAPI app
app = FastAPI(
    title="Daily Quote API",
    description="A simplified quote generation and AI chat API",
    version="1.0.0"
)

# In-memory storage for demo
quotes_data = []
conversations = {}

# Load quote data
def load_quotes():
    """Load quotes from JSON file"""
    global quotes_data
    try:
        with open('data/QuoteData.json', 'r', encoding='utf-8') as file:
            raw_quotes = json.load(file)
            
        for quote in raw_quotes:
            quote_obj = Quote(
                id=str(uuid4()),
                text=quote['text'],
                author=quote['author'],
                category=auto_categorize_quote(quote['text']),
                language='en',
                created_at=datetime.utcnow().isoformat()
            )
            quotes_data.append(quote_obj)
            
        print(f"✅ Loaded {len(quotes_data)} quotes")
            
    except FileNotFoundError:
        # Fallback quotes
        fallback_quotes = [
            {
                "text": "The only way to do great work is to love what you do.",
                "author": "Steve Jobs"
            },
            {
                "text": "Believe you can and you're halfway there.",
                "author": "Theodore Roosevelt"
            },
            {
                "text": "Success is not final, failure is not fatal: It is the courage to continue that counts.",
                "author": "Winston Churchill"
            },
            {
                "text": "The purpose of our lives is to be happy.",
                "author": "Dalai Lama"
            }
        ]
        
        for quote in fallback_quotes:
            quote_obj = Quote(
                id=str(uuid4()),
                text=quote['text'],
                author=quote['author'],
                category=auto_categorize_quote(quote['text']),
                language='en',
                created_at=datetime.utcnow().isoformat()
            )
            quotes_data.append(quote_obj)
        
        print(f"✅ Loaded {len(quotes_data)} fallback quotes")

def auto_categorize_quote(text: str) -> str:
    """Simple auto-categorization logic"""
    text_lower = text.lower()
    
    if any(word in text_lower for word in ['success', 'achieve', 'goal', 'win', 'accomplish']):
        return 'success'
    elif any(word in text_lower for word in ['life', 'live', 'exist', 'born']):
        return 'life'
    elif any(word in text_lower for word in ['lead', 'leader', 'leadership', 'manage']):
        return 'leadership'
    elif any(word in text_lower for word in ['motivat', 'inspir', 'encourag']):
        return 'motivation'
    elif any(word in text_lower for word in ['creat', 'innovat', 'imagin', 'art']):
        return 'creativity'
    elif any(word in text_lower for word in ['happy', 'happiness', 'joy', 'smile']):
        return 'happiness'
    elif any(word in text_lower for word in ['wisdom', 'wise', 'knowledge', 'learn']):
        return 'wisdom'
    elif any(word in text_lower for word in ['persever', 'persist', 'endur', 'overcome']):
        return 'perseverance'
    else:
        return 'motivation'

def get_fallback_ai_response(message: str, quote: Quote) -> str:
    """Simple fallback AI responses"""
    message_lower = message.lower()
    
    if any(word in message_lower for word in ['meaning', 'mean', 'what does']):
        return f"This quote by {quote.author} encourages us to think about how our mindset shapes our reality. It's a powerful reminder that our beliefs often determine our outcomes."
    
    elif any(word in message_lower for word in ['author', 'who', 'when']):
        return f"{quote.author} was a thoughtful individual who understood the importance of perspective and self-belief. This wisdom reflects timeless insights about human psychology."
    
    elif any(word in message_lower for word in ['apply', 'use', 'how']):
        return "You can apply this wisdom by being mindful of your thoughts and beliefs. When facing challenges, ask yourself: 'Am I thinking in a way that empowers or limits me?'"
    
    else:
        return "That's a thoughtful question about this quote. The wisdom here speaks to fundamental truths about human nature and our potential for growth and success."

# API Routes
@app.get("/")
async def root():
    return {
        "app": "Daily Quote API",
        "version": "1.0.0",
        "status": "running",
        "endpoints": {
            "quotes": "/api/v1/quotes",
            "chat": "/api/v1/chat",
            "health": "/api/v1/health"
        }
    }

@app.get("/api/v1/health")
async def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.utcnow().isoformat(),
        "quotes_loaded": len(quotes_data),
        "conversations_active": len(conversations)
    }

@app.get("/api/v1/quotes/random", response_model=Quote)
async def get_random_quote(
    category: Optional[str] = Query(None, description="Quote category"),
    language: Optional[str] = Query("en", description="Quote language")
):
    """Get a random quote with optional filtering"""
    if not quotes_data:
        raise HTTPException(status_code=500, detail="No quotes available")
    
    # Apply category filter if specified
    filtered_quotes = quotes_data
    if category:
        filtered_quotes = [q for q in quotes_data if q.category == category]
        if not filtered_quotes:
            filtered_quotes = quotes_data  # Fallback to all quotes
    
    # Select random quote
    selected_quote = random.choice(filtered_quotes)
    return selected_quote

@app.get("/api/v1/quotes/{quote_id}", response_model=Quote)
async def get_quote_by_id(quote_id: str):
    """Get a specific quote by ID"""
    for quote in quotes_data:
        if quote.id == quote_id:
            return quote
    
    raise HTTPException(status_code=404, detail=f"Quote with ID {quote_id} not found")

@app.get("/api/v1/quotes/categories")
async def get_categories():
    """Get all available quote categories"""
    categories = list(set(quote.category for quote in quotes_data))
    return sorted(categories)

@app.post("/api/v1/chat/conversations", response_model=ConversationResponse)
async def create_conversation(request: ConversationCreate):
    """Create a new chat conversation"""
    # Find the quote
    quote = None
    for q in quotes_data:
        if q.id == request.quote_id:
            quote = q
            break
    
    if not quote:
        raise HTTPException(status_code=404, detail="Quote not found")
    
    # Create conversation
    conversation_id = str(uuid4())
    initial_message = ChatMessage(
        id=str(uuid4()),
        content=f"Hello! I see you're viewing this inspiring quote: \"{quote.text}\" by {quote.author}. What would you like to explore about it?",
        is_from_user=False,
        timestamp=datetime.utcnow().isoformat()
    )
    
    conversations[conversation_id] = {
        "quote": quote,
        "user_id": request.user_id,
        "messages": [initial_message]
    }
    
    return ConversationResponse(
        conversation_id=conversation_id,
        quote_context=quote,
        messages=[initial_message]
    )

@app.post("/api/v1/chat/conversations/{conversation_id}/messages", response_model=ChatResponse)
async def send_message(conversation_id: str, request: ChatMessageCreate):
    """Send a message and get AI response"""
    if conversation_id not in conversations:
        raise HTTPException(status_code=404, detail="Conversation not found")
    
    conversation = conversations[conversation_id]
    
    # Add user message
    user_message = ChatMessage(
        id=str(uuid4()),
        content=request.message,
        is_from_user=True,
        timestamp=datetime.utcnow().isoformat()
    )
    conversation["messages"].append(user_message)
    
    # Generate AI response
    ai_response_content = get_fallback_ai_response(request.message, conversation["quote"])
    ai_message = ChatMessage(
        id=str(uuid4()),
        content=ai_response_content,
        is_from_user=False,
        timestamp=datetime.utcnow().isoformat()
    )
    conversation["messages"].append(ai_message)
    
    return ChatResponse(
        message_id=user_message.id,
        ai_response=ai_message
    )

@app.get("/api/v1/chat/conversations/{conversation_id}", response_model=ConversationResponse)
async def get_conversation(conversation_id: str):
    """Get conversation history"""
    if conversation_id not in conversations:
        raise HTTPException(status_code=404, detail="Conversation not found")
    
    conversation = conversations[conversation_id]
    return ConversationResponse(
        conversation_id=conversation_id,
        quote_context=conversation["quote"],
        messages=conversation["messages"]
    )

# Startup
@app.on_event("startup")
async def startup_event():
    print("🚀 Starting Daily Quote API Server...")
    print("📚 Loading quotes...")
    load_quotes()
    print("✅ Server ready!")

if __name__ == "__main__":
    print("Starting Daily Quote Server...")
    uvicorn.run(
        "simple_server:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    ) 