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
            case "like": return "Like"
            case "liked": return "Liked"
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
            case "like": return "Me gusta"
            case "liked": return "Te gusta"
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
            case "like": return "喜欢"
            case "liked": return "已喜欢"
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
    @State private var heartBeat = false
    @State private var shareRotation = 0.0
    
    // Keep your existing beautiful color system
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
            // Keep your existing beautiful wallpaper system
            LinearGradient(
                gradient: Gradient(colors: [
                    colorScheme == .dark ? Color.black : Color.white,
                    colorScheme == .dark ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Keep your dynamic color overlay gradient 
            LinearGradient(
                gradient: Gradient(colors: currentBackgroundColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .opacity(wallpaperOpacity)
            
            // Keep your overlay gradient for readability
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
                // Instagram-style header with your icons
                HStack(spacing: 16) {
                    // App branding like Instagram
                    Text("Daily Quote")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Social app style icon row
                    HStack(spacing: 16) {
                        ModernIconButton(icon: "paintbrush.fill", color: .accentColor) {
                            showingThemeSettings = true
                        }
                        
                        ModernIconButton(icon: "slider.horizontal.3", color: .accentColor) {
                            showingCategorySettings = true
                        }
                        
                        ModernIconButton(icon: "globe", color: .accentColor) {
                            showingLanguageSettings = true
                        }
                        
                        ModernIconButton(icon: "heart.fill", color: .accentColor) {
                            showingFavorites = true
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
                // Instagram-style post card
                VStack(spacing: 0) {
                    // Quote content like an Instagram post
                    VStack(spacing: 24) {
                        // Elegant quote display
                        VStack(spacing: 20) {
                            Text(quoteViewModel.currentQuote.text)
                                .font(.system(size: 26, weight: .medium, design: .serif))
                                .multilineTextAlignment(.center)
                                .lineSpacing(8)
                                .foregroundColor(.primary)
                                .opacity(quoteOpacity)
                            
                            Text("— \(quoteViewModel.currentQuote.author)")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.secondary)
                                .opacity(quoteOpacity)
                        }
                        
                        // Modern category tag
                        HStack(spacing: 8) {
                            Image(systemName: quoteViewModel.currentQuote.category.icon)
                                .font(.system(size: 13, weight: .semibold))
                            Text(quoteViewModel.currentQuote.category.localizedDisplayName(for: quoteViewModel.selectedLanguage))
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .textCase(.uppercase)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(categoryColor.opacity(0.15))
                        )
                        .foregroundColor(categoryColor)
                        .opacity(quoteOpacity)
                    }
                    .padding(.all, 32)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                colorScheme == .dark ? 
                                Color(UIColor.secondarySystemBackground).opacity(0.85) : 
                                Color.white.opacity(0.9)
                            )
                            .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
                    )
                    
                    // Instagram-style action bar
                    HStack(spacing: 24) {
                        // Heart button with animation - dynamic text for better feedback
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                heartBeat.toggle()
                                quoteViewModel.toggleFavorite(for: quoteViewModel.currentQuote)
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: quoteViewModel.isQuoteFavorited(quoteViewModel.currentQuote) ? "heart.fill" : "heart")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(quoteViewModel.isQuoteFavorited(quoteViewModel.currentQuote) ? .red : .primary)
                                    .scaleEffect(heartBeat ? 1.3 : 1.0)
                                
                                Text(quoteViewModel.isQuoteFavorited(quoteViewModel.currentQuote) ? 
                                     quoteViewModel.selectedLanguage.localizedContentText("liked") :
                                     quoteViewModel.selectedLanguage.localizedContentText("like"))
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        Spacer()
                        
                        // Share button with rotation - localized across languages
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                shareRotation += 360
                            }
                            quoteViewModel.shareQuote()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                    .rotationEffect(.degrees(shareRotation))
                                Text(quoteViewModel.selectedLanguage.localizedContentText("share"))
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 20)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Modern action buttons with social media style
                VStack(spacing: 16) {
                    // AI Chat - Instagram Story style
                    SocialButton(
                        title: quoteViewModel.selectedLanguage.localizedContentText("aiChat"),
                        icon: "brain.head.profile",
                        style: .gradient,
                        colors: [Color.purple, Color.blue]
                    ) {
                        showingAIChat = true
                    }
                    
                    // New Quote button - same size as AI Chat
                    SocialButton(
                        title: quoteViewModel.selectedLanguage.localizedContentText("newQuote"),
                        icon: "sparkles",
                        style: .gradient,
                        colors: [Color.accentColor, Color.accentColor.opacity(0.8)]
                    ) {
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
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
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

// Modern Instagram-style icon button
struct ModernIconButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                        .overlay(
                            Circle()
                                .strokeBorder(color.opacity(0.2), lineWidth: 1)
                        )
                )
                .scaleEffect(isPressed ? 0.9 : 1.0)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// Social media style button component
struct SocialButton: View {
    enum Style {
        case gradient, outline
    }
    
    let title: String
    let icon: String
    let style: Style
    let colors: [Color]
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(backgroundView)
            .foregroundColor(style == .gradient ? .white : colors.first)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        if style == .gradient {
            LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing
            )
            .shadow(color: colors.first?.opacity(0.3) ?? Color.clear, radius: 8, x: 0, y: 4)
        } else {
            RoundedRectangle(cornerRadius: 16)
                .stroke(colors.first ?? Color.accentColor, lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.systemBackground).opacity(0.8))
                )
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(QuoteViewModel())
}
