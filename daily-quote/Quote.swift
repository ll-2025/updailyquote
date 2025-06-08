import Foundation

struct Quote: Identifiable, Codable {
    var id: UUID {
        UUID()
    }
    
    let text: String
    let author: String
    
    enum CodingKeys: String, CodingKey {
        case text, author
    }
}