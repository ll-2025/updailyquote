import SwiftUI

struct AppIconPreview: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "5E72EB"),
                    Color(hex: "FF9190")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .aspectRatio(1, contentMode: .fit)
            
            // Central design - quotation marks
            ZStack {
                // White background for quotes
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.85))
                    .frame(width: 200, height: 200)
                    .shadow(color: Color.black.opacity(0.1), radius: 8)
                
                // Stylized quotation mark
                VStack(spacing: -20) {
                    Image(systemName: "quote.opening")
                        .font(.system(size: 100, weight: .bold))
                        .foregroundColor(Color(hex: "5E72EB"))
                    
                    Text("daily")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(hex: "5E72EB"))
                    
                    Text("quote")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(hex: "FF9190"))
                }
            }
        }
        .cornerRadius(90)
        .frame(width: 512, height: 512)
        .padding(50)
        .background(Color.white)
    }
}

// Helper extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    AppIconPreview()
} 