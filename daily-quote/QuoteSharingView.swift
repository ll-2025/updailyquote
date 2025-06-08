import SwiftUI

struct QuoteSharingView: View {
    let quote: Quote
    @State private var selectedStyle: QuoteImageGenerator.BackgroundStyle = .gradient
    @State private var showingShareSheet = false
    @State private var generatedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Preview of generated image
                if let image = generatedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxWidth: 300, maxHeight: 300)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                } else {
                    // Preview placeholder
                    RoundedRectangle(cornerRadius: 20)
                        .fill(previewGradient(for: selectedStyle))
                        .frame(width: 300, height: 300)
                        .overlay(
                            VStack {
                                Text("\"")
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(.white.opacity(0.3))
                                
                                Text(quote.text)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 40)
                                    .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
                                
                                Text("— \(quote.author)")
                                    .font(.subheadline)
                                    .italic()
                                    .foregroundColor(.white.opacity(0.9))
                                    .padding(.top, 20)
                                    .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
                            }
                        )
                        .shadow(radius: 10)
                }
                
                // Style selection
                Text("Choose Style")
                    .font(.headline)
                    .padding(.top)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                    ForEach(QuoteImageGenerator.BackgroundStyle.allCases, id: \.self) { style in
                        VStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(previewGradient(for: style))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedStyle == style ? Color.blue : Color.clear, lineWidth: 3)
                                )
                                .onTapGesture {
                                    selectedStyle = style
                                    generateImage()
                                }
                            
                            Text(style.displayName)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 20) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.secondary)
                    
                    Button("Generate & Share") {
                        if generatedImage == nil {
                            generateImage()
                        }
                        showingShareSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(generatedImage == nil)
                }
                .padding(.bottom, 30)
            }
            .padding()
            .navigationTitle("Share Quote")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            generateImage()
        }
        .sheet(isPresented: $showingShareSheet) {
            if let image = generatedImage {
                ShareSheet(activityItems: [image])
            }
        }
    }
    
    private func generateImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            let image = QuoteImageGenerator.generateImage(from: quote, style: selectedStyle)
            DispatchQueue.main.async {
                self.generatedImage = image
            }
        }
    }
    
    private func previewGradient(for style: QuoteImageGenerator.BackgroundStyle) -> LinearGradient {
        switch style {
        case .gradient:
            return LinearGradient(
                colors: [Color.purple, Color.blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .minimal:
            return LinearGradient(
                colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .nature:
            return LinearGradient(
                colors: [Color.green.opacity(0.8), Color.green.opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .abstract:
            return LinearGradient(
                colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .sunset:
            return LinearGradient(
                colors: [Color.orange, Color.pink, Color.purple],
                startPoint: .top,
                endPoint: .bottom
            )
        case .ocean:
            return LinearGradient(
                colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.8)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .galaxy:
            return LinearGradient(
                colors: [Color.black, Color.purple.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .geometric:
            return LinearGradient(
                colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .rainyDay:
            return LinearGradient(
                colors: [Color.gray.opacity(0.8), Color.gray.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .studyAtHome:
            return LinearGradient(
                colors: [Color.brown.opacity(0.3), Color.brown.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .coffee:
            return LinearGradient(
                colors: [Color.brown.opacity(0.8), Color.brown.opacity(0.4)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .mountains:
            return LinearGradient(
                colors: [Color.blue.opacity(0.4), Color.green.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

#Preview {
    QuoteSharingView(quote: Quote(text: "The only way to do great work is to love what you do.", author: "Steve Jobs"))
} 