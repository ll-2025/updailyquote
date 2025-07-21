# FastAPI Server Design for Daily Quote App

## API Overview
Base URL: `http://localhost:8000`

## Authentication
- Bearer token authentication for protected endpoints
- API key authentication for external integrations

## 1. Quote Generation Endpoints

### GET /api/v1/quotes/random
Get a random quote with optional filtering
```json
{
  "language": "en|es|zh",
  "category": "success|life|motivation|leadership|creativity|happiness|wisdom|perseverance",
  "exclude_recent": true
}
```

Response:
```json
{
  "id": "uuid",
  "text": "The only way to do great work is to love what you do.",
  "author": "Steve Jobs",
  "category": "success",
  "language": "en",
  "created_at": "2025-01-27T10:00:00Z"
}
```

### GET /api/v1/quotes/{quote_id}
Get a specific quote by ID

### GET /api/v1/quotes/categories
Get all available quote categories

### GET /api/v1/quotes/languages
Get all supported languages

### POST /api/v1/quotes/favorite
Add a quote to favorites
```json
{
  "quote_id": "uuid",
  "user_id": "uuid"
}
```

### GET /api/v1/quotes/favorites
Get user's favorite quotes

## 2. AI Chat Endpoints

### POST /api/v1/chat/conversations
Create a new chat conversation
```json
{
  "quote_id": "uuid",
  "user_id": "uuid"
}
```

Response:
```json
{
  "conversation_id": "uuid",
  "quote_context": {
    "text": "Quote text",
    "author": "Author name"
  },
  "messages": [
    {
      "id": "uuid",
      "content": "Hello! I'm here to discuss this quote with you.",
      "is_from_user": false,
      "timestamp": "2025-01-27T10:00:00Z"
    }
  ]
}
```

### POST /api/v1/chat/conversations/{conversation_id}/messages
Send a message to the conversation
```json
{
  "message": "What does this quote mean?",
  "user_id": "uuid"
}
```

Response:
```json
{
  "message_id": "uuid",
  "ai_response": {
    "id": "uuid",
    "content": "This quote by Steve Jobs emphasizes...",
    "is_from_user": false,
    "timestamp": "2025-01-27T10:00:00Z"
  }
}
```

### GET /api/v1/chat/conversations/{conversation_id}
Get conversation history

### DELETE /api/v1/chat/conversations/{conversation_id}
Clear conversation history

## 3. Quote Image Generation Endpoints

### POST /api/v1/quotes/generate-image
Generate shareable quote image
```json
{
  "quote_id": "uuid",
  "style": "coffee|mountains|ocean|rainyDay|clouds|activity|galaxy|study|sunset",
  "format": "png|jpeg",
  "size": "1080x1080|1920x1080"
}
```

Response:
```json
{
  "image_url": "/api/v1/images/{image_id}",
  "image_id": "uuid",
  "expires_at": "2025-01-28T10:00:00Z"
}
```

### GET /api/v1/images/{image_id}
Download generated image

## 4. User Management Endpoints

### POST /api/v1/users/register
Register a new user

### POST /api/v1/users/login
Authenticate user

### GET /api/v1/users/profile
Get user profile

### PUT /api/v1/users/preferences
Update user preferences
```json
{
  "language": "en",
  "categories": ["success", "motivation"],
  "theme": "dark|light|system"
}
```

## 5. Analytics Endpoints

### POST /api/v1/analytics/quote-viewed
Track quote views

### POST /api/v1/analytics/quote-shared
Track quote shares

### GET /api/v1/analytics/dashboard
Get usage analytics (admin only)

## 6. Health & Status Endpoints

### GET /api/v1/health
Health check endpoint

### GET /api/v1/status
API status and version info

## Error Responses
Standard error format:
```json
{
  "error": {
    "code": "QUOTE_NOT_FOUND",
    "message": "Quote with ID {id} not found",
    "details": {}
  }
}
```

## Rate Limiting
- 100 requests per minute for quote endpoints
- 20 requests per minute for AI chat endpoints
- 10 requests per minute for image generation

## WebSocket Support (Future)
- Real-time chat updates
- Live quote of the day broadcasts 