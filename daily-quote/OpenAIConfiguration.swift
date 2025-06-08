import Foundation

struct OpenAIConfiguration {
    static let shared = OpenAIConfiguration()
    
    // Replace with your OpenAI API key
    // For security, consider loading this from a secure keychain or environment variable
    var apiKey: String {
        // You can set this in Xcode build settings or environment variables
        return ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? "your-openai-api-key-here"
    }
    
    private init() {}
} 