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
            case "categories": return "Categories"
            case "quoteCategories": return "Quote Categories"
            case "selectAll": return "Select All"
            case "clearAll": return "Clear All"
            case "save": return "Save"
            case "cancel": return "Cancel"
            case "resetOnboarding": return "Reset Onboarding"
            case "categoriesDescription": return "Choose the types of quotes you'd like to see. You can select multiple categories."
            case "categoriesSelected": return "categories selected"
            case "chooseInterests": return "Choose Your Interests"
            case "onboardingCategoriesDescription": return "Select the quote categories that inspire you most. You can change these later in settings."
            case "startReadingQuotes": return "Start Reading Quotes"
            case "selectAllCategories": return "Select All Categories"
            default: return key
            }
        case .spanish:
            switch key {
            case "addToFavorites": return "Añadir a Favoritos"
            case "removeFromFavorites": return "Quitar de Favoritos"
            case "newQuote": return "Nueva Cita"
            case "share": return "Compartir"
            case "aiChat": return "Chat de IA"
            case "categories": return "Categorías"
            case "quoteCategories": return "Categorías de Citas"
            case "selectAll": return "Seleccionar Todo"
            case "clearAll": return "Limpiar Todo"
            case "save": return "Guardar"
            case "cancel": return "Cancelar"
            case "resetOnboarding": return "Reiniciar Configuración"
            case "categoriesDescription": return "Elige los tipos de citas que te gustaría ver. Puedes seleccionar múltiples categorías."
            case "categoriesSelected": return "categorías seleccionadas"
            case "chooseInterests": return "Elige Tus Intereses"
            case "onboardingCategoriesDescription": return "Selecciona las categorías de citas que más te inspiran. Puedes cambiarlas más tarde en configuración."
            case "startReadingQuotes": return "Comenzar a Leer Citas"
            case "selectAllCategories": return "Seleccionar Todas las Categorías"
            default: return key
            }
        case .chinese:
            switch key {
            case "addToFavorites": return "添加到收藏"
            case "removeFromFavorites": return "从收藏中移除"
            case "newQuote": return "新引言"
            case "share": return "分享"
            case "aiChat": return "AI聊天"
            case "categories": return "类别"
            case "quoteCategories": return "引言类别"
            case "selectAll": return "选择全部"
            case "clearAll": return "清除全部"
            case "save": return "保存"
            case "cancel": return "取消"
            case "resetOnboarding": return "重置引导"
            case "categoriesDescription": return "选择您想看到的引言类型。您可以选择多个类别。"
            case "categoriesSelected": return "个类别已选择"
            case "chooseInterests": return "选择您的兴趣"
            case "onboardingCategoriesDescription": return "选择最能激发您灵感的引言类别。您可以稍后在设置中更改这些。"
            case "startReadingQuotes": return "开始阅读引言"
            case "selectAllCategories": return "选择所有类别"
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
    @State private var showingCategorySettings = false
    
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
    
    // Computed property for category color
    private var categoryColor: Color {
        switch quoteViewModel.currentQuote.category.color {
        case "orange": return .orange
        case "pink": return .pink
        case "red": return .red
        case "blue": return .blue
        case "purple": return .purple
        case "yellow": return .yellow
        case "indigo": return .indigo
        case "green": return .green
        default: return .accentColor
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
                        showingCategorySettings = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
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
                    
                    // Author and Category
                    VStack(spacing: 8) {
                        HStack {
                            Spacer()
                            Text("— \(quoteViewModel.currentQuote.author)")
                                .font(.system(size: 16, weight: .regular, design: .serif))
                                .foregroundColor(.secondary)
                                .italic()
                                .padding(.trailing, 24)
                                .opacity(quoteOpacity)
                        }
                        
                        // Category indicator
                        HStack {
                            Spacer()
                            HStack(spacing: 6) {
                                Image(systemName: quoteViewModel.currentQuote.category.icon)
                                    .font(.system(size: 12, weight: .medium))
                                Text(quoteViewModel.currentQuote.category.localizedDisplayName(for: quoteViewModel.selectedLanguage))
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(categoryColor.opacity(0.15))
                            )
                            .foregroundColor(categoryColor)
                            .opacity(quoteOpacity)
                            .padding(.trailing, 24)
                        }
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
        .sheet(isPresented: $quoteViewModel.showQuoteSharingView) {
            QuoteSharingView(quote: quoteViewModel.currentQuote)
        }
        .sheet(isPresented: $quoteViewModel.isImageShareSheetPresented) {
            if let image = quoteViewModel.shareImage {
                ShareSheet(activityItems: [image])
            }
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
        .sheet(isPresented: $showingCategorySettings) {
            CategorySettingsView()
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
