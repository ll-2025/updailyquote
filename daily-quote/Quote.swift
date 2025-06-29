import Foundation

enum QuoteCategory: String, CaseIterable, Codable {
    case success = "Success"
    case life = "Life"
    case motivation = "Motivation"
    case leadership = "Leadership"
    case creativity = "Creativity"
    case happiness = "Happiness"
    case wisdom = "Wisdom"
    case perseverance = "Perseverance"
    
    var displayName: String {
        return self.rawValue
    }
    
    // Localized display name based on selected language
    func localizedDisplayName(for language: QuoteLanguage) -> String {
        switch language {
        case .english:
            return self.rawValue
        case .spanish:
            switch self {
            case .success: return "Éxito"
            case .life: return "Vida"
            case .motivation: return "Motivación"
            case .leadership: return "Liderazgo"
            case .creativity: return "Creatividad"
            case .happiness: return "Felicidad"
            case .wisdom: return "Sabiduría"
            case .perseverance: return "Perseverancia"
            }
        case .chinese:
            switch self {
            case .success: return "成功"
            case .life: return "生活"
            case .motivation: return "动机"
            case .leadership: return "领导"
            case .creativity: return "创意"
            case .happiness: return "快乐"
            case .wisdom: return "智慧"
            case .perseverance: return "毅力"
            }
        }
    }
    
    var icon: String {
        switch self {
        case .success: return "trophy.fill"
        case .life: return "heart.fill"
        case .motivation: return "flame.fill"
        case .leadership: return "person.3.fill"
        case .creativity: return "lightbulb.fill"
        case .happiness: return "sun.max.fill"
        case .wisdom: return "book.fill"
        case .perseverance: return "mountain.2.fill"
        }
    }
    
    var color: String {
        switch self {
        case .success: return "orange"
        case .life: return "pink"
        case .motivation: return "red"
        case .leadership: return "blue"
        case .creativity: return "purple"
        case .happiness: return "yellow"
        case .wisdom: return "indigo"
        case .perseverance: return "green"
        }
    }
}

struct Quote: Identifiable, Codable {
    var id: UUID {
        UUID()
    }
    
    let text: String
    let author: String
    let category: QuoteCategory
    
    enum CodingKeys: String, CodingKey {
        case text, author, category
    }
    
    // For backward compatibility with existing quotes without categories
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        author = try container.decode(String.self, forKey: .author)
        
        // If category exists, use it; otherwise, determine category based on content
        if let categoryValue = try? container.decode(QuoteCategory.self, forKey: .category) {
            category = categoryValue
        } else {
            // Auto-categorize based on keywords in the quote text
            category = Self.categorizeQuote(text: text, author: author)
        }
    }
    
    init(text: String, author: String, category: QuoteCategory = .motivation) {
        self.text = text
        self.author = author
        self.category = category
    }
    
    // Auto-categorization logic
    static func categorizeQuote(text: String, author: String) -> QuoteCategory {
        let lowercaseText = text.lowercased()
        let lowercaseAuthor = author.lowercased()
        
        // Success keywords (English, Spanish, Chinese)
        if lowercaseText.contains("success") || lowercaseText.contains("achieve") || 
           lowercaseText.contains("goal") || lowercaseText.contains("win") ||
           lowercaseText.contains("victory") || lowercaseText.contains("accomplish") ||
           lowercaseText.contains("éxito") || lowercaseText.contains("lograr") ||
           lowercaseText.contains("meta") || lowercaseText.contains("ganar") ||
           lowercaseText.contains("成功") || lowercaseText.contains("成就") ||
           lowercaseText.contains("目标") || lowercaseText.contains("胜利") ||
           lowercaseText.contains("达成") || lowercaseText.contains("实现") {
            return .success
        }
        
        // Life keywords (English, Spanish, Chinese)
        if lowercaseText.contains("life") || lowercaseText.contains("live") ||
           lowercaseText.contains("exist") || lowercaseText.contains("born") ||
           lowercaseText.contains("vida") || lowercaseText.contains("vivir") ||
           lowercaseText.contains("existir") || lowercaseText.contains("nacer") ||
           lowercaseText.contains("生活") || lowercaseText.contains("生命") ||
           lowercaseText.contains("活着") || lowercaseText.contains("存在") ||
           lowercaseText.contains("出生") {
            return .life
        }
        
        // Leadership keywords (English, Spanish, Chinese)
        if lowercaseText.contains("lead") || lowercaseText.contains("others") ||
           lowercaseText.contains("people") || lowercaseText.contains("world") ||
           lowercaseText.contains("liderar") || lowercaseText.contains("otros") ||
           lowercaseText.contains("gente") || lowercaseText.contains("mundo") ||
           lowercaseText.contains("领导") || lowercaseText.contains("他人") ||
           lowercaseText.contains("人们") || lowercaseText.contains("世界") ||
           lowercaseAuthor.contains("roosevelt") || lowercaseAuthor.contains("churchill") ||
           lowercaseAuthor.contains("kennedy") || lowercaseAuthor.contains("mandela") ||
           lowercaseAuthor.contains("甘地") || lowercaseAuthor.contains("曼德拉") {
            return .leadership
        }
        
        // Creativity keywords (English, Spanish, Chinese)
        if lowercaseText.contains("creat") || lowercaseText.contains("imaginat") ||
           lowercaseText.contains("art") || lowercaseText.contains("dream") ||
           lowercaseText.contains("crear") || lowercaseText.contains("imaginar") ||
           lowercaseText.contains("arte") || lowercaseText.contains("sueño") ||
           lowercaseText.contains("创造") || lowercaseText.contains("想象") ||
           lowercaseText.contains("艺术") || lowercaseText.contains("梦想") ||
           lowercaseAuthor.contains("einstein") || lowercaseAuthor.contains("disney") ||
           lowercaseAuthor.contains("van gogh") || lowercaseAuthor.contains("picasso") ||
           lowercaseAuthor.contains("爱因斯坦") || lowercaseAuthor.contains("迪士尼") ||
           lowercaseAuthor.contains("毕加索") {
            return .creativity
        }
        
        // Happiness keywords (English, Spanish, Chinese)
        if lowercaseText.contains("happy") || lowercaseText.contains("joy") ||
           lowercaseText.contains("smile") || lowercaseText.contains("laugh") ||
           lowercaseText.contains("pleasure") || lowercaseText.contains("feliz") ||
           lowercaseText.contains("alegría") || lowercaseText.contains("sonreír") ||
           lowercaseText.contains("reír") || lowercaseText.contains("placer") ||
           lowercaseText.contains("幸福") || lowercaseText.contains("快乐") ||
           lowercaseText.contains("开心") || lowercaseText.contains("欢乐") ||
           lowercaseText.contains("微笑") {
            return .happiness
        }
        
        // Wisdom keywords (English, Spanish, Chinese)
        if lowercaseText.contains("wisdom") || lowercaseText.contains("learn") ||
           lowercaseText.contains("know") || lowercaseText.contains("understand") ||
           lowercaseText.contains("truth") || lowercaseText.contains("sabiduría") ||
           lowercaseText.contains("aprender") || lowercaseText.contains("saber") ||
           lowercaseText.contains("entender") || lowercaseText.contains("verdad") ||
           lowercaseText.contains("智慧") || lowercaseText.contains("学习") ||
           lowercaseText.contains("知道") || lowercaseText.contains("理解") ||
           lowercaseText.contains("真理") || lowercaseText.contains("学会") ||
           lowercaseAuthor.contains("confucius") || lowercaseAuthor.contains("buddha") ||
           lowercaseAuthor.contains("aristotle") || lowercaseAuthor.contains("老子") ||
           lowercaseAuthor.contains("孔子") || lowercaseAuthor.contains("佛陀") ||
           lowercaseAuthor.contains("亚里士多德") {
            return .wisdom
        }
        
        // Perseverance keywords (English, Spanish, Chinese)
        if lowercaseText.contains("persever") || lowercaseText.contains("persist") ||
           lowercaseText.contains("continue") || lowercaseText.contains("never give up") ||
           lowercaseText.contains("keep going") || lowercaseText.contains("endure") ||
           lowercaseText.contains("overcome") || lowercaseText.contains("perseverar") ||
           lowercaseText.contains("persistir") || lowercaseText.contains("continuar") ||
           lowercaseText.contains("nunca rendirse") || lowercaseText.contains("seguir") ||
           lowercaseText.contains("resistir") || lowercaseText.contains("superar") ||
           lowercaseText.contains("坚持") || lowercaseText.contains("毅力") ||
           lowercaseText.contains("持续") || lowercaseText.contains("永不放弃") ||
           lowercaseText.contains("继续") || lowercaseText.contains("忍耐") ||
           lowercaseText.contains("克服") {
            return .perseverance
        }
        
        // Default to motivation
        return .motivation
    }
}