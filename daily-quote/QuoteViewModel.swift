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

@MainActor
class QuoteViewModel: ObservableObject {
    @Published var currentQuote: Quote
    @Published var isShareSheetPresented = false
    @Published var isImageShareSheetPresented = false
    @Published var showQuoteSharingView = false
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
    @Published var hasCompletedOnboarding: Bool = false
    @Published var selectedCategories: Set<QuoteCategory> = Set(QuoteCategory.allCases)
    
    private var quotes: [Quote] = []
    private var filteredQuotes: [Quote] = []
    private let userDefaults = UserDefaults.standard
    
    // Keys for UserDefaults
    private let lastQuoteTextKey = "lastQuoteText"
    private let lastQuoteAuthorKey = "lastQuoteAuthor"
    private let lastQuoteCategoryKey = "lastQuoteCategory"
    private let lastShownDateKey = "lastShownDate"
    private let languageKey = "selectedLanguage"
    private let favoritesKey = "favoriteQuotes"
    private let themeModeKey = "themeMode"
    private let onboardingCompletedKey = "hasCompletedOnboarding"
    private let selectedCategoriesKey = "selectedCategories"
    
    init() {
        // Initialize with a default quote
        currentQuote = Quote(text: "Loading...", author: "")
        
        // Load onboarding state
        hasCompletedOnboarding = userDefaults.bool(forKey: onboardingCompletedKey)
        
        // Load saved language preference or default to English
        let savedLanguage = userDefaults.string(forKey: languageKey) ?? QuoteLanguage.english.rawValue
        selectedLanguage = QuoteLanguage(rawValue: savedLanguage) ?? .english
        
        // Load saved theme preference or default to system
        let savedTheme = userDefaults.string(forKey: themeModeKey) ?? ThemeMode.system.rawValue
        themeMode = ThemeMode(rawValue: savedTheme) ?? .system
        
        // Load selected categories (after language and theme initialization)
        loadSelectedCategories()
        
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
            filterQuotesByCategories()
        } catch {
            print("Error loading quotes: \(error)")
        }
    }
    
    func generateNewQuote() {
        let quotesToUse = hasCompletedOnboarding ? filteredQuotes : quotes
        guard !quotesToUse.isEmpty else { return }
        
        let randomIndex = Int.random(in: 0..<quotesToUse.count)
        currentQuote = quotesToUse[randomIndex]
        
        // Store the new quote
        storeCurrentQuote()
    }
    
    private func filterQuotesByCategories() {
        if selectedCategories.isEmpty {
            filteredQuotes = quotes
        } else {
            filteredQuotes = quotes.filter { quote in
                selectedCategories.contains(quote.category)
            }
        }
        
        // If no quotes match the selected categories, fall back to all quotes
        if filteredQuotes.isEmpty {
            filteredQuotes = quotes
        }
    }
    
    func shareQuote() {
        showQuoteSharingView = true
    }
    
    func shareQuoteAsImage(style: QuoteImageGenerator.BackgroundStyle = .coffee) {
        print("🎨 Starting image generation...")
        print("Quote: \(currentQuote.text)")
        print("Style: \(style)")
        
        let quote = self.currentQuote // Capture the quote to avoid self capture issues
        
        Task {
            let image = await Task.detached {
                return QuoteImageGenerator.generateImage(from: quote, style: style)
            }.value
            
            if let image = image {
                print("✅ Image generated successfully")
                self.shareImage = image
                self.isImageShareSheetPresented = true
            } else {
                print("❌ Image generation failed, falling back to text sharing")
                // Fallback to text sharing if image generation fails
                self.shareQuote()
            }
        }
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
        userDefaults.set(currentQuote.category.rawValue, forKey: lastQuoteCategoryKey)
        userDefaults.set(Date(), forKey: lastShownDateKey)
    }
    
    private func retrieveStoredQuote() {
        guard let text = userDefaults.string(forKey: lastQuoteTextKey),
              let author = userDefaults.string(forKey: lastQuoteAuthorKey) else {
            generateNewQuote()
            return
        }
        
        // Try to retrieve the stored category, fallback to auto-categorization if not found
        let category: QuoteCategory
        if let categoryString = userDefaults.string(forKey: lastQuoteCategoryKey),
           let storedCategory = QuoteCategory(rawValue: categoryString) {
            category = storedCategory
        } else {
            // Fallback to auto-categorization for older stored quotes
            category = Quote.categorizeQuote(text: text, author: author)
        }
        
        currentQuote = Quote(text: text, author: author, category: category)
    }
    
    // MARK: - Onboarding functionality
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        userDefaults.set(true, forKey: onboardingCompletedKey)
        filterQuotesByCategories()
        generateNewQuote()
    }
    
    func setSelectedCategories(_ categories: Set<QuoteCategory>) {
        selectedCategories = categories
        saveSelectedCategories()
        filterQuotesByCategories()
        if hasCompletedOnboarding {
            generateNewQuote()
        }
    }
    
    private func saveSelectedCategories() {
        let categoryStrings = selectedCategories.map { $0.rawValue }
        userDefaults.set(categoryStrings, forKey: selectedCategoriesKey)
    }
    
    private func loadSelectedCategories() {
        guard let categoryStrings = userDefaults.array(forKey: selectedCategoriesKey) as? [String] else {
            // Default to all categories if none saved
            selectedCategories = Set(QuoteCategory.allCases)
            return
        }
        
        selectedCategories = Set(categoryStrings.compactMap { QuoteCategory(rawValue: $0) })
        
        // Ensure we have at least one category selected
        if selectedCategories.isEmpty {
            selectedCategories = Set(QuoteCategory.allCases)
        }
    }
    
    // MARK: - Category management
    
    func updateSelectedCategories(_ categories: Set<QuoteCategory>) {
        setSelectedCategories(categories)
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
        userDefaults.set(false, forKey: onboardingCompletedKey)
        selectedCategories = Set(QuoteCategory.allCases)
        saveSelectedCategories()
    }
} 