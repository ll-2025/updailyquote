import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var quoteViewModel: QuoteViewModel
    @State private var selectedCategories: Set<QuoteCategory> = []
    @State private var currentStep = 0
    @Environment(\.colorScheme) private var colorScheme
    @State private var logoRotation = 0.0
    @State private var floatingOffset = 0.0
    
    private let totalSteps = 2
    
    var body: some View {
        ZStack {
            // Instagram-style gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    colorScheme == .dark ? Color.black : Color.white,
                    colorScheme == .dark ? Color.purple.opacity(0.2) : Color.blue.opacity(0.1),
                    colorScheme == .dark ? Color.blue.opacity(0.1) : Color.purple.opacity(0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if currentStep == 0 {
                    welcomeStep
                } else {
                    categorySelectionStep
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                logoRotation = 360
            }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                floatingOffset = 10
            }
        }
    }
    
    private var welcomeStep: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Instagram-style app showcase
            VStack(spacing: 40) {
                // Modern app logo with animation
                ZStack {
                    // Gradient background circle
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.purple, Color.blue, Color.teal],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .shadow(color: Color.purple.opacity(0.4), radius: 16, x: 0, y: 8)
                        .offset(y: floatingOffset)
                    
                    Image(systemName: "quote.opening")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(logoRotation / 8))
                        .offset(y: floatingOffset)
                }
                
                // Social app style title
                VStack(spacing: 16) {
                    Text("Daily Quote")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Get inspired every day with personalized quotes that speak to your soul")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 40)
                }
            }
            
            Spacer()
            
            // Instagram Story-style features
            VStack(spacing: 20) {
                SocialFeatureCard(
                    icon: "sparkles",
                    title: "Daily Inspiration",
                    description: "Fresh quotes every day",
                    accentColor: .purple
                )
                
                SocialFeatureCard(
                    icon: "heart.fill",
                    title: "Save Favorites",
                    description: "Keep quotes that touch your heart",
                    accentColor: .red
                )
                
                SocialFeatureCard(
                    icon: "brain.head.profile",
                    title: "AI Chat",
                    description: "Discuss quotes with AI",
                    accentColor: .blue
                )
                
                SocialFeatureCard(
                    icon: "globe",
                    title: "Multi-Language",
                    description: "English • Español • 中文",
                    accentColor: .green
                )
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Social app style CTA button
            SocialButton(
                title: "Get Started",
                icon: "arrow.right.circle.fill",
                style: .gradient,
                colors: [Color.purple, Color.blue]
            ) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    currentStep = 1
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
    
    private var categorySelectionStep: some View {
        VStack(spacing: 0) {
            // Social app style header
            VStack(spacing: 24) {
                Text(quoteViewModel.selectedLanguage.localizedContentText("chooseInterests"))
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .padding(.top, 60)
                
                Text(quoteViewModel.selectedLanguage.localizedContentText("onboardingCategoriesDescription"))
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }
            
            // Instagram-style categories grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    ForEach(QuoteCategory.allCases, id: \.self) { category in
                        SocialCategoryCard(
                            category: category,
                            isSelected: selectedCategories.contains(category),
                            language: quoteViewModel.selectedLanguage
                        ) {
                            toggleCategory(category)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 32)
            }
            
            Spacer()
            
            // Modern action buttons
            VStack(spacing: 16) {
                // Continue button
                SocialButton(
                    title: quoteViewModel.selectedLanguage.localizedContentText("startReadingQuotes"),
                    icon: "checkmark.circle.fill",
                    style: selectedCategories.isEmpty ? .outline : .gradient,
                    colors: selectedCategories.isEmpty ? [.gray] : [Color.green, Color.teal]
                ) {
                    completeOnboarding()
                }
                .disabled(selectedCategories.isEmpty)
                .opacity(selectedCategories.isEmpty ? 0.6 : 1.0)
                
                // Skip button
                Button(action: {
                    selectedCategories = Set(QuoteCategory.allCases)
                    completeOnboarding()
                }) {
                    Text(quoteViewModel.selectedLanguage.localizedContentText("selectAllCategories"))
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.secondary)
                        .underline()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
    
    private func toggleCategory(_ category: QuoteCategory) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            if selectedCategories.contains(category) {
                selectedCategories.remove(category)
            } else {
                selectedCategories.insert(category)
            }
        }
    }
    
    private func completeOnboarding() {
        quoteViewModel.setSelectedCategories(selectedCategories)
        quoteViewModel.completeOnboarding()
    }
}

// Instagram-style feature card
struct SocialFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let accentColor: Color
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 20) {
            // Modern icon design
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.1))
                    .frame(width: 52, height: 52)
                    .overlay(
                        Circle()
                            .strokeBorder(accentColor.opacity(0.2), lineWidth: 1)
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(accentColor)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    colorScheme == .dark ? 
                    Color(UIColor.secondarySystemBackground).opacity(0.7) : 
                    Color.white.opacity(0.8)
                )
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }
}

// Social media style category card
struct SocialCategoryCard: View {
    let category: QuoteCategory
    let isSelected: Bool
    let language: QuoteLanguage
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                // Modern icon with selection state
                ZStack {
                    Circle()
                        .fill(
                            isSelected ? 
                            LinearGradient(
                                colors: [categoryColor, categoryColor.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [categoryColor.opacity(0.1), categoryColor.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    isSelected ? categoryColor : categoryColor.opacity(0.3),
                                    lineWidth: isSelected ? 2 : 1
                                )
                        )
                        .shadow(
                            color: isSelected ? categoryColor.opacity(0.3) : Color.black.opacity(0.1),
                            radius: isSelected ? 10 : 4,
                            x: 0,
                            y: isSelected ? 4 : 2
                        )
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(isSelected ? .white : categoryColor)
                    
                    // Instagram-style selection indicator
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .fill(categoryColor)
                                    .frame(width: 20, height: 20)
                            )
                            .offset(x: 22, y: -22)
                    }
                }
                
                Text(category.localizedDisplayName(for: language))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 130)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        isSelected ? 
                        categoryColor.opacity(0.08) : 
                        (colorScheme == .dark ? 
                         Color(UIColor.secondarySystemBackground).opacity(0.7) : 
                         Color.white.opacity(0.8))
                    )
                    .shadow(
                        color: isSelected ? categoryColor.opacity(0.15) : Color.black.opacity(0.05),
                        radius: isSelected ? 12 : 6,
                        x: 0,
                        y: isSelected ? 6 : 3
                    )
            )
            .scaleEffect(isSelected ? 1.03 : (isPressed ? 0.97 : 1.0))
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private var categoryColor: Color {
        switch category.color {
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
}

#Preview {
    OnboardingView()
        .environmentObject(QuoteViewModel())
} 