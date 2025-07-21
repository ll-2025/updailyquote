import asyncio
import json
from typing import List, Optional, Dict, Any
from datetime import datetime, timedelta
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_, desc
from openai import AsyncOpenAI
import uuid

from app.config import settings
from app.models.database import ConversationDB, ChatMessageDB, QuoteDB
from app.models.schemas import (
    ChatMessage, Conversation, ConversationResponse, 
    ChatResponse, Quote, QuoteLanguage, QuoteCategory
)

class AIChatService:
    """AI Chat service for quote discussions and philosophical conversations"""
    
    def __init__(self):
        self.client = AsyncOpenAI(api_key=settings.openai_api_key)
        self.model = settings.openai_model
        self.max_tokens = settings.openai_max_tokens
        self.conversation_cache: Dict[str, List[Dict]] = {}
        
    async def create_conversation(
        self, 
        db: AsyncSession, 
        quote_id: uuid.UUID, 
        user_id: uuid.UUID
    ) -> ConversationResponse:
        """Create a new conversation with quote context"""
        
        # Get the quote
        quote_result = await db.execute(select(QuoteDB).where(QuoteDB.id == quote_id))
        quote_db = quote_result.scalar_one_or_none()
        
        if not quote_db:
            raise ValueError(f"Quote with ID {quote_id} not found")
        
        quote = Quote(
            id=quote_db.id,
            text=quote_db.text,
            author=quote_db.author,
            category=QuoteCategory(quote_db.category),
            language=QuoteLanguage(quote_db.language),
            created_at=quote_db.created_at
        )
        
        # Create conversation
        conversation_db = ConversationDB(
            id=uuid.uuid4(),
            user_id=user_id,
            quote_id=quote_id
        )
        db.add(conversation_db)
        await db.flush()
        
        # Create initial AI message with quote context
        initial_message_content = self._create_initial_message(quote)
        initial_message = ChatMessageDB(
            id=uuid.uuid4(),
            conversation_id=conversation_db.id,
            content=initial_message_content,
            is_from_user=False
        )
        db.add(initial_message)
        
        await db.commit()
        
        # Convert to response format
        messages = [ChatMessage(
            id=initial_message.id,
            conversation_id=conversation_db.id,
            content=initial_message.content,
            is_from_user=False,
            timestamp=initial_message.timestamp
        )]
        
        return ConversationResponse(
            conversation_id=conversation_db.id,
            quote_context=quote,
            messages=messages
        )
    
    def _create_initial_message(self, quote: Quote) -> str:
        """Create an initial AI message based on the quote context"""
        language_greetings = {
            QuoteLanguage.ENGLISH: f"Hello! I see you're viewing this inspiring quote: \"{quote.text}\" by {quote.author}. What would you like to explore about it?",
            QuoteLanguage.SPANISH: f"¡Hola! Veo que estás viendo esta cita inspiradora: \"{quote.text}\" de {quote.author}. ¿Qué te gustaría explorar sobre ella?",
            QuoteLanguage.CHINESE: f"你好！我看到你在查看这句鼓舞人心的名言：\"{quote.text}\" —— {quote.author}。你想探索什么呢？"
        }
        
        return language_greetings.get(
            quote.language, 
            language_greetings[QuoteLanguage.ENGLISH]
        )
    
    async def send_message(
        self, 
        db: AsyncSession, 
        conversation_id: uuid.UUID, 
        message: str, 
        user_id: uuid.UUID
    ) -> ChatResponse:
        """Send a message and get AI response"""
        
        # Get conversation with quote context
        conversation_result = await db.execute(
            select(ConversationDB)
            .where(ConversationDB.id == conversation_id)
            .where(ConversationDB.user_id == user_id)
        )
        conversation_db = conversation_result.scalar_one_or_none()
        
        if not conversation_db:
            raise ValueError(f"Conversation {conversation_id} not found or unauthorized")
        
        # Save user message
        user_message = ChatMessageDB(
            id=uuid.uuid4(),
            conversation_id=conversation_id,
            content=message,
            is_from_user=True
        )
        db.add(user_message)
        await db.flush()
        
        try:
            # Generate AI response
            ai_response_content = await self._generate_ai_response(
                db, conversation_db, message
            )
            
            # Save AI response
            ai_message = ChatMessageDB(
                id=uuid.uuid4(),
                conversation_id=conversation_id,
                content=ai_response_content,
                is_from_user=False
            )
            db.add(ai_message)
            await db.commit()
            
            return ChatResponse(
                message_id=user_message.id,
                ai_response=ChatMessage(
                    id=ai_message.id,
                    conversation_id=conversation_id,
                    content=ai_response_content,
                    is_from_user=False,
                    timestamp=ai_message.timestamp
                )
            )
            
        except Exception as e:
            # Rollback user message if AI response fails
            await db.rollback()
            
            # Provide fallback response
            fallback_response = self._get_fallback_response(message)
            
            # Save user message and fallback response
            user_message = ChatMessageDB(
                id=uuid.uuid4(),
                conversation_id=conversation_id,
                content=message,
                is_from_user=True
            )
            db.add(user_message)
            
            ai_message = ChatMessageDB(
                id=uuid.uuid4(),
                conversation_id=conversation_id,
                content=f"🤖 [Fallback Response] {fallback_response}",
                is_from_user=False
            )
            db.add(ai_message)
            await db.commit()
            
            return ChatResponse(
                message_id=user_message.id,
                ai_response=ChatMessage(
                    id=ai_message.id,
                    conversation_id=conversation_id,
                    content=ai_message.content,
                    is_from_user=False,
                    timestamp=ai_message.timestamp
                )
            )
    
    async def _generate_ai_response(
        self, 
        db: AsyncSession, 
        conversation: ConversationDB, 
        user_message: str
    ) -> str:
        """Generate AI response using OpenAI API"""
        
        # Get quote context
        quote_result = await db.execute(select(QuoteDB).where(QuoteDB.id == conversation.quote_id))
        quote_db = quote_result.scalar_one_or_none()
        
        if not quote_db:
            raise ValueError("Quote context not found")
        
        quote = Quote(
            id=quote_db.id,
            text=quote_db.text,
            author=quote_db.author,
            category=QuoteCategory(quote_db.category),
            language=QuoteLanguage(quote_db.language),
            created_at=quote_db.created_at
        )
        
        # Get conversation history (last 10 messages for context)
        messages_result = await db.execute(
            select(ChatMessageDB)
            .where(ChatMessageDB.conversation_id == conversation.id)
            .order_by(desc(ChatMessageDB.timestamp))
            .limit(10)
        )
        recent_messages = list(messages_result.scalars().all())
        recent_messages.reverse()  # Chronological order
        
        # Build OpenAI messages
        openai_messages = [
            {
                "role": "system",
                "content": self._create_system_prompt(quote)
            }
        ]
        
        # Add conversation history
        for msg in recent_messages[:-1]:  # Exclude the current user message
            if not ("Hello! I see you're viewing" in msg.content or 
                   "¡Hola! Veo que estás viendo" in msg.content or
                   "你好！我看到你在查看" in msg.content):
                openai_messages.append({
                    "role": "user" if msg.is_from_user else "assistant",
                    "content": msg.content
                })
        
        # Add current user message
        openai_messages.append({
            "role": "user",
            "content": user_message
        })
        
        # Call OpenAI API
        response = await self.client.chat.completions.create(
            model=self.model,
            messages=openai_messages,
            max_tokens=self.max_tokens,
            temperature=0.7,
            timeout=30.0
        )
        
        return response.choices[0].message.content.strip()
    
    def _create_system_prompt(self, quote: Quote) -> str:
        """Create system prompt based on quote context and language"""
        
        base_prompts = {
            QuoteLanguage.ENGLISH: f"""You are a wise and thoughtful AI assistant specializing in quotes, philosophy, and meaningful conversations. 
You help users explore the deeper meanings behind quotes, discuss their philosophical implications, 
and engage in meaningful dialogue about wisdom, life lessons, and personal growth.

The user is currently viewing this quote: "{quote.text}" by {quote.author}
Category: {quote.category.value}

Guidelines:
- Keep responses conversational, insightful, and engaging
- Explain context and meaning behind quotes
- Share related quotes or wisdom when relevant
- Ask thought-provoking questions
- Relate quotes to modern life and personal experiences
- Discuss the authors and their philosophies
- Keep responses concise but meaningful (2-3 sentences typically)
- Be encouraging and supportive
- Avoid being preachy or overly academic""",
            
            QuoteLanguage.SPANISH: f"""Eres un asistente de IA sabio y reflexivo especializado en citas, filosofía y conversaciones significativas.
Ayudas a los usuarios a explorar los significados profundos detrás de las citas, discutir sus implicaciones filosóficas
y participar en diálogos significativos sobre sabiduría, lecciones de vida y crecimiento personal.

El usuario está viendo actualmente esta cita: "{quote.text}" de {quote.author}
Categoría: {quote.category.value}

Directrices:
- Mantén las respuestas conversacionales, perspicaces y atractivas
- Explica el contexto y significado detrás de las citas
- Comparte citas relacionadas o sabiduría cuando sea relevante
- Haz preguntas que inviten a la reflexión
- Relaciona las citas con la vida moderna y experiencias personales
- Habla sobre los autores y sus filosofías
- Mantén las respuestas concisas pero significativas (típicamente 2-3 oraciones)
- Sé alentador y solidario
- Evita ser predicativo o demasiado académico""",
            
            QuoteLanguage.CHINESE: f"""你是一个专门研究名言、哲学和有意义对话的智慧且深思熟虑的AI助手。
你帮助用户探索名言背后更深层的含义，讨论其哲学意义，
并就智慧、人生课程和个人成长进行有意义的对话。

用户目前正在查看这句名言："{quote.text}" —— {quote.author}
类别：{quote.category.value}

指导原则：
- 保持回应对话性、深刻且引人入胜
- 解释名言背后的背景和含义
- 在相关时分享相关名言或智慧
- 提出发人深省的问题
- 将名言与现代生活和个人经历联系起来
- 讨论作者及其哲学
- 保持回应简洁但有意义（通常2-3句话）
- 鼓励和支持
- 避免说教或过于学术化"""
        }
        
        return base_prompts.get(quote.language, base_prompts[QuoteLanguage.ENGLISH])
    
    def _get_fallback_response(self, user_message: str) -> str:
        """Provide fallback response when OpenAI API is unavailable"""
        user_message_lower = user_message.lower()
        
        if any(word in user_message_lower for word in ['meaning', 'mean', 'significa', '意思', '含义']):
            return "This quote encourages us to think deeply about our beliefs and how they shape our reality. Our mindset often determines our outcomes because it influences our actions and persistence."
        
        elif any(word in user_message_lower for word in ['author', 'who', 'cuando', 'when', '谁', '什么时候']):
            return "This quote comes from a thoughtful individual who understood the power of perspective and self-belief. The wisdom reflects timeless insights about human psychology and success."
        
        elif any(word in user_message_lower for word in ['apply', 'use', 'aplicar', 'usar', '应用', '使用']):
            return "You can apply this wisdom by being mindful of your self-talk and beliefs. When facing challenges, ask yourself: 'Am I thinking in a way that empowers or limits me?'"
        
        elif any(word in user_message_lower for word in ['similar', 'related', 'parecido', 'relacionado', '相似', '相关']):
            return "This reminds me of other wisdom about the power of mindset: 'What we think, we become.' Many great thinkers have recognized that our thoughts shape our reality."
        
        else:
            return "That's a thoughtful question about this quote. The wisdom here speaks to the fundamental power of our beliefs and attitudes in shaping our experiences and outcomes."
    
    async def get_conversation(
        self, 
        db: AsyncSession, 
        conversation_id: uuid.UUID, 
        user_id: uuid.UUID
    ) -> ConversationResponse:
        """Get conversation history"""
        
        # Get conversation
        conversation_result = await db.execute(
            select(ConversationDB)
            .where(ConversationDB.id == conversation_id)
            .where(ConversationDB.user_id == user_id)
        )
        conversation_db = conversation_result.scalar_one_or_none()
        
        if not conversation_db:
            raise ValueError(f"Conversation {conversation_id} not found or unauthorized")
        
        # Get quote context
        quote_result = await db.execute(select(QuoteDB).where(QuoteDB.id == conversation_db.quote_id))
        quote_db = quote_result.scalar_one_or_none()
        
        if not quote_db:
            raise ValueError("Quote context not found")
        
        quote = Quote(
            id=quote_db.id,
            text=quote_db.text,
            author=quote_db.author,
            category=QuoteCategory(quote_db.category),
            language=QuoteLanguage(quote_db.language),
            created_at=quote_db.created_at
        )
        
        # Get messages
        messages_result = await db.execute(
            select(ChatMessageDB)
            .where(ChatMessageDB.conversation_id == conversation_id)
            .order_by(ChatMessageDB.timestamp)
        )
        messages_db = messages_result.scalars().all()
        
        messages = [
            ChatMessage(
                id=msg.id,
                conversation_id=msg.conversation_id,
                content=msg.content,
                is_from_user=msg.is_from_user,
                timestamp=msg.timestamp
            )
            for msg in messages_db
        ]
        
        return ConversationResponse(
            conversation_id=conversation_db.id,
            quote_context=quote,
            messages=messages
        )
    
    async def clear_conversation(
        self, 
        db: AsyncSession, 
        conversation_id: uuid.UUID, 
        user_id: uuid.UUID
    ) -> bool:
        """Clear conversation messages"""
        
        # Verify ownership
        conversation_result = await db.execute(
            select(ConversationDB)
            .where(ConversationDB.id == conversation_id)
            .where(ConversationDB.user_id == user_id)
        )
        conversation_db = conversation_result.scalar_one_or_none()
        
        if not conversation_db:
            return False
        
        # Delete all messages
        await db.execute(
            ChatMessageDB.__table__.delete().where(
                ChatMessageDB.conversation_id == conversation_id
            )
        )
        
        # Create new initial message
        quote_result = await db.execute(select(QuoteDB).where(QuoteDB.id == conversation_db.quote_id))
        quote_db = quote_result.scalar_one_or_none()
        
        if quote_db:
            quote = Quote(
                id=quote_db.id,
                text=quote_db.text,
                author=quote_db.author,
                category=QuoteCategory(quote_db.category),
                language=QuoteLanguage(quote_db.language),
                created_at=quote_db.created_at
            )
            
            initial_message_content = self._create_initial_message(quote)
            initial_message = ChatMessageDB(
                id=uuid.uuid4(),
                conversation_id=conversation_id,
                content=initial_message_content,
                is_from_user=False
            )
            db.add(initial_message)
        
        await db.commit()
        return True

# Global instance
ai_chat_service = AIChatService() 