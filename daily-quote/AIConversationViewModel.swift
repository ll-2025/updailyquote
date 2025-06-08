import Foundation
import SwiftUI

@MainActor
class AIConversationViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isRecording = false
    @Published var currentQuote: Quote?
    @Published var isConnected = false
    
    private let apiKey = OpenAIConfiguration.shared.apiKey
    
    init() {
        setupAIConnection()
        addInitialSystemMessage()
    }
    
    private func setupAIConnection() {
        // For iOS 15+ compatibility, we only use Chat API
        // Voice features require iOS 17+ and the OpenAI Realtime package
        isConnected = true // Chat API is always available
        print("✅ AI Chat ready (Chat API mode)")
    }
    
    func setCurrentQuote(_ quote: Quote) {
        self.currentQuote = quote
        addQuoteContextMessage(quote)
    }
    
    private func addInitialSystemMessage() {
        let systemMessage = ChatMessage(
            content: "Hello! I'm here to discuss quotes, their meanings, and help you explore wisdom from great thinkers. Feel free to ask me about any quote or share your thoughts!",
            isFromUser: false
        )
        messages.append(systemMessage)
    }
    
    private func addQuoteContextMessage(_ quote: Quote) {
        let contextMessage = ChatMessage(
            content: "I see you're viewing this quote: \"\(quote.text)\" by \(quote.author). What would you like to know about it?",
            isFromUser: false
        )
        messages.append(contextMessage)
    }
    
    func sendMessage(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        print("🔄 Sending message: \(text)")
        
        // Add user message immediately
        let userMessage = ChatMessage(content: text, isFromUser: true)
        messages.append(userMessage)
        
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                let response = try await callOpenAIChatAPI(with: text)
                await MainActor.run {
                    let aiMessage = ChatMessage(content: response, isFromUser: false)
                    self.messages.append(aiMessage)
                    self.isLoading = false
                }
                print("✅ Chat API response received")
            } catch {
                print("❌ Chat API failed: \(error)")
                
                // Check for quota errors and provide mock response
                let errorString = error.localizedDescription.lowercased()
                let isQuotaError = errorString.contains("quota") || 
                                 errorString.contains("insufficient") || 
                                 errorString.contains("exceeded") ||
                                 errorString.contains("billing")
                
                if isQuotaError {
                    print("💡 Quota exceeded - using mock response")
                    await provideMockResponse(for: text)
                    return
                }
                
                await MainActor.run {
                    self.errorMessage = "Failed to get response: \(error.localizedDescription)"
                    self.isLoading = false
                }
                
                // As a fallback, provide a mock response so the app remains functional
                print("🆘 Providing fallback mock response")
                await provideMockResponse(for: text)
            }
        }
    }
    
    private func callOpenAIChatAPI(with message: String) async throws -> String {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw URLError(.badURL)
        }
        
        print("🌐 Making Chat API request to: \(url)")
        print("🔑 API Key present: \(!apiKey.isEmpty)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30.0
        
        // Get current quote on main actor
        let quote = await MainActor.run { self.currentQuote }
        
        // Create messages array with context
        var apiMessages: [[String: String]] = [
            [
                "role": "system",
                "content": createSystemPrompt(for: quote)
            ]
        ]
        
        // Add recent conversation history (last 6 messages to keep context)
        let recentMessages = await MainActor.run { Array(self.messages.suffix(6)) }
        for msg in recentMessages {
            // Skip system messages to avoid confusion
            if !msg.content.contains("Hello! I'm here to discuss") && !msg.content.contains("I see you're viewing") {
                apiMessages.append([
                    "role": msg.isFromUser ? "user" : "assistant",
                    "content": msg.content
                ])
            }
        }
        
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": apiMessages,
            "max_tokens": 500,
            "temperature": 0.7
        ]
        
        print("📤 Request body: \(requestBody)")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("❌ Failed to serialize request: \(error)")
            throw error
        }
        
        print("🚀 Sending request...")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print("📥 Response received, status: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
        print("📄 Response data size: \(data.count) bytes")
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch httpResponse.statusCode {
        case 200:
            print("✅ HTTP 200 - Success")
            break
        case 401:
            print("❌ HTTP 401 - Invalid API key")
            throw NSError(domain: "OpenAI", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid API key. Please check your OpenAI API key."])
        case 429:
            print("❌ HTTP 429 - Rate limit exceeded")
            throw NSError(domain: "OpenAI", code: 429, userInfo: [NSLocalizedDescriptionKey: "Rate limit exceeded. Please try again later."])
        case 500...599:
            print("❌ HTTP \(httpResponse.statusCode) - Server error")
            throw NSError(domain: "OpenAI", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error. Please try again later."])
        default:
            print("❌ HTTP \(httpResponse.statusCode) - Unexpected status")
            throw URLError(.badServerResponse)
        }
        
        do {
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("❌ Failed to parse JSON")
                throw URLError(.cannotParseResponse)
            }
            
            print("📋 JSON keys: \(json.keys)")
            
            // Check for API errors
            if let error = json["error"] as? [String: Any],
               let errorMessage = error["message"] as? String {
                print("❌ API Error: \(errorMessage)")
                throw NSError(domain: "OpenAI", code: 400, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
            
            guard let choices = json["choices"] as? [[String: Any]],
                  let firstChoice = choices.first,
                  let messageObj = firstChoice["message"] as? [String: Any],
                  let content = messageObj["content"] as? String else {
                print("❌ Invalid response structure")
                print("Choices: \(json["choices"] ?? "nil")")
                throw URLError(.cannotParseResponse)
            }
            
            let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
            print("💬 AI Response: \(trimmedContent)")
            return trimmedContent
            
        } catch {
            print("❌ JSON parsing error: \(error)")
            throw error
        }
    }
    
    private func provideMockResponse(for userMessage: String) async {
        // Generate contextual mock responses based on the current quote
        let quote = await MainActor.run { self.currentQuote }
        
        var mockResponse = ""
        
        if quote != nil {
            if userMessage.lowercased().contains("when") || userMessage.lowercased().contains("author") {
                mockResponse = "Henry Ford said this during the early 20th century when he was revolutionizing manufacturing with the assembly line. This quote reflects his philosophy of positive thinking and self-belief that was crucial to his success."
            } else if userMessage.lowercased().contains("mean") || userMessage.lowercased().contains("meaning") {
                mockResponse = "This quote means that your mindset and beliefs about your capabilities directly influence your outcomes. Whether you believe you can succeed or believe you'll fail, you're likely to be right because your attitude shapes your actions and effort."
            } else {
                mockResponse = "This is a powerful quote about the psychology of success. Ford understood that confidence and self-belief are foundational to achievement. Our thoughts become our reality because they drive our actions and persistence."
            }
        } else {
            mockResponse = "I'd be happy to discuss the meaning and context of quotes with you. Please share a quote you'd like to explore!"
        }
        
        // Simulate thinking time
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        await MainActor.run {
            let aiMessage = ChatMessage(content: "🤖 [Mock Response] " + mockResponse, isFromUser: false)
            self.messages.append(aiMessage)
            self.isLoading = false
            print("✅ Mock response provided")
        }
    }
    
    private nonisolated func createSystemPrompt(for quote: Quote?) -> String {
        var prompt = """
        You are a wise and thoughtful AI assistant specializing in quotes, philosophy, and meaningful conversations. 
        Your role is to help users explore the deeper meanings behind quotes, discuss their philosophical implications, 
        and engage in meaningful dialogue about wisdom, life lessons, and personal growth.
        
        Keep your responses conversational, insightful, and engaging. Feel free to:
        - Explain the context and meaning behind quotes
        - Share related quotes or wisdom
        - Ask thought-provoking questions
        - Relate quotes to modern life and personal experiences
        - Discuss the authors and their philosophies
        
        Keep responses concise but meaningful (2-3 sentences typically).
        """
        
        if let quote = quote {
            prompt += "\n\nThe user is currently viewing this quote: \"\(quote.text)\" by \(quote.author). Use this as context for the conversation."
        }
        
        return prompt
    }
    
    func clearConversation() {
        messages.removeAll()
        addInitialSystemMessage()
        if let quote = currentQuote {
            addQuoteContextMessage(quote)
        }
    }
    
    // Voice recording functionality - Not available in iOS 15 compatible version
    func startRecording() {
        errorMessage = "Voice features require iOS 17+ and the OpenAI Realtime package. Please use text chat."
    }
    
    func stopRecording() {
        isRecording = false
    }
    
    func startVoiceHandling() {
        errorMessage = "Voice features require iOS 17+ and the OpenAI Realtime package. Please use text chat."
    }
    
    func stopVoiceHandling() {
        // No-op for iOS 15 compatibility
    }
} 