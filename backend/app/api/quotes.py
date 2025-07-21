from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List, Optional
import uuid

from app.database import get_db
from app.models.schemas import (
    Quote, QuoteFilter, QuoteLanguage, QuoteCategory,
    BaseResponse, ErrorResponse
)
from app.services.quote_engine import quote_engine

router = APIRouter(prefix="/api/v1/quotes", tags=["quotes"])

@router.get("/random", response_model=Quote)
async def get_random_quote(
    language: Optional[QuoteLanguage] = Query(None, description="Quote language"),
    category: Optional[QuoteCategory] = Query(None, description="Quote category"),
    exclude_recent: bool = Query(False, description="Exclude recently viewed quotes"),
    user_id: Optional[str] = Query(None, description="User ID for personalization"),
    db: AsyncSession = Depends(get_db)
):
    """Get a random quote with optional filtering"""
    try:
        # Create filter object
        filters = QuoteFilter(
            language=language,
            category=category,
            exclude_recent=exclude_recent
        )
        
        # Convert user_id string to UUID if provided
        user_uuid = None
        if user_id:
            try:
                user_uuid = uuid.UUID(user_id)
            except ValueError:
                raise HTTPException(status_code=400, detail="Invalid user_id format")
        
        # Get random quote
        quote = await quote_engine.get_random_quote(
            db=db,
            filters=filters,
            user_id=user_uuid
        )
        
        return quote
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to get random quote: {str(e)}")

@router.get("/{quote_id}", response_model=Quote)
async def get_quote_by_id(
    quote_id: str,
    db: AsyncSession = Depends(get_db)
):
    """Get a specific quote by ID"""
    try:
        quote_uuid = uuid.UUID(quote_id)
        quote = await quote_engine.get_quote_by_id(db, quote_uuid)
        
        if not quote:
            raise HTTPException(status_code=404, detail=f"Quote with ID {quote_id} not found")
        
        return quote
        
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid quote ID format")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to get quote: {str(e)}")

@router.get("/categories", response_model=List[str])
async def get_quote_categories():
    """Get all available quote categories"""
    try:
        categories = await quote_engine.get_categories()
        return [category.value for category in categories]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to get categories: {str(e)}")

@router.get("/languages", response_model=List[str])
async def get_quote_languages():
    """Get all supported languages"""
    try:
        languages = await quote_engine.get_languages()
        return [language.value for language in languages]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to get languages: {str(e)}")