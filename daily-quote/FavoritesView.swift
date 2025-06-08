import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var quoteViewModel: QuoteViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        colorScheme == .dark ? Color(UIColor.systemGray6) : Color(UIColor.systemBackground),
                        colorScheme == .dark ? Color(UIColor.systemGray5) : Color(UIColor.secondarySystemBackground)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if quoteViewModel.favoriteQuotes.isEmpty {
                    VStack {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 70))
                            .foregroundColor(.secondary.opacity(0.5))
                            .padding(.bottom, 12)
                        Text("No Favorite Quotes")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        Text("Your favorite quotes will appear here")
                            .font(.subheadline)
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                } else {
                    List {
                        ForEach(quoteViewModel.favoriteQuotes, id: \.text) { quote in
                            QuoteRow(quote: quote)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(UIColor.secondarySystemGroupedBackground))
                                        .padding(
                                            EdgeInsets(
                                                top: 8,
                                                leading: 0,
                                                bottom: 8,
                                                trailing: 0
                                            )
                                        )
                                )
                                .swipeActions {
                                    Button(role: .destructive) {
                                        quoteViewModel.toggleFavorite(for: quote)
                                    } label: {
                                        Label("Remove", systemImage: "heart.slash")
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favorites")
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

struct QuoteRow: View {
    @EnvironmentObject private var quoteViewModel: QuoteViewModel
    let quote: Quote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\"\(quote.text)\"")
                .font(.system(size: 17, weight: .regular, design: .serif))
                .lineSpacing(4)
                .padding(.top, 8)
                .multilineTextAlignment(.leading)
            
            Text("— \(quote.author)")
                .font(.system(size: 15, weight: .regular, design: .serif))
                .foregroundColor(.secondary)
                .italic()
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    FavoritesView()
        .environmentObject(QuoteViewModel())
} 