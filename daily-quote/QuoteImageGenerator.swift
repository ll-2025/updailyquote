import UIKit
import SwiftUI

class QuoteImageGenerator {
    
    enum BackgroundStyle: String, CaseIterable, Hashable {
        case coffee = "coffee"
        case mountains = "mountains"
        case ocean = "ocean"
        case rainyDay = "rainyDay"
        case clouds = "clouds"
        case activity = "activity"
        case galaxy = "galaxy"
        case study = "study"
        case sunset = "sunset"
        
        var displayName: String {
            switch self {
            case .coffee: return "Coffee"
            case .mountains: return "Mountains"
            case .ocean: return "Ocean"
            case .rainyDay: return "Rainy Day"
            case .clouds: return "Clouds"
            case .activity: return "Activity"
            case .galaxy: return "Galaxy"
            case .study: return "Study"
            case .sunset: return "Sunset"
            }
        }
        
        var imageName: String {
            switch self {
            case .coffee: return "bg_coffee"
            case .mountains: return "bg_mountains"
            case .ocean: return "bg_ocean"
            case .rainyDay: return "bg_rain"
            case .clouds: return "bg_clouds"
            case .activity: return "bg_activity"
            case .galaxy: return "bg_night"
            case .study: return "bg_coding"
            case .sunset: return "bg_sunset"
            }
        }
    }
    
    static func generateImage(from quote: Quote, style: BackgroundStyle = .coffee) -> UIImage? {
        let size = CGSize(width: 1080, height: 1080) // Instagram square format
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            let cgContext = context.cgContext
            
            // Load and draw background image
            if let backgroundImage = UIImage(named: style.imageName) {
                backgroundImage.draw(in: rect)
            } else {
                // Fallback to gradient if image not found
                drawFallbackGradient(in: rect, cgContext: cgContext, style: style)
            }
            
            // Add subtle overlay for text readability
            cgContext.setFillColor(UIColor.black.withAlphaComponent(0.3).cgColor)
            cgContext.fill(rect)
            
            // Draw quote content
            drawQuoteContent(quote: quote, in: rect, context: context)
        }
    }
    
    // MARK: - Fallback gradient for when images are not available
    private static func drawFallbackGradient(in rect: CGRect, cgContext: CGContext, style: BackgroundStyle) {
        let colors: [UIColor]
        
        switch style {
        case .coffee:
            colors = [
                UIColor(red: 0.4, green: 0.25, blue: 0.15, alpha: 1.0),
                UIColor(red: 0.8, green: 0.6, blue: 0.4, alpha: 1.0)
            ]
        case .mountains:
            colors = [
                UIColor(red: 0.4, green: 0.7, blue: 1.0, alpha: 1.0),
                UIColor(red: 0.2, green: 0.4, blue: 0.3, alpha: 1.0)
            ]
        case .ocean:
            colors = [
                UIColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1.0),
                UIColor(red: 0.0, green: 0.2, blue: 0.5, alpha: 1.0)
            ]
        case .rainyDay:
            colors = [
                UIColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 1.0),
                UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0)
            ]
        case .clouds:
            colors = [
                UIColor(red: 0.4, green: 0.7, blue: 1.0, alpha: 1.0),
                UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0)
            ]
        case .activity:
            colors = [
                UIColor(red: 0.8, green: 0.6, blue: 0.4, alpha: 1.0),
                UIColor(red: 0.5, green: 0.7, blue: 0.3, alpha: 1.0)
            ]
        case .galaxy:
            colors = [
                UIColor(red: 0.01, green: 0.01, blue: 0.05, alpha: 1.0),
                UIColor(red: 0.1, green: 0.0, blue: 0.2, alpha: 1.0)
            ]
        case .study:
            colors = [
                UIColor(red: 0.4, green: 0.25, blue: 0.15, alpha: 1.0),
                UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
            ]
        case .sunset:
            colors = [
                UIColor(red: 1.0, green: 0.3, blue: 0.1, alpha: 1.0),
                UIColor(red: 0.9, green: 0.4, blue: 0.7, alpha: 1.0),
                UIColor(red: 0.3, green: 0.1, blue: 0.5, alpha: 1.0)
            ]
        }
        
        guard let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors.map { $0.cgColor } as CFArray,
            locations: nil
        ) else { return }
        
        cgContext.drawLinearGradient(
            gradient,
            start: CGPoint(x: rect.midX, y: 0),
            end: CGPoint(x: rect.midX, y: rect.height),
            options: []
        )
    }
    // MARK: - Quote Content Drawing
    
    private static func drawQuoteContent(quote: Quote, in rect: CGRect, context: UIGraphicsImageRendererContext) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 8
        
        // Strong text shadow for readability
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.9)
        shadow.shadowOffset = CGSize(width: 3, height: 3)
        shadow.shadowBlurRadius = 6
        
        let quoteAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 48, weight: .medium),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle,
            .shadow: shadow
        ]
        
        let authorAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.italicSystemFont(ofSize: 32),
            .foregroundColor: UIColor.white.withAlphaComponent(0.95),
            .paragraphStyle: paragraphStyle,
            .shadow: shadow
        ]
        
        // Calculate text layout
        let margin: CGFloat = 120
        let textRect = CGRect(
            x: margin,
            y: margin,
            width: rect.width - (margin * 2),
            height: rect.height - (margin * 2)
        )
        
        // Draw opening quote mark
        let openingQuote = "\"" as NSString
        let quoteMarkAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 120, weight: .bold),
            .foregroundColor: UIColor.white.withAlphaComponent(0.3)
        ]
        
        openingQuote.draw(
            at: CGPoint(x: margin, y: margin + 40),
            withAttributes: quoteMarkAttributes
        )
        
        // Draw quote text
        let quoteText = quote.text as NSString
        let quoteSize = quoteText.boundingRect(
            with: CGSize(width: textRect.width, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: quoteAttributes,
            context: nil
        )
        
        let quoteY = rect.height / 2 - quoteSize.height / 2 - 40
        quoteText.draw(
            in: CGRect(x: textRect.minX, y: quoteY, width: textRect.width, height: quoteSize.height),
            withAttributes: quoteAttributes
        )
        
        // Draw author
        let authorText = "— \(quote.author)" as NSString
        let authorSize = authorText.boundingRect(
            with: CGSize(width: textRect.width, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: authorAttributes,
            context: nil
        )
        
        let authorY = quoteY + quoteSize.height + 60
        authorText.draw(
            in: CGRect(x: textRect.minX, y: authorY, width: textRect.width, height: authorSize.height),
            withAttributes: authorAttributes
        )
        
        // Draw app watermark
        let watermarkText = "Daily Quote" as NSString
        let watermarkAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .light),
            .foregroundColor: UIColor.white.withAlphaComponent(0.6)
        ]
        
        let watermarkSize = watermarkText.size(withAttributes: watermarkAttributes)
        let watermarkRect = CGRect(
            x: rect.width - watermarkSize.width - 40,
            y: rect.height - watermarkSize.height - 40,
            width: watermarkSize.width,
            height: watermarkSize.height
        )
        
        watermarkText.draw(in: watermarkRect, withAttributes: watermarkAttributes)
    }
} 