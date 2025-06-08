import SwiftUI

struct LanguageSettingsView: View {
    @EnvironmentObject private var quoteViewModel: QuoteViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(QuoteLanguage.allCases, id: \.self) { language in
                    Button(action: {
                        quoteViewModel.selectedLanguage = language
                    }) {
                        HStack {
                            Text(language.flag)
                                .font(.title2)
                            Text(language.displayName)
                                .foregroundColor(.primary)
                            Spacer()
                            if language == quoteViewModel.selectedLanguage {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Language")
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