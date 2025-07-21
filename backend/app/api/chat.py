from fastapi import APIRouter, Depends, HTTPException, Path, Body
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
import uuid

from app.database import get_db
from app.models.schemas import (
    ConversationCreate, ConversationResponse, ChatMessageCreate, 
    ChatResponse, BaseResponse
)
from app.services.ai_chat_service import ai_chat_service

router = APIRouter(prefix="/api/v1/chat", tags=["chat"])

@router.post("/conversations", response_model=ConversationResponse)
async def create_conversation(
    request: ConversationCreate,
    db: AsyncSession = Depends(get_db)
):
    """Create a new chat conversation with quote context"""
    try:
        conversation = await ai_chat_service.create_conversation(
            db=db,
            quote_id=request.quote_id,
            user_id=request.user_id
        )
        return conversation
        
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to create conversation: {str(e)}")

@router.post("/conversations/{conversation_id}/messages", response_model=ChatResponse)
async def send_message(
    conversation_id: str = Path(..., description="Conversation ID"),
    request: ChatMessageCreate = Body(...),
    db: AsyncSession = Depends(get_db)
):
    """Send a message to the conversation and get AI response"""
    try:
        conversation_uuid = uuid.UUID(conversation_id)
        
        response = await ai_chat_service.send_message(
            db=db,
            conversation_id=conversation_uuid,
            message=request.message,
            user_id=request.user_id
        )
        return response
        
    except ValueError as e:
        if "not found" in str(e) or "unauthorized" in str(e):
            raise HTTPException(status_code=404, detail=str(e))
        else:
            raise HTTPException(status_code=400, detail="Invalid conversation ID format")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to send message: {str(e)}")

@router.get("/conversations/{conversation_id}", response_model=ConversationResponse)
async def get_conversation(
    conversation_id: str = Path(..., description="Conversation ID"),
    user_id: str = Body(..., description="User ID"),
    db: AsyncSession = Depends(get_db)
):
    """Get conversation history"""
    try:
        conversation_uuid = uuid.UUID(conversation_id)
        user_uuid = uuid.UUID(user_id)
        
        conversation = await ai_chat_service.get_conversation(
            db=db,
            conversation_id=conversation_uuid,
            user_id=user_uuid
        )
        return conversation
        
    except ValueError as e:
        if "not found" in str(e) or "unauthorized" in str(e):
            raise HTTPException(status_code=404, detail=str(e))
        else:
            raise HTTPException(status_code=400, detail="Invalid ID format")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to get conversation: {str(e)}")

@router.delete("/conversations/{conversation_id}", response_model=BaseResponse)
async def clear_conversation(
    conversation_id: str = Path(..., description="Conversation ID"),
    user_id: str = Body(..., description="User ID"),
    db: AsyncSession = Depends(get_db)
):
    """Clear conversation history"""
    try:
        conversation_uuid = uuid.UUID(conversation_id)
        user_uuid = uuid.UUID(user_id)
        
        success = await ai_chat_service.clear_conversation(
            db=db,
            conversation_id=conversation_uuid,
            user_id=user_uuid
        )
        
        if success:
            return BaseResponse(message="Conversation cleared successfully")
        else:
            raise HTTPException(status_code=404, detail="Conversation not found or unauthorized")
        
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid ID format")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to clear conversation: {str(e)}")

# Alternative endpoint with query parameter for user_id
@router.get("/conversations/{conversation_id}/history", response_model=ConversationResponse)
async def get_conversation_history(
    conversation_id: str = Path(..., description="Conversation ID"),
    user_id: str = Body(..., description="User ID"),
    db: AsyncSession = Depends(get_db)
):
    """Get conversation history (alternative endpoint)"""
    return await get_conversation(conversation_id, user_id, db) 