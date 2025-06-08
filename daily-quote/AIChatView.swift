import SwiftUI

struct AIChatView: View {
    @StateObject private var aiViewModel = AIConversationViewModel()
    @State private var messageText = ""
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    let currentQuote: Quote
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Connection status
                if !aiViewModel.isConnected {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                        Text("AI Ready (Text Mode)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Mock Mode")
                            .font(.caption2)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                } else {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("AI Ready (Voice & Text)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                }
                
                // Chat messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(aiViewModel.messages) { message in
                                MessageBubbleView(message: message)
                                    .id(message.id)
                            }
                            
                            if aiViewModel.isLoading {
                                TypingIndicatorView()
                            }
                        }
                        .padding()
                    }
                    .onChange(of: aiViewModel.messages.count) { _ in
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo(aiViewModel.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
                
                // Error message
                if let errorMessage = aiViewModel.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                        Spacer()
                        Button("Dismiss") {
                            aiViewModel.errorMessage = nil
                        }
                        .font(.caption)
                        .foregroundColor(.red)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.1))
                }
                
                // Input area
                VStack(spacing: 12) {
                    Divider()
                    
                    HStack(spacing: 12) {
                        // Voice recording button
                        Button(action: {
                            if aiViewModel.isRecording {
                                aiViewModel.stopRecording()
                            } else {
                                aiViewModel.startRecording()
                            }
                        }) {
                            Image(systemName: aiViewModel.isRecording ? "mic.fill" : "mic")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(
                                    aiViewModel.isRecording ? .red : 
                                    (aiViewModel.isConnected ? .accentColor : .gray)
                                )
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(Color.accentColor.opacity(0.1))
                                )
                                .scaleEffect(aiViewModel.isRecording ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 0.1), value: aiViewModel.isRecording)
                        }
                        .disabled(!aiViewModel.isConnected)
                        
                        // Text input
                        HStack {
                            TextField(
                                aiViewModel.isConnected ? "Ask about this quote..." : "Waiting for connection...", 
                                text: $messageText
                            )
                            .textFieldStyle(PlainTextFieldStyle())
                            .lineLimit(4)
                            .onSubmit {
                                sendMessage()
                            }
                            .disabled(!aiViewModel.isConnected)
                            
                            if !messageText.isEmpty && aiViewModel.isConnected {
                                Button(action: sendMessage) {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color(UIColor.secondarySystemGroupedBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(
                                            aiViewModel.isConnected ? Color.accentColor.opacity(0.3) : Color.gray.opacity(0.3), 
                                            lineWidth: 1
                                        )
                                )
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .background(
                    Color(UIColor.systemGroupedBackground)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                )
            }
            .navigationTitle("AI Chat")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button("Done") {
                    aiViewModel.stopVoiceHandling()
                    dismiss()
                },
                trailing: Menu {
                    Button(action: {
                        aiViewModel.clearConversation()
                    }) {
                        Label("Clear Chat", systemImage: "trash")
                    }
                    
                    if aiViewModel.isConnected {
                        Button(action: {
                            aiViewModel.startVoiceHandling()
                        }) {
                            Label("Start Voice Mode", systemImage: "speaker.wave.2")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            )
        }
        .onAppear {
            aiViewModel.setCurrentQuote(currentQuote)
        }
        .onDisappear {
            aiViewModel.stopVoiceHandling()
        }
    }
    
    private func sendMessage() {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        aiViewModel.sendMessage(text)
        messageText = ""
    }
}

struct MessageBubbleView: View {
    let message: ChatMessage
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer(minLength: 60)
            }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.body)
                    .foregroundColor(message.isFromUser ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(message.isFromUser ? Color.accentColor : Color(UIColor.secondarySystemGroupedBackground))
                    )
                
                Text(formatTime(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
            
            if !message.isFromUser {
                Spacer(minLength: 60)
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct TypingIndicatorView: View {
    @State private var animationPhase = 0
    
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 8, height: 8)
                        .scaleEffect(animationPhase == index ? 1.2 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: 0.6)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                            value: animationPhase
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
            )
            
            Spacer(minLength: 60)
        }
        .onAppear {
            animationPhase = 0
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { _ in
                animationPhase = (animationPhase + 1) % 3
            }
        }
    }
}

#Preview {
    AIChatView(currentQuote: Quote(text: "The only way to do great work is to love what you do.", author: "Steve Jobs"))
} 