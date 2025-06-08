//
//  ContentView.swift
//  daily-quote
//
//  Created by lb on 4/13/25.
//

import SwiftUI

// Add localization extension for ContentView
extension QuoteLanguage {
    func localizedContentText(_ key: String) -> String {
        switch self {
        case .english:
            switch key {
            case "addToFavorites": return "Add to Favorites"
            case "removeFromFavorites": return "Remove from Favorites"
            case "newQuote": return "New Quote"
            case "share": return "Share"
            case "aiChat": return "AI Chat"
            default: return key
            }
        case .spanish:
            switch key {
            case "addToFavorites": return "Añadir a Favoritos"
            case "removeFromFavorites": return "Quitar de Favoritos"
            case "newQuote": return "Nueva Cita"
            case "share": return "Compartir"
            case "aiChat": return "Chat de IA"
            default: return key
            }
        case .chinese:
            switch key {
            case "addToFavorites": return "添加到收藏"
            case "removeFromFavorites": return "从收藏中移除"
            case "newQuote": return "新引言"
            case "share": return "分享"
            case "aiChat": return "AI聊天"
            default: return key
            }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject private var quoteViewModel: QuoteViewModel
    @State private var quoteOpacity = 0.0
    @State private var wallpaperOpacity = 1.0
    @State private var currentBackgroundColors: [Color] = [Color.blue.opacity(0.3), Color.purple.opacity(0.2)]
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingFavorites = false
    @State private var showingThemeSettings = false
    @State private var showingLanguageSettings = false
    @State private var showingAIChat = false
    
    // Array of beautiful gradient combinations
    private let backgroundColorSets: [[Color]] = [
        [Color.blue.opacity(0.3), Color.purple.opacity(0.2)],
        [Color.pink.opacity(0.3), Color.orange.opacity(0.2)],
        [Color.green.opacity(0.3), Color.teal.opacity(0.2)],
        [Color.purple.opacity(0.3), Color.indigo.opacity(0.2)],
        [Color.orange.opacity(0.3), Color.red.opacity(0.2)],
        [Color.teal.opacity(0.3), Color.cyan.opacity(0.2)],
        [Color.indigo.opacity(0.3), Color.blue.opacity(0.2)],
        [Color.mint.opacity(0.3), Color.green.opacity(0.2)]
    ]
    
    // Computed property for theme-based appearance
    private var effectiveColorScheme: ColorScheme? {
        switch quoteViewModel.themeMode {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
    
    private func generateNewBackgroundColors() {
        let randomIndex = Int.random(in: 0..<backgroundColorSets.count)
        currentBackgroundColors = backgroundColorSets[randomIndex]
    }
    
    var body: some View {
        ZStack {
            // Dynamic background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    colorScheme == .dark ? Color.black : Color.white,
                    colorScheme == .dark ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Dynamic color overlay gradient
            LinearGradient(
                gradient: Gradient(colors: currentBackgroundColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .opacity(wallpaperOpacity)
            
            // Overlay gradient for better readability
            LinearGradient(
                gradient: Gradient(colors: [
                    colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7),
                    colorScheme == .dark ? Color.black.opacity(0.4) : Color.white.opacity(0.5)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header toolbar
                HStack {
                    Button(action: {
                        showingThemeSettings = true
                    }) {
                        Image(systemName: "paintbrush.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.accentColor)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.accentColor.opacity(0.1))
                            )
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingLanguageSettings = true
                    }) {
                        Image(systemName: "globe")
                            .font(.system(size: 18))
                            .foregroundColor(.accentColor)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.accentColor.opacity(0.1))
                            )
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingFavorites = true
                    }) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.accentColor)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.accentColor.opacity(0.1))
                            )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Spacer()
                
                VStack(spacing: 24) {
                    // Quote marks
                    Image(systemName: "quote.opening")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color.primary.opacity(0.2))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    
                    // Quote text
                    Text(quoteViewModel.currentQuote.text)
                        .font(.system(size: 24, weight: .medium, design: .serif))
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .padding(.horizontal)
                        .opacity(quoteOpacity)
                    
                    // Author
                    HStack {
                        Spacer()
                        Text("— \(quoteViewModel.currentQuote.author)")
                            .font(.system(size: 16, weight: .regular, design: .serif))
                            .foregroundColor(.secondary)
                            .italic()
                            .padding(.trailing, 24)
                            .opacity(quoteOpacity)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.secondarySystemGroupedBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 2)
                )
                .padding(.horizontal, 24)
                
                Spacer()
                
                VStack(spacing: 16) {
                    // AI Chat button
                    Button(action: {
                        showingAIChat = true
                    }) {
                        HStack {
                            Image(systemName: "brain.filled.head.profile")
                                .font(.system(size: 16))
                            Text(quoteViewModel.selectedLanguage.localizedContentText("aiChat"))
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, Color.blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: Color.purple.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                    
                    // Favorite button
                    Button(action: {
                        quoteViewModel.toggleFavorite(for: quoteViewModel.currentQuote)
                    }) {
                        HStack {
                            Image(systemName: quoteViewModel.isQuoteFavorited(quoteViewModel.currentQuote) ? "heart.fill" : "heart")
                            Text(quoteViewModel.isQuoteFavorited(quoteViewModel.currentQuote) ? quoteViewModel.selectedLanguage.localizedContentText("removeFromFavorites") : quoteViewModel.selectedLanguage.localizedContentText("addToFavorites"))
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.accentColor, lineWidth: 1.5)
                        )
                        .foregroundColor(.accentColor)
                    }
                    
                    // New Quote button - Refined UI
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            quoteOpacity = 0
                            wallpaperOpacity = 0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            quoteViewModel.generateNewQuote()
                            generateNewBackgroundColors()
                            
                            withAnimation(.easeInOut(duration: 0.3)) {
                                quoteOpacity = 1.0
                                wallpaperOpacity = 1.0
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                                .font(.system(size: 16))
                            Text(quoteViewModel.selectedLanguage.localizedContentText("newQuote"))
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: Color.accentColor.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                    
                    // Share button
                    Button(action: {
                        quoteViewModel.shareQuote()
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text(quoteViewModel.selectedLanguage.localizedContentText("share"))
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.accentColor, lineWidth: 1.5)
                        )
                        .foregroundColor(.accentColor)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .preferredColorScheme(effectiveColorScheme)
        .onAppear {
            generateNewBackgroundColors()
            withAnimation(.easeInOut(duration: 0.7)) {
                quoteOpacity = 1.0
                wallpaperOpacity = 1.0
            }
        }
        .sheet(isPresented: $quoteViewModel.isShareSheetPresented) {
            ShareSheet(text: "\"\(quoteViewModel.currentQuote.text)\" — \(quoteViewModel.currentQuote.author)")
        }
        .sheet(isPresented: $showingFavorites) {
            FavoritesView()
        }
        .sheet(isPresented: $showingThemeSettings) {
            ThemeSettingsView()
        }
        .sheet(isPresented: $showingLanguageSettings) {
            LanguageSettingsView()
        }
        .fullScreenCover(isPresented: $showingAIChat) {
            AIChatView(currentQuote: quoteViewModel.currentQuote)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(QuoteViewModel())
}
