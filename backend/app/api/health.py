from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from datetime import datetime
import asyncio
import time
from openai import AsyncOpenAI

from app.database import get_db, get_redis
from app.config import settings
from app.models.schemas import HealthCheck, APIStatus

router = APIRouter(prefix="/api/v1", tags=["health"])

# Global startup time for uptime calculation
startup_time = time.time()
request_count = 0

@router.get("/health", response_model=HealthCheck)
async def health_check(
    db: AsyncSession = Depends(get_db)
):
    """Health check endpoint"""
    health_status = HealthCheck(version=settings.app_version)
    
    try:
        # Check database connection
        await db.execute("SELECT 1")
        health_status.database = "connected"
    except Exception:
        health_status.database = "disconnected"
        health_status.status = "unhealthy"
    
    try:
        # Check Redis connection
        redis = await get_redis()
        await redis.ping()
        health_status.redis = "connected"
    except Exception:
        health_status.redis = "disconnected"
        health_status.status = "unhealthy"
    
    try:
        # Check OpenAI API (simple test)
        if settings.openai_api_key and settings.openai_api_key != "your-openai-api-key-here":
            client = AsyncOpenAI(api_key=settings.openai_api_key)
            # Test with a minimal request
            await asyncio.wait_for(
                client.models.list(), 
                timeout=5.0
            )
            health_status.openai = "connected"
        else:
            health_status.openai = "not_configured"
    except asyncio.TimeoutError:
        health_status.openai = "timeout"
    except Exception:
        health_status.openai = "disconnected"
        health_status.status = "unhealthy"
    
    return health_status

@router.get("/status", response_model=APIStatus)
async def api_status(
    db: AsyncSession = Depends(get_db)
):
    """API status and version info"""
    global request_count
    request_count += 1
    
    # Calculate uptime
    uptime_seconds = time.time() - startup_time
    
    # Get health check
    health = await health_check(db)
    
    return APIStatus(
        app_name=settings.app_name,
        version=settings.app_version,
        uptime=uptime_seconds,
        requests_count=request_count,
        health=health
    )

@router.get("/ping")
async def ping():
    """Simple ping endpoint"""
    return {"message": "pong", "timestamp": datetime.utcnow()} 