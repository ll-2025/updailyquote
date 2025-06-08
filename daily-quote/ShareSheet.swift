import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    // Convenience initializer for backward compatibility
    init(text: String) {
        self.activityItems = [text]
    }
    
    // New initializer for multiple items including images
    init(activityItems: [Any]) {
        self.activityItems = activityItems
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Nothing to update
    }
}