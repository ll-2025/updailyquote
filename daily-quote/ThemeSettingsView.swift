import SwiftUI

struct ThemeOptionRow: View {
    let theme: ThemeMode
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: theme.iconName)
                    .foregroundColor(.accentColor)
                    .frame(width: 30, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.accentColor.opacity(0.2))
                    )
                
                Text(theme.displayName)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct ThemeSettingsView: View {
    @EnvironmentObject private var quoteViewModel: QuoteViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                colorScheme == .dark ? Color(UIColor.systemGray6) : Color(UIColor.systemBackground),
                colorScheme == .dark ? Color(UIColor.systemGray5) : Color(UIColor.secondarySystemBackground)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var themeList: some View {
        List {
            Section(header: Text("Appearance")) {
                ForEach(ThemeMode.allCases, id: \.self) { theme in
                    ThemeOptionRow(
                        theme: theme,
                        isSelected: quoteViewModel.themeMode == theme,
                        action: { quoteViewModel.setTheme(theme) }
                    )
                }
            }
            
            Section(footer: Text("The app will match the system appearance setting if System is selected.")) {
                EmptyView()
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                themeList
            }
            .navigationTitle("Theme Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }
}

#Preview {
    ThemeSettingsView()
        .environmentObject(QuoteViewModel())
} 