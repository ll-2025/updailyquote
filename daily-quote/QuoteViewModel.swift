import Foundation
import SwiftUI

enum QuoteLanguage: String, CaseIterable {
    case english = "en"
    case spanish = "es"
    case chinese = "zh"
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Español"
        case .chinese: return "中文"
        }
    }
    
    var flag: String {
        switch self {
        case .english: return "🇺🇸"
        case .spanish: return "🇪🇸"
        case .chinese: return "🇨🇳"
        }
    }
}

class QuoteViewModel: ObservableObject {
    @Published var currentQuote: Quote
    @Published var isShareSheetPresented = false
    @Published var isImageShareSheetPresented = false
    @Published var shareImage: UIImage?
    @Published var favoriteQuotes: [Quote] = []
    @Published var themeMode: ThemeMode {
        didSet {
            userDefaults.set(themeMode.rawValue, forKey: themeModeKey)
        }
    }
    @Published var selectedLanguage: QuoteLanguage {
        didSet {
            userDefaults.set(selectedLanguage.rawValue, forKey: languageKey)
            loadQuotes()
            generateNewQuote()
        }
    }
    
    private var quotes: [Quote] = []
    private let userDefaults = UserDefaults.standard
    
    // Keys for UserDefaults
    private let lastQuoteTextKey = "lastQuoteText"
    private let lastQuoteAuthorKey = "lastQuoteAuthor"
    private let lastShownDateKey = "lastShownDate"
    private let languageKey = "selectedLanguage"
    private let favoritesKey = "favoriteQuotes"
    private let themeModeKey = "themeMode"
    
    init() {
        // Initialize with a default quote
        currentQuote = Quote(text: "Loading...", author: "")
        
        // Load saved language preference or default to English
        let savedLanguage = userDefaults.string(forKey: languageKey) ?? QuoteLanguage.english.rawValue
        selectedLanguage = QuoteLanguage(rawValue: savedLanguage) ?? .english
        
        // Load saved theme preference or default to system
        let savedTheme = userDefaults.string(forKey: themeModeKey) ?? ThemeMode.system.rawValue
        themeMode = ThemeMode(rawValue: savedTheme) ?? .system
        
        // Load quotes from JSON
        loadQuotes()
        
        // Load favorite quotes
        loadFavorites()
        
        // Check if we should use stored quote or generate a new one
        if shouldUseStoredQuote() {
            retrieveStoredQuote()
        } else {
            generateNewQuote()
        }
    }
    
    func loadQuotes() {
        let fileName = selectedLanguage == .english ? "QuoteData" : "QuoteData_\(selectedLanguage.rawValue)"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("Unable to locate \(fileName).json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            quotes = try JSONDecoder().decode([Quote].self, from: data)
        } catch {
            print("Error loading quotes: \(error)")
        }
    }
    
    func generateNewQuote() {
        guard !quotes.isEmpty else { return }
        
        let randomIndex = Int.random(in: 0..<quotes.count)
        currentQuote = quotes[randomIndex]
        
        // Store the new quote
        storeCurrentQuote()
    }
    
    func shareQuote() {
        isShareSheetPresented = true
    }
    
    @MainActor
    func shareQuoteAsImage(backgroundImageName: String) {
        print("🎨 Starting image generation...")
        print("Quote: \(currentQuote.text)")
        print("Background: \(backgroundImageName)")
        
        // TODO: Implement QuoteImageGenerator class
        // if let image = QuoteImageGenerator.generateImage(from: currentQuote, backgroundImageName: backgroundImageName) {
        //     print("✅ Image generated successfully")
        //     shareImage = image
        //     isImageShareSheetPresented = true
        // } else {
            // Fallback to text sharing if image generation fails
            shareQuote()
        // }
    }
    
    // MARK: - Favorites functionality
    
    func toggleFavorite(for quote: Quote) {
        if let index = favoriteQuotes.firstIndex(where: { $0.text == quote.text && $0.author == quote.author }) {
            favoriteQuotes.remove(at: index)
        } else {
            favoriteQuotes.append(quote)
        }
        saveFavorites()
    }
    
    func isQuoteFavorited(_ quote: Quote) -> Bool {
        return favoriteQuotes.contains { $0.text == quote.text && $0.author == quote.author }
    }
    
    func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(favoriteQuotes)
            userDefaults.set(data, forKey: favoritesKey)
        } catch {
            print("Error saving favorites: \(error)")
        }
    }
    
    private func loadFavorites() {
        guard let data = userDefaults.data(forKey: favoritesKey) else { return }
        
        do {
            favoriteQuotes = try JSONDecoder().decode([Quote].self, from: data)
        } catch {
            print("Error loading favorites: \(error)")
        }
    }
    
    // MARK: - Theme functionality
    
    func setTheme(_ theme: ThemeMode) {
        themeMode = theme
    }
    
    // MARK: - Helper methods for persistence
    
    private func shouldUseStoredQuote() -> Bool {
        guard let lastShownDate = userDefaults.object(forKey: lastShownDateKey) as? Date else {
            return false
        }
        
        return Calendar.current.isDateInToday(lastShownDate)
    }
    
    private func storeCurrentQuote() {
        userDefaults.set(currentQuote.text, forKey: lastQuoteTextKey)
        userDefaults.set(currentQuote.author, forKey: lastQuoteAuthorKey)
        userDefaults.set(Date(), forKey: lastShownDateKey)
    }
    
    private func retrieveStoredQuote() {
        guard let text = userDefaults.string(forKey: lastQuoteTextKey),
              let author = userDefaults.string(forKey: lastQuoteAuthorKey) else {
            generateNewQuote()
            return
        }
        
        currentQuote = Quote(text: text, author: author)
    }
} 