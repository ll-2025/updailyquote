import SwiftUI
import UIKit

// This is a utility view to help export the app icon
// You can take a screenshot of this view and use it as your app icon
struct AppIconExporter: View {
    var body: some View {
        VStack {
            Text("App Icon Preview")
                .font(.headline)
                .padding(.top)
            
            // This is the actual app icon design
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
                
                // Central design - quotation marks and white card
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
            .frame(width: 1024, height: 1024)
            
            Text("1024x1024 pixels - Export this image for App Store")
                .font(.caption)
                .padding(.bottom)
        }
    }
}

// Second design option - more minimalist
struct AlternateAppIcon: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "F9CDAD"),
                    Color(hex: "FC9D9D")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Simple quotation mark centered
            VStack(spacing: 5) {
                Image(systemName: "quote.opening")
                    .font(.system(size: 160, weight: .bold))
                    .foregroundColor(.white)
                    .offset(y: -10)
                
                Text("daily quote")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .offset(y: -20)
            }
        }
        .cornerRadius(90)
        .frame(width: 1024, height: 1024)
        .overlay(
            RoundedRectangle(cornerRadius: 90)
                .stroke(Color.white.opacity(0.3), lineWidth: 20)
        )
    }
}

// Use this as a standalone app to export the icon
struct IconGenerator: View {
    var body: some View {
        VStack {
            AppIconExporter()
                .frame(width: 1024, height: 1024)
                .background(Color.white)
            
            Button("Save Icon") {
                saveIcon()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding()
        }
    }
    
    func saveIcon() {
        // Logic to save the icon to Photos would go here
        // This would require a UIViewRepresentable and UIKit integration
    }
}

#Preview {
    VStack(spacing: 40) {
        AppIconExporter()
            .frame(width: 350, height: 350)
        
        AlternateAppIcon()
            .frame(width: 350, height: 350)
    }
    .padding()
} 