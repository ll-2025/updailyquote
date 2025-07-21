import asyncio
import structlog
from contextlib import asynccontextmanager
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from fastapi.responses import JSONResponse
import time

from app.config import settings
from app.database import init_db, close_db
from app.api import quotes, chat, health

# Configure structured logging
structlog.configure(
    processors=[
        structlog.stdlib.filter_by_level,
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.stdlib.PositionalArgumentsFormatter(),
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.UnicodeDecoder(),
        structlog.processors.JSONRenderer()
    ],
    context_class=dict,
    logger_factory=structlog.stdlib.LoggerFactory(),
    wrapper_class=structlog.stdlib.BoundLogger,
    cache_logger_on_first_use=True,
)

logger = structlog.get_logger()

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan manager"""
    # Startup
    logger.info("Starting Daily Quote API", version=settings.app_version)
    
    try:
        # Initialize database
        await init_db()
        logger.info("Database initialized successfully")
        
        # Test basic functionality
        from app.services.quote_engine import quote_engine
        logger.info("Quote engine initialized")
        
        from app.services.ai_chat_service import ai_chat_service
        logger.info("AI chat service initialized")
        
        logger.info("Application startup completed")
        
    except Exception as e:
        logger.error("Failed to initialize application", error=str(e))
        raise
    
    yield
    
    # Shutdown
    logger.info("Shutting down Daily Quote API")
    try:
        await close_db()
        logger.info("Database connections closed")
    except Exception as e:
        logger.error("Error during shutdown", error=str(e))

# Create FastAPI application
app = FastAPI(
    title=settings.app_name,
    description="A powerful API for generating inspirational quotes and AI-powered philosophical conversations",
    version=settings.app_version,
    debug=settings.debug,
    lifespan=lifespan,
    docs_url="/docs" if settings.debug else None,
    redoc_url="/redoc" if settings.debug else None,
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure this properly for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Add Gzip compression
app.add_middleware(GZipMiddleware, minimum_size=1000)

# Add request logging middleware
@app.middleware("http")
async def log_requests(request: Request, call_next):
    start_time = time.time()
    
    # Log request
    logger.info(
        "Request started",
        method=request.method,
        url=str(request.url),
        client_ip=request.client.host if request.client else None
    )
    
    try:
        response = await call_next(request)
        
        # Calculate processing time
        process_time = time.time() - start_time
        
        # Log response
        logger.info(
            "Request completed",
            method=request.method,
            url=str(request.url),
            status_code=response.status_code,
            process_time=round(process_time, 4)
        )
        
        # Add processing time header
        response.headers["X-Process-Time"] = str(process_time)
        
        return response
        
    except Exception as e:
        process_time = time.time() - start_time
        
        logger.error(
            "Request failed",
            method=request.method,
            url=str(request.url),
            error=str(e),
            process_time=round(process_time, 4)
        )
        
        # Return error response
        return JSONResponse(
            status_code=500,
            content={
                "error": {
                    "code": "INTERNAL_SERVER_ERROR",
                    "message": "An internal server error occurred",
                    "details": {}
                }
            }
        )

# Global exception handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(
        "Unhandled exception",
        method=request.method,
        url=str(request.url),
        error=str(exc),
        exc_info=True
    )
    
    return JSONResponse(
        status_code=500,
        content={
            "error": {
                "code": "INTERNAL_SERVER_ERROR",
                "message": "An unexpected error occurred",
                "details": {}
            }
        }
    )

# Include routers
app.include_router(health.router)
app.include_router(quotes.router)
app.include_router(chat.router)

# Root endpoint
@app.get("/")
async def root():
    """Root endpoint with API information"""
    return {
        "app": settings.app_name,
        "version": settings.app_version,
        "status": "running",
        "docs": "/docs" if settings.debug else "disabled",
        "endpoints": {
            "quotes": "/api/v1/quotes",
            "chat": "/api/v1/chat",
            "health": "/api/v1/health",
            "status": "/api/v1/status"
        }
    }

# Development server entry point
if __name__ == "__main__":
    import uvicorn
    
    logger.info("Starting development server")
    
    uvicorn.run(
        "app.main:app",
        host=settings.host,
        port=settings.port,
        reload=settings.debug,
        log_level=settings.log_level.lower(),
        access_log=True
    ) 