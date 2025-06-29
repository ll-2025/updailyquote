import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var quoteViewModel: QuoteViewModel
    @State private var selectedCategories: Set<QuoteCategory> = []
    @State private var currentStep = 0
    @Environment(\.colorScheme) private var colorScheme
    
    private let totalSteps = 2
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    colorScheme == .dark ? Color.black : Color.white,
                    colorScheme == .dark ? Color.indigo.opacity(0.3) : Color.blue.opacity(0.1)
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
    }
    
    private var welcomeStep: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // App icon and title
            VStack(spacing: 20) {
                Image(systemName: "quote.opening")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(.accentColor)
                
                Text("Daily Quote")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Get inspired every day with personalized quotes")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            // Features list
            VStack(alignment: .leading, spacing: 16) {
                FeatureRow(icon: "sparkles", title: "Daily Inspiration", description: "Fresh quotes every day")
                FeatureRow(icon: "heart.fill", title: "Save Favorites", description: "Keep your favorite quotes")
                FeatureRow(icon: "brain.filled.head.profile", title: "AI Chat", description: "Discuss quotes with AI")
                FeatureRow(icon: "globe", title: "Multiple Languages", description: "English, Spanish, Chinese")
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            // Continue button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentStep = 1
                }
            }) {
                HStack {
                    Text("Get Started")
                        .font(.system(size: 18, weight: .semibold))
                    Image(systemName: "arrow.right")
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
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
    
    private var categorySelectionStep: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 16) {
                Text(quoteViewModel.selectedLanguage.localizedContentText("chooseInterests"))
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .padding(.top, 60)
                
                Text(quoteViewModel.selectedLanguage.localizedContentText("onboardingCategoriesDescription"))
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            // Categories grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 16) {
                    ForEach(QuoteCategory.allCases, id: \.self) { category in
                        CategoryCard(
                            category: category,
                            isSelected: selectedCategories.contains(category),
                            language: quoteViewModel.selectedLanguage
                        ) {
                            toggleCategory(category)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            
            Spacer()
            
            // Action buttons
            VStack(spacing: 12) {
                // Continue button
                Button(action: completeOnboarding) {
                    HStack {
                        Text(quoteViewModel.selectedLanguage.localizedContentText("startReadingQuotes"))
                            .font(.system(size: 18, weight: .semibold))
                        Image(systemName: "checkmark")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: selectedCategories.isEmpty ? 
                                [Color.gray, Color.gray.opacity(0.8)] :
                                [Color.accentColor, Color.accentColor.opacity(0.8)]
                            ),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: selectedCategories.isEmpty ? 
                        Color.gray.opacity(0.3) : Color.accentColor.opacity(0.3), 
                        radius: 5, x: 0, y: 2)
                }
                .disabled(selectedCategories.isEmpty)
                
                // Skip button
                Button(action: {
                    selectedCategories = Set(QuoteCategory.allCases)
                    completeOnboarding()
                }) {
                    Text(quoteViewModel.selectedLanguage.localizedContentText("selectAllCategories"))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.accentColor)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
    
    private func toggleCategory(_ category: QuoteCategory) {
        withAnimation(.easeInOut(duration: 0.2)) {
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

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.accentColor)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct CategoryCard: View {
    let category: QuoteCategory
    let isSelected: Bool
    let language: QuoteLanguage
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(isSelected ? .white : categoryColor)
                
                Text(category.localizedDisplayName(for: language))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? categoryColor : Color(UIColor.secondarySystemGroupedBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(isSelected ? categoryColor : Color.clear, lineWidth: 2)
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(color: isSelected ? categoryColor.opacity(0.3) : Color.black.opacity(0.1), 
                   radius: isSelected ? 8 : 2, x: 0, y: isSelected ? 4 : 1)
        }
        .buttonStyle(PlainButtonStyle())
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