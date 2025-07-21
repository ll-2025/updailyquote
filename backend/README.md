# Daily Quote FastAPI Server

A powerful REST API server for generating inspirational quotes and AI-powered philosophical conversations.

## 🚀 Features

### Quote Generation Engine
- **Smart Quote Selection**: Intelligent filtering with language and category support
- **Multi-language Support**: English, Spanish, and Chinese quotes
- **Category-based Filtering**: 8 categories including Success, Life, Motivation, Leadership, etc.
- **Recent Quote Avoidance**: Prevents showing recently viewed quotes
- **Auto-categorization**: Automatically categorizes quotes using keyword analysis

### AI Chat Integration
- **Contextual Conversations**: AI understands the current quote context
- **Multi-language Chat**: Conversations in English, Spanish, and Chinese
- **Philosophical Discussions**: Deep conversations about quote meanings
- **Fallback Responses**: Graceful handling when OpenAI API is unavailable
- **Conversation Management**: Create, retrieve, and clear conversations

### Advanced Features
- **Async Architecture**: Built with FastAPI for high performance
- **Database Integration**: PostgreSQL with SQLAlchemy for data persistence
- **Redis Caching**: Fast caching for improved performance
- **Health Monitoring**: Comprehensive health checks for all services
- **Structured Logging**: JSON-formatted logs with full request tracking
- **Rate Limiting**: Built-in rate limiting for API protection

## 📋 Requirements

- Python 3.8+
- PostgreSQL 12+
- Redis 6+
- OpenAI API Key (for AI chat functionality)

## 🛠 Installation

### 1. Clone and Setup
```bash
# From project root, navigate to backend
cd backend
pip install -r requirements.txt
```

### 2. Database Setup
```bash
# Install PostgreSQL and create database
createdb daily_quotes

# Update connection string in environment
export DATABASE_URL="postgresql+asyncpg://postgres:password@localhost:5432/daily_quotes"
```

### 3. Redis Setup
```bash
# Install and start Redis
redis-server

# Or using Docker
docker run -d -p 6379:6379 redis:alpine
```

### 4. Environment Configuration
```bash
# Copy example environment file
cp env.example .env

# Edit .env file with your configurations:
# - Set OPENAI_API_KEY for AI chat functionality
# - Update DATABASE_URL for your PostgreSQL instance
# - Update REDIS_URL for your Redis instance
# - Set SECRET_KEY for JWT security
```

### 5. Start the Server
```bash
# Using the startup script (recommended)
python start_server.py

# Or directly with uvicorn
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

## 🌐 API Endpoints

### Quote Endpoints
```
GET  /api/v1/quotes/random          # Get random quote with filtering
GET  /api/v1/quotes/{quote_id}      # Get specific quote by ID
GET  /api/v1/quotes/categories      # Get all quote categories
GET  /api/v1/quotes/languages       # Get all supported languages
```

### Chat Endpoints
```
POST /api/v1/chat/conversations                         # Create new conversation
POST /api/v1/chat/conversations/{id}/messages          # Send message
GET  /api/v1/chat/conversations/{id}                   # Get conversation history
DELETE /api/v1/chat/conversations/{id}                 # Clear conversation
```

### Health & Status
```
GET  /api/v1/health                 # Health check
GET  /api/v1/status                 # API status and metrics
GET  /api/v1/ping                   # Simple ping endpoint
```

## 📖 Usage Examples

### Get Random Quote
```bash
curl "http://localhost:8000/api/v1/quotes/random?language=en&category=success"
```

Response:
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "text": "The only way to do great work is to love what you do.",
  "author": "Steve Jobs",
  "category": "success",
  "language": "en",
  "created_at": "2025-01-27T10:00:00Z"
}
```

### Start AI Conversation
```bash
curl -X POST "http://localhost:8000/api/v1/chat/conversations" \
  -H "Content-Type: application/json" \
  -d '{
    "quote_id": "123e4567-e89b-12d3-a456-426614174000",
    "user_id": "user-123"
  }'
```

### Send Chat Message
```bash
curl -X POST "http://localhost:8000/api/v1/chat/conversations/conv-123/messages" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "What does this quote mean?",
    "user_id": "user-123"
  }'
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DEBUG` | Enable debug mode | `false` |
| `HOST` | Server host | `0.0.0.0` |
| `PORT` | Server port | `8000` |
| `DATABASE_URL` | PostgreSQL connection string | Required |
| `REDIS_URL` | Redis connection string | `redis://localhost:6379` |
| `OPENAI_API_KEY` | OpenAI API key for chat | Required for AI chat |
| `OPENAI_MODEL` | OpenAI model to use | `gpt-3.5-turbo` |
| `SECRET_KEY` | JWT secret key | Required |
| `LOG_LEVEL` | Logging level | `INFO` |

### Categories
- `success` - Achievement and goals
- `life` - Life philosophy and existence
- `motivation` - Inspiration and drive
- `leadership` - Management and guidance
- `creativity` - Innovation and imagination
- `happiness` - Joy and contentment
- `wisdom` - Knowledge and insights
- `perseverance` - Persistence and resilience

### Languages
- `en` - English (🇺🇸)
- `es` - Spanish (🇪🇸)
- `zh` - Chinese (🇨🇳)

## 🧪 Testing

```bash
# Health check
curl http://localhost:8000/api/v1/health

# API status
curl http://localhost:8000/api/v1/status

# Random quote
curl http://localhost:8000/api/v1/quotes/random
```

## 📊 Monitoring

### Health Checks
The `/api/v1/health` endpoint provides comprehensive health monitoring:
- Database connectivity
- Redis connectivity  
- OpenAI API connectivity
- Overall service status

### Logging
All requests are logged with:
- Request method and URL
- Processing time
- Response status
- Client IP address
- Error details (if any)

### Performance
- Async architecture for high concurrency
- Database connection pooling
- Redis caching for frequently accessed data
- Gzip compression for responses

## 🚨 Error Handling

The API provides consistent error responses:
```json
{
  "error": {
    "code": "QUOTE_NOT_FOUND",
    "message": "Quote with ID {id} not found",
    "details": {}
  }
}
```

Common error codes:
- `QUOTE_NOT_FOUND` - Quote doesn't exist
- `CONVERSATION_NOT_FOUND` - Conversation doesn't exist
- `INVALID_PARAMETERS` - Invalid request parameters
- `OPENAI_API_ERROR` - OpenAI service unavailable
- `INTERNAL_SERVER_ERROR` - Unexpected server error

## 🔒 Security

- Environment-based configuration
- Request validation with Pydantic
- Rate limiting protection
- CORS middleware for web clients
- Secure error messages (no data leakage)

## 🚀 Deployment

### Docker Deployment
```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
CMD ["python", "start_server.py"]
```

### Production Considerations
- Set `DEBUG=false`
- Use environment variables for secrets
- Configure proper CORS origins
- Set up reverse proxy (nginx)
- Use production WSGI server
- Enable SSL/TLS
- Set up monitoring and logging

## 📚 API Documentation

When running in debug mode, interactive documentation is available at:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## 🤝 Integration with iOS App

This FastAPI server is designed to complement the existing iOS Daily Quote app:

1. **Quote Sync**: Use the same quote data and categorization logic
2. **AI Chat**: Enhanced chat functionality with conversation persistence
3. **Multi-platform**: Support for web, mobile, and other clients
4. **Analytics**: Track quote views and user engagement
5. **Scalability**: Handle multiple users and high request volumes

## 💡 Tips

- Start with a small OpenAI quota for testing
- Use Redis for production caching
- Monitor API health endpoints
- Set up log aggregation for production
- Consider rate limiting for public APIs
- Backup database regularly

## 🐛 Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Check PostgreSQL is running
   - Verify connection string
   - Ensure database exists

2. **Redis Connection Failed**
   - Check Redis is running
   - Verify Redis URL
   - Check firewall settings

3. **OpenAI API Errors**
   - Verify API key is correct
   - Check OpenAI account has credits
   - Monitor rate limits

4. **Import Errors**
   - Install all requirements: `pip install -r requirements.txt`
   - Check Python version (3.8+)
   - Verify virtual environment

For more help, check the logs or health endpoint for detailed error information. 