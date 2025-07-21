import json
import random
import asyncio
from typing import List, Optional, Dict, Set
from datetime import datetime, timedelta
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_, func
from app.models.database import QuoteDB, AnalyticsEventDB
from app.models.schemas import Quote, QuoteLanguage, QuoteCategory, QuoteFilter
import uuid
import re

class QuoteEngine:
    """Advanced quote generation engine with smart filtering and categorization"""
    
    def __init__(self):
        self.quotes_cache: Dict[str, List[Dict]] = {}
        self.last_cache_update = datetime.utcnow()
        self.cache_ttl = timedelta(hours=1)
        
    async def load_quotes_from_json(self, language: QuoteLanguage = QuoteLanguage.ENGLISH) -> List[Dict]:
        """Load quotes from JSON files (similar to iOS app structure)"""
        cache_key = language.value
        
        # Check cache validity
        if (cache_key in self.quotes_cache and 
            datetime.utcnow() - self.last_cache_update < self.cache_ttl):
            return self.quotes_cache[cache_key]
        
        # Determine file name based on language
        if language == QuoteLanguage.ENGLISH:
            filename = "QuoteData.json"
        else:
            filename = f"QuoteData_{language.value}.json"
        
        try:
            with open(f"backend/data/{filename}", 'r', encoding='utf-8') as file:
                quotes_data = json.load(file)
                
            # Auto-categorize quotes that don't have categories
            for quote in quotes_data:
                if 'category' not in quote:
                    quote['category'] = self._auto_categorize_quote(quote['text'], quote['author'])
                if 'language' not in quote:
                    quote['language'] = language.value
                    
            self.quotes_cache[cache_key] = quotes_data
            self.last_cache_update = datetime.utcnow()
            return quotes_data
            
        except FileNotFoundError:
            print(f"Quote file {filename} not found, falling back to default quotes")
            return self._get_fallback_quotes(language)
        except json.JSONDecodeError as e:
            print(f"Error parsing {filename}: {e}")
            return self._get_fallback_quotes(language)
    
    def _auto_categorize_quote(self, text: str, author: str) -> str:
        """Auto-categorize quotes based on keywords (similar to iOS app logic)"""
        text_lower = text.lower()
        author_lower = author.lower()
        
        # Success keywords
        success_keywords = [
            'success', 'achieve', 'goal', 'win', 'victory', 'accomplish',
            'éxito', 'lograr', 'meta', 'ganar',
            '成功', '成就', '目标', '胜利', '达成', '实现'
        ]
        
        # Life keywords
        life_keywords = [
            'life', 'live', 'exist', 'born', 'death', 'time',
            'vida', 'vivir', 'existir', 'nacer',
            '生活', '生命', '活着', '存在', '出生'
        ]
        
        # Leadership keywords
        leadership_keywords = [
            'lead', 'leader', 'leadership', 'manage', 'team', 'people',
            'liderar', 'líder', 'liderazgo', 'gestionar',
            '领导', '领袖', '管理', '团队'
        ]
        
        # Motivation keywords
        motivation_keywords = [
            'motivat', 'inspir', 'encourag', 'persever', 'determin',
            'motivar', 'inspirar', 'animar',
            '激励', '鼓舞', '坚持'
        ]
        
        # Creativity keywords
        creativity_keywords = [
            'creat', 'innovat', 'imagin', 'art', 'design', 'original',
            'crear', 'innovar', 'imaginar',
            '创造', '创新', '想象', '艺术'
        ]
        
        # Happiness keywords
        happiness_keywords = [
            'happy', 'happiness', 'joy', 'smile', 'laugh', 'content',
            'feliz', 'felicidad', 'alegría',
            '快乐', '幸福', '欢乐', '微笑'
        ]
        
        # Wisdom keywords
        wisdom_keywords = [
            'wisdom', 'wise', 'knowledge', 'learn', 'understand', 'truth',
            'sabiduría', 'sabio', 'conocimiento', 'aprender',
            '智慧', '智者', '知识', '学习', '真理'
        ]
        
        # Perseverance keywords
        perseverance_keywords = [
            'persever', 'persist', 'endur', 'overcome', 'challeng', 'difficult',
            'perseverar', 'persistir', 'superar', 'desafío',
            '坚持', '克服', '挑战', '困难'
        ]
        
        # Check keywords in order of priority
        if any(keyword in text_lower for keyword in success_keywords):
            return QuoteCategory.SUCCESS.value
        elif any(keyword in text_lower for keyword in leadership_keywords):
            return QuoteCategory.LEADERSHIP.value
        elif any(keyword in text_lower for keyword in motivation_keywords):
            return QuoteCategory.MOTIVATION.value
        elif any(keyword in text_lower for keyword in creativity_keywords):
            return QuoteCategory.CREATIVITY.value
        elif any(keyword in text_lower for keyword in happiness_keywords):
            return QuoteCategory.HAPPINESS.value
        elif any(keyword in text_lower for keyword in wisdom_keywords):
            return QuoteCategory.WISDOM.value
        elif any(keyword in text_lower for keyword in perseverance_keywords):
            return QuoteCategory.PERSEVERANCE.value
        elif any(keyword in text_lower for keyword in life_keywords):
            return QuoteCategory.LIFE.value
        else:
            return QuoteCategory.MOTIVATION.value  # Default fallback
    
    def _get_fallback_quotes(self, language: QuoteLanguage) -> List[Dict]:
        """Provide fallback quotes when JSON files are not available"""
        fallback_quotes = {
            QuoteLanguage.ENGLISH: [
                {
                    "text": "The only way to do great work is to love what you do.",
                    "author": "Steve Jobs",
                    "category": "success",
                    "language": "en"
                },
                {
                    "text": "Believe you can and you're halfway there.",
                    "author": "Theodore Roosevelt",
                    "category": "motivation",
                    "language": "en"
                },
                {
                    "text": "Success is not final, failure is not fatal: It is the courage to continue that counts.",
                    "author": "Winston Churchill",
                    "category": "perseverance",
                    "language": "en"
                },
                {
                    "text": "The purpose of our lives is to be happy.",
                    "author": "Dalai Lama",
                    "category": "happiness",
                    "language": "en"
                }
            ],
            QuoteLanguage.SPANISH: [
                {
                    "text": "La única forma de hacer un gran trabajo es amar lo que haces.",
                    "author": "Steve Jobs",
                    "category": "success",
                    "language": "es"
                },
                {
                    "text": "Cree que puedes y ya estás a medio camino.",
                    "author": "Theodore Roosevelt",
                    "category": "motivation",
                    "language": "es"
                }
            ],
            QuoteLanguage.CHINESE: [
                {
                    "text": "做好工作的唯一方法就是热爱你所做的事情。",
                    "author": "史蒂夫·乔布斯",
                    "category": "success",
                    "language": "zh"
                },
                {
                    "text": "相信你能做到，你就已经成功了一半。",
                    "author": "西奥多·罗斯福",
                    "category": "motivation",
                    "language": "zh"
                }
            ]
        }
        
        return fallback_quotes.get(language, fallback_quotes[QuoteLanguage.ENGLISH])
    
    async def get_random_quote(
        self, 
        db: AsyncSession,
        filters: Optional[QuoteFilter] = None,
        user_id: Optional[uuid.UUID] = None
    ) -> Quote:
        """Get a random quote with intelligent filtering and user preferences"""
        
        # Try to get from database first
        quote_from_db = await self._get_random_quote_from_db(db, filters, user_id)
        if quote_from_db:
            return quote_from_db
        
        # Fallback to JSON files
        language = filters.language if filters else QuoteLanguage.ENGLISH
        quotes_data = await self.load_quotes_from_json(language)
        
        # Apply filters
        filtered_quotes = await self._apply_filters(quotes_data, filters, db, user_id)
        
        if not filtered_quotes:
            # If no quotes match filters, relax constraints
            filtered_quotes = quotes_data
        
        # Select random quote
        selected_quote = random.choice(filtered_quotes)
        
        # Create Quote object
        quote = Quote(
            id=uuid.uuid4(),
            text=selected_quote['text'],
            author=selected_quote['author'],
            category=QuoteCategory(selected_quote['category']),
            language=QuoteLanguage(selected_quote['language']),
            created_at=datetime.utcnow()
        )
        
        # Save to database for future use
        await self._save_quote_to_db(db, quote)
        
        return quote
    
    async def _get_random_quote_from_db(
        self, 
        db: AsyncSession, 
        filters: Optional[QuoteFilter],
        user_id: Optional[uuid.UUID]
    ) -> Optional[Quote]:
        """Get random quote from database with filters"""
        query = select(QuoteDB)
        
        # Apply filters
        if filters:
            if filters.language:
                query = query.where(QuoteDB.language == filters.language.value)
            if filters.category:
                query = query.where(QuoteDB.category == filters.category.value)
            if filters.exclude_recent and user_id:
                # Exclude quotes viewed in the last 24 hours
                recent_threshold = datetime.utcnow() - timedelta(hours=24)
                recent_views = select(AnalyticsEventDB.quote_id).where(
                    and_(
                        AnalyticsEventDB.user_id == user_id,
                        AnalyticsEventDB.event_type == 'quote_viewed',
                        AnalyticsEventDB.timestamp > recent_threshold
                    )
                )
                query = query.where(QuoteDB.id.notin_(recent_views))
        
        # Get random quote using database random function
        query = query.order_by(func.random()).limit(1)
        
        result = await db.execute(query)
        quote_db = result.scalar_one_or_none()
        
        if quote_db:
            return Quote(
                id=quote_db.id,
                text=quote_db.text,
                author=quote_db.author,
                category=QuoteCategory(quote_db.category),
                language=QuoteLanguage(quote_db.language),
                created_at=quote_db.created_at
            )
        
        return None
    
    async def _apply_filters(
        self, 
        quotes_data: List[Dict], 
        filters: Optional[QuoteFilter],
        db: AsyncSession,
        user_id: Optional[uuid.UUID]
    ) -> List[Dict]:
        """Apply filters to quotes data"""
        if not filters:
            return quotes_data
        
        filtered_quotes = quotes_data.copy()
        
        # Language filter
        if filters.language:
            filtered_quotes = [
                q for q in filtered_quotes 
                if q.get('language') == filters.language.value
            ]
        
        # Category filter
        if filters.category:
            filtered_quotes = [
                q for q in filtered_quotes 
                if q.get('category') == filters.category.value
            ]
        
        # Exclude recent quotes
        if filters.exclude_recent and user_id:
            recent_quote_texts = await self._get_recent_quote_texts(db, user_id)
            filtered_quotes = [
                q for q in filtered_quotes 
                if q['text'] not in recent_quote_texts
            ]
        
        return filtered_quotes
    
    async def _get_recent_quote_texts(self, db: AsyncSession, user_id: uuid.UUID) -> Set[str]:
        """Get texts of recently viewed quotes"""
        recent_threshold = datetime.utcnow() - timedelta(hours=24)
        
        query = select(QuoteDB.text).join(
            AnalyticsEventDB, QuoteDB.id == AnalyticsEventDB.quote_id
        ).where(
            and_(
                AnalyticsEventDB.user_id == user_id,
                AnalyticsEventDB.event_type == 'quote_viewed',
                AnalyticsEventDB.timestamp > recent_threshold
            )
        )
        
        result = await db.execute(query)
        return set(result.scalars().all())
    
    async def _save_quote_to_db(self, db: AsyncSession, quote: Quote):
        """Save quote to database if it doesn't exist"""
        # Check if quote already exists
        existing = await db.execute(
            select(QuoteDB).where(
                and_(
                    QuoteDB.text == quote.text,
                    QuoteDB.author == quote.author
                )
            )
        )
        
        if not existing.scalar_one_or_none():
            quote_db = QuoteDB(
                id=quote.id,
                text=quote.text,
                author=quote.author,
                category=quote.category.value,
                language=quote.language.value
            )
            db.add(quote_db)
            await db.commit()
    
    async def get_quote_by_id(self, db: AsyncSession, quote_id: uuid.UUID) -> Optional[Quote]:
        """Get a specific quote by ID"""
        result = await db.execute(select(QuoteDB).where(QuoteDB.id == quote_id))
        quote_db = result.scalar_one_or_none()
        
        if quote_db:
            return Quote(
                id=quote_db.id,
                text=quote_db.text,
                author=quote_db.author,
                category=QuoteCategory(quote_db.category),
                language=QuoteLanguage(quote_db.language),
                created_at=quote_db.created_at
            )
        
        return None
    
    async def get_categories(self) -> List[QuoteCategory]:
        """Get all available quote categories"""
        return list(QuoteCategory)
    
    async def get_languages(self) -> List[QuoteLanguage]:
        """Get all supported languages"""
        return list(QuoteLanguage)

# Global instance
quote_engine = QuoteEngine() 