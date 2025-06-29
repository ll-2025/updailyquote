import SwiftUI

struct CategorySettingsView: View {
    @EnvironmentObject private var quoteViewModel: QuoteViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var tempSelectedCategories: Set<QuoteCategory> = []
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header section
                        VStack(spacing: 12) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 40, weight: .medium))
                                .foregroundColor(.accentColor)
                            
                            Text(quoteViewModel.selectedLanguage.localizedContentText("quoteCategories"))
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text(quoteViewModel.selectedLanguage.localizedContentText("categoriesDescription"))
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        .padding(.top, 20)
                        
                        // Categories grid
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ], spacing: 16) {
                            ForEach(QuoteCategory.allCases, id: \.self) { category in
                                CategorySettingsCard(
                                    category: category,
                                    isSelected: tempSelectedCategories.contains(category),
                                    language: quoteViewModel.selectedLanguage
                                ) {
                                    toggleCategory(category)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Quick selection buttons
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                Button(action: selectAllCategories) {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                        Text(quoteViewModel.selectedLanguage.localizedContentText("selectAll"))
                                    }
                                    .font(.system(size: 14, weight: .medium))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.accentColor.opacity(0.1))
                                    .foregroundColor(.accentColor)
                                    .cornerRadius(20)
                                }
                                
                                Button(action: clearAllCategories) {
                                    HStack {
                                        Image(systemName: "xmark.circle.fill")
                                        Text(quoteViewModel.selectedLanguage.localizedContentText("clearAll"))
                                    }
                                    .font(.system(size: 14, weight: .medium))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.red.opacity(0.1))
                                    .foregroundColor(.red)
                                    .cornerRadius(20)
                                }
                            }
                            
                            Text("\(tempSelectedCategories.count) of \(QuoteCategory.allCases.count) \(quoteViewModel.selectedLanguage.localizedContentText("categoriesSelected"))")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 20)
                        
                        // Reset onboarding option
                        VStack(spacing: 16) {
                            Divider()
                                .padding(.horizontal, 20)
                            
                            Button(action: resetOnboarding) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                    Text(quoteViewModel.selectedLanguage.localizedContentText("resetOnboarding"))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .cornerRadius(12)
                            }
                            .foregroundColor(.primary)
                            .padding(.horizontal, 20)
                            
                            Text("This will show the welcome screen again and let you reconfigure your preferences.")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle(quoteViewModel.selectedLanguage.localizedContentText("categories"))
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(false)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(quoteViewModel.selectedLanguage.localizedContentText("cancel")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(quoteViewModel.selectedLanguage.localizedContentText("save")) {
                        saveChanges()
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .disabled(tempSelectedCategories.isEmpty)
                }
            }
        }
        .onAppear {
            tempSelectedCategories = quoteViewModel.selectedCategories
        }
    }
    
    private func toggleCategory(_ category: QuoteCategory) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if tempSelectedCategories.contains(category) {
                tempSelectedCategories.remove(category)
            } else {
                tempSelectedCategories.insert(category)
            }
        }
    }
    
    private func selectAllCategories() {
        withAnimation(.easeInOut(duration: 0.3)) {
            tempSelectedCategories = Set(QuoteCategory.allCases)
        }
    }
    
    private func clearAllCategories() {
        withAnimation(.easeInOut(duration: 0.3)) {
            tempSelectedCategories.removeAll()
        }
    }
    
    private func saveChanges() {
        let categoriesToSave = tempSelectedCategories.isEmpty ? Set(QuoteCategory.allCases) : tempSelectedCategories
        quoteViewModel.updateSelectedCategories(categoriesToSave)
        dismiss()
    }
    
    private func resetOnboarding() {
        quoteViewModel.resetOnboarding()
        dismiss()
    }
}

struct CategorySettingsCard: View {
    let category: QuoteCategory
    let isSelected: Bool
    let language: QuoteLanguage
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(isSelected ? .white : categoryColor)
                
                Text(category.localizedDisplayName(for: language))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? categoryColor : Color(UIColor.secondarySystemGroupedBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(isSelected ? categoryColor : Color.clear, lineWidth: 1.5)
                    )
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .shadow(color: isSelected ? categoryColor.opacity(0.2) : Color.black.opacity(0.05), 
                   radius: isSelected ? 6 : 2, x: 0, y: isSelected ? 3 : 1)
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
    CategorySettingsView()
        .environmentObject(QuoteViewModel())
} 