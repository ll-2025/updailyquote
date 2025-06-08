import UIKit
import SwiftUI

class QuoteImageGenerator {
    
    enum BackgroundStyle: String, CaseIterable, Hashable {
        case gradient = "gradient"
        case minimal = "minimal"
        case nature = "nature"
        case abstract = "abstract"
        case sunset = "sunset"
        case ocean = "ocean"
        case galaxy = "galaxy"
        case geometric = "geometric"
        case rainyDay = "rainyDay"
        case studyAtHome = "studyAtHome"
        case coffee = "coffee"
        case mountains = "mountains"
        
        var displayName: String {
            switch self {
            case .gradient: return "Gradient"
            case .minimal: return "Minimal"
            case .nature: return "Nature"
            case .abstract: return "Abstract"
            case .sunset: return "Sunset"
            case .ocean: return "Ocean"
            case .galaxy: return "Galaxy"
            case .geometric: return "Geometric"
            case .rainyDay: return "Rainy Day"
            case .studyAtHome: return "Study Home"
            case .coffee: return "Coffee"
            case .mountains: return "Mountains"
            }
        }
    }
    
    static func generateImage(from quote: Quote, style: BackgroundStyle = .gradient) -> UIImage? {
        let size = CGSize(width: 1080, height: 1080) // Instagram square format
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            let cgContext = context.cgContext
            
            // Generate rich, detailed backgrounds
            switch style {
            case .gradient:
                drawVibrantGradient(in: rect, cgContext: cgContext)
            case .minimal:
                drawElegantMinimal(in: rect, cgContext: cgContext)
            case .nature:
                drawLushNature(in: rect, cgContext: cgContext)
            case .abstract:
                drawModernAbstract(in: rect, cgContext: cgContext)
            case .sunset:
                drawDramaticSunset(in: rect, cgContext: cgContext)
            case .ocean:
                drawTropicalOcean(in: rect, cgContext: cgContext)
            case .galaxy:
                drawCosmicGalaxy(in: rect, cgContext: cgContext)
            case .geometric:
                drawModernGeometric(in: rect, cgContext: cgContext)
            case .rainyDay:
                drawCozyRain(in: rect, cgContext: cgContext)
            case .studyAtHome:
                drawStudyScene(in: rect, cgContext: cgContext)
            case .coffee:
                drawCoffeeShop(in: rect, cgContext: cgContext)
            case .mountains:
                drawMajesticMountains(in: rect, cgContext: cgContext)
            }
            
            // Add subtle overlay for text readability
            cgContext.setFillColor(UIColor.black.withAlphaComponent(0.15).cgColor)
            cgContext.fill(rect)
            
            // Draw quote content
            drawQuoteContent(quote: quote, in: rect, context: context)
        }
    }
    
    // MARK: - Rich Background Scenes
    
    private static func drawVibrantGradient(in rect: CGRect, cgContext: CGContext) {
        // Rich purple to blue to teal gradient
        let colors = [
            UIColor(red: 0.5, green: 0.0, blue: 1.0, alpha: 1.0),  // Purple
            UIColor(red: 0.0, green: 0.3, blue: 1.0, alpha: 1.0),  // Blue
            UIColor(red: 0.0, green: 0.8, blue: 0.6, alpha: 1.0),  // Teal
        ]
        
        drawRadialGradient(colors: colors, in: rect, cgContext: cgContext)
        addSparkleEffect(in: rect, cgContext: cgContext)
    }
    
    private static func drawElegantMinimal(in rect: CGRect, cgContext: CGContext) {
        // Soft cream background
        cgContext.setFillColor(UIColor(red: 0.98, green: 0.97, blue: 0.95, alpha: 1.0).cgColor)
        cgContext.fill(rect)
        
        // Elegant geometric patterns
        drawMinimalGeometry(in: rect, cgContext: cgContext)
        addSoftTexture(in: rect, cgContext: cgContext)
    }
    
    private static func drawLushNature(in rect: CGRect, cgContext: CGContext) {
        // Forest background with depth
        let colors = [
            UIColor(red: 0.1, green: 0.3, blue: 0.1, alpha: 1.0),  // Dark forest
            UIColor(red: 0.2, green: 0.5, blue: 0.2, alpha: 1.0),  // Forest green
            UIColor(red: 0.4, green: 0.7, blue: 0.3, alpha: 1.0),  // Light green
        ]
        
        drawVerticalGradient(colors: colors, in: rect, cgContext: cgContext)
        drawForestSilhouettes(in: rect, cgContext: cgContext)
        drawFloatingLeaves(in: rect, cgContext: cgContext)
        addDappleSunlight(in: rect, cgContext: cgContext)
    }
    
    private static func drawModernAbstract(in rect: CGRect, cgContext: CGContext) {
        // Dark background
        cgContext.setFillColor(UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1.0).cgColor)
        cgContext.fill(rect)
        
        drawFluidShapes(in: rect, cgContext: cgContext)
        addNeonGlow(in: rect, cgContext: cgContext)
        drawParticles(in: rect, cgContext: cgContext)
    }
    
    private static func drawDramaticSunset(in rect: CGRect, cgContext: CGContext) {
        // Multi-layer sunset
        let colors = [
            UIColor(red: 1.0, green: 0.3, blue: 0.1, alpha: 1.0),  // Deep orange
            UIColor(red: 1.0, green: 0.5, blue: 0.2, alpha: 1.0),  // Orange
            UIColor(red: 1.0, green: 0.7, blue: 0.3, alpha: 1.0),  // Yellow
            UIColor(red: 0.9, green: 0.4, blue: 0.7, alpha: 1.0),  // Pink
            UIColor(red: 0.3, green: 0.1, blue: 0.5, alpha: 1.0),  // Purple
        ]
        
        drawVerticalGradient(colors: colors, in: rect, cgContext: cgContext)
        drawSunOrb(in: rect, cgContext: cgContext)
        drawCloudSilhouettes(in: rect, cgContext: cgContext)
        addAtmosphericHaze(in: rect, cgContext: cgContext)
    }
    
    private static func drawTropicalOcean(in rect: CGRect, cgContext: CGContext) {
        // Ocean depth gradient
        let colors = [
            UIColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1.0),  // Sky blue
            UIColor(red: 0.0, green: 0.6, blue: 0.9, alpha: 1.0),  // Ocean blue
            UIColor(red: 0.0, green: 0.4, blue: 0.7, alpha: 1.0),  // Deep blue
            UIColor(red: 0.0, green: 0.2, blue: 0.5, alpha: 1.0),  // Deep ocean
        ]
        
        drawVerticalGradient(colors: colors, in: rect, cgContext: cgContext)
        drawOceanWaves(in: rect, cgContext: cgContext)
        drawBubbleTrails(in: rect, cgContext: cgContext)
        addOceanReflections(in: rect, cgContext: cgContext)
    }
    
    private static func drawCosmicGalaxy(in rect: CGRect, cgContext: CGContext) {
        // Deep space
        cgContext.setFillColor(UIColor(red: 0.01, green: 0.01, blue: 0.05, alpha: 1.0).cgColor)
        cgContext.fill(rect)
        
        drawNebulaField(in: rect, cgContext: cgContext)
        drawStarField(in: rect, cgContext: cgContext)
        drawGalaxySpiral(in: rect, cgContext: cgContext)
        addCosmicDust(in: rect, cgContext: cgContext)
    }
    
    private static func drawModernGeometric(in rect: CGRect, cgContext: CGContext) {
        // Clean background
        cgContext.setFillColor(UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0).cgColor)
        cgContext.fill(rect)
        
        drawIsometricShapes(in: rect, cgContext: cgContext)
        addGeometricPattern(in: rect, cgContext: cgContext)
        applyShadowEffects(in: rect, cgContext: cgContext)
    }
    
    private static func drawCozyRain(in rect: CGRect, cgContext: CGContext) {
        // Stormy sky
        let colors = [
            UIColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 1.0),
            UIColor(red: 0.4, green: 0.4, blue: 0.5, alpha: 1.0),
            UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0),
        ]
        
        drawVerticalGradient(colors: colors, in: rect, cgContext: cgContext)
        drawStormClouds(in: rect, cgContext: cgContext)
        drawRainDrops(in: rect, cgContext: cgContext)
        drawWindowDroplets(in: rect, cgContext: cgContext)
        addLightningFlash(in: rect, cgContext: cgContext)
    }
    
    private static func drawStudyScene(in rect: CGRect, cgContext: CGContext) {
        // Warm indoor lighting
        let colors = [
            UIColor(red: 0.9, green: 0.85, blue: 0.75, alpha: 1.0),  // Warm cream
            UIColor(red: 0.8, green: 0.7, blue: 0.6, alpha: 1.0),   // Warm beige
            UIColor(red: 0.7, green: 0.6, blue: 0.5, alpha: 1.0),   // Darker beige
        ]
        
        drawRadialGradient(colors: colors, in: rect, cgContext: cgContext)
        
        // Draw study desk scene
        drawDesk(in: rect, cgContext: cgContext)
        drawBooks(in: rect, cgContext: cgContext)
        drawCoffeeCup(in: rect, cgContext: cgContext)
        drawLaptop(in: rect, cgContext: cgContext)
        drawPlant(in: rect, cgContext: cgContext)
        drawWindowLight(in: rect, cgContext: cgContext)
        addWarmLighting(in: rect, cgContext: cgContext)
    }
    
    private static func drawCoffeeShop(in rect: CGRect, cgContext: CGContext) {
        // Rich coffee browns
        let colors = [
            UIColor(red: 0.4, green: 0.25, blue: 0.15, alpha: 1.0), // Dark coffee
            UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0),  // Coffee brown
            UIColor(red: 0.8, green: 0.6, blue: 0.4, alpha: 1.0),  // Light brown
        ]
        
        drawRadialGradient(colors: colors, in: rect, cgContext: cgContext)
        
        // Draw coffee shop elements
        drawCoffeeBar(in: rect, cgContext: cgContext)
        drawCoffeeMachine(in: rect, cgContext: cgContext)
        drawSteam(in: rect, cgContext: cgContext)
        drawCoffeeBeans(in: rect, cgContext: cgContext)
        drawBarStools(in: rect, cgContext: cgContext)
        addAmbientLighting(in: rect, cgContext: cgContext)
    }
    
    private static func drawMajesticMountains(in rect: CGRect, cgContext: CGContext) {
        // Sky gradient
        let skyColors = [
            UIColor(red: 0.4, green: 0.7, blue: 1.0, alpha: 1.0),  // Sky blue
            UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1.0),  // Light blue
            UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0),  // Very light blue
        ]
        
        drawVerticalGradient(colors: skyColors, in: rect, cgContext: cgContext)
        
        // Draw mountain ranges with depth
        drawMountainRange(layer: 3, in: rect, cgContext: cgContext) // Distant
        drawMountainRange(layer: 2, in: rect, cgContext: cgContext) // Middle
        drawMountainRange(layer: 1, in: rect, cgContext: cgContext) // Foreground
        
        drawClouds(in: rect, cgContext: cgContext)
        drawSnowCaps(in: rect, cgContext: cgContext)
        addMountainMist(in: rect, cgContext: cgContext)
        drawPineForest(in: rect, cgContext: cgContext)
    }
    
    // MARK: - Drawing Helper Methods
    
    private static func drawRadialGradient(colors: [UIColor], in rect: CGRect, cgContext: CGContext) {
        guard let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors.map { $0.cgColor } as CFArray,
            locations: nil
        ) else { return }
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        cgContext.drawRadialGradient(
            gradient,
            startCenter: center,
            startRadius: 0,
            endCenter: center,
            endRadius: max(rect.width, rect.height) * 0.8,
            options: []
        )
    }
    
    private static func drawVerticalGradient(colors: [UIColor], in rect: CGRect, cgContext: CGContext) {
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
    
    // Study scene elements
    private static func drawDesk(in rect: CGRect, cgContext: CGContext) {
        // Wooden desk surface
        cgContext.setFillColor(UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 0.8).cgColor)
        let deskRect = CGRect(x: 0, y: rect.height * 0.7, width: rect.width, height: rect.height * 0.3)
        cgContext.fill(deskRect)
    }
    
    private static func drawBooks(in rect: CGRect, cgContext: CGContext) {
        let bookColors = [
            UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 0.9),
            UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 0.9),
            UIColor(red: 0.2, green: 0.7, blue: 0.3, alpha: 0.9),
            UIColor(red: 0.7, green: 0.5, blue: 0.2, alpha: 0.9)
        ]
        
        for (i, color) in bookColors.enumerated() {
            cgContext.setFillColor(color.cgColor)
            let x = rect.width * 0.1 + CGFloat(i) * 45
            let y = rect.height * 0.6
            let bookRect = CGRect(x: x, y: y, width: 40, height: 160)
            cgContext.fill(bookRect)
            
            // Book spine details
            cgContext.setStrokeColor(UIColor.black.withAlphaComponent(0.3).cgColor)
            cgContext.setLineWidth(1)
            cgContext.stroke(bookRect)
        }
    }
    
    private static func drawCoffeeCup(in rect: CGRect, cgContext: CGContext) {
        let cupX = rect.width * 0.6
        let cupY = rect.height * 0.65
        
        // Cup body
        cgContext.setFillColor(UIColor.white.cgColor)
        let cupRect = CGRect(x: cupX, y: cupY, width: 80, height: 60)
        cgContext.fillEllipse(in: cupRect)
        
        // Coffee inside
        cgContext.setFillColor(UIColor(red: 0.3, green: 0.2, blue: 0.1, alpha: 1.0).cgColor)
        let coffeeRect = CGRect(x: cupX + 8, y: cupY + 8, width: 64, height: 44)
        cgContext.fillEllipse(in: coffeeRect)
        
        // Handle
        cgContext.setStrokeColor(UIColor.white.cgColor)
        cgContext.setLineWidth(8)
        let handleRect = CGRect(x: cupX + 75, y: cupY + 15, width: 25, height: 30)
        cgContext.strokeEllipse(in: handleRect)
        
        // Steam
        drawCoffeesteam(at: CGPoint(x: cupX + 40, y: cupY), cgContext: cgContext)
    }
    
    private static func drawCoffeesteam(at point: CGPoint, cgContext: CGContext) {
        cgContext.setStrokeColor(UIColor.white.withAlphaComponent(0.6).cgColor)
        cgContext.setLineWidth(3)
        
        for i in 0..<3 {
            let path = UIBezierPath()
            let startX = point.x + CGFloat(i - 1) * 15
            path.move(to: CGPoint(x: startX, y: point.y))
            
            for j in 0..<6 {
                let y = point.y - CGFloat(j * 15)
                let x = startX + sin(CGFloat(j) * 0.5) * 8
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            cgContext.addPath(path.cgPath)
            cgContext.strokePath()
        }
    }
    
    private static func drawLaptop(in rect: CGRect, cgContext: CGContext) {
        let laptopX = rect.width * 0.3
        let laptopY = rect.height * 0.5
        
        // Laptop screen
        cgContext.setFillColor(UIColor.black.cgColor)
        let screenRect = CGRect(x: laptopX, y: laptopY, width: 200, height: 140)
        cgContext.fill(screenRect)
        
        // Screen glow
        cgContext.setFillColor(UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 0.7).cgColor)
        let glowRect = screenRect.insetBy(dx: 10, dy: 10)
        cgContext.fill(glowRect)
        
        // Laptop base
        cgContext.setFillColor(UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0).cgColor)
        let baseRect = CGRect(x: laptopX - 10, y: laptopY + 130, width: 220, height: 15)
        cgContext.fill(baseRect)
    }
    
    private static func drawPlant(in rect: CGRect, cgContext: CGContext) {
        let plantX = rect.width * 0.8
        let plantY = rect.height * 0.4
        
        // Pot
        cgContext.setFillColor(UIColor(red: 0.8, green: 0.6, blue: 0.4, alpha: 1.0).cgColor)
        let potRect = CGRect(x: plantX, y: plantY + 80, width: 60, height: 40)
        cgContext.fill(potRect)
        
        // Plant leaves
        cgContext.setFillColor(UIColor(red: 0.2, green: 0.7, blue: 0.3, alpha: 0.8).cgColor)
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3
            let leafX = plantX + 30 + cos(angle) * 25
            let leafY = plantY + 40 + sin(angle) * 25
            let leafRect = CGRect(x: leafX - 8, y: leafY - 15, width: 16, height: 30)
            cgContext.fillEllipse(in: leafRect)
        }
    }
    
    private static func drawWindowLight(in rect: CGRect, cgContext: CGContext) {
        // Window frame
        cgContext.setStrokeColor(UIColor(red: 0.6, green: 0.5, blue: 0.4, alpha: 0.8).cgColor)
        cgContext.setLineWidth(8)
        let windowRect = CGRect(x: rect.width * 0.75, y: rect.height * 0.1, width: rect.width * 0.2, height: rect.height * 0.3)
        cgContext.stroke(windowRect)
        
        // Cross pattern
        cgContext.move(to: CGPoint(x: windowRect.midX, y: windowRect.minY))
        cgContext.addLine(to: CGPoint(x: windowRect.midX, y: windowRect.maxY))
        cgContext.move(to: CGPoint(x: windowRect.minX, y: windowRect.midY))
        cgContext.addLine(to: CGPoint(x: windowRect.maxX, y: windowRect.midY))
        cgContext.strokePath()
        
        // Sunlight beam
        cgContext.setFillColor(UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 0.3).cgColor)
        let lightPath = UIBezierPath()
        lightPath.move(to: CGPoint(x: windowRect.maxX, y: windowRect.minY))
        lightPath.addLine(to: CGPoint(x: rect.width * 0.4, y: rect.height * 0.8))
        lightPath.addLine(to: CGPoint(x: rect.width * 0.6, y: rect.height * 0.8))
        lightPath.addLine(to: CGPoint(x: windowRect.maxX, y: windowRect.maxY))
        lightPath.close()
        
        cgContext.addPath(lightPath.cgPath)
        cgContext.fillPath()
    }
    
    // Mountain scene elements
    private static func drawMountainRange(layer: Int, in rect: CGRect, cgContext: CGContext) {
        let baseY = rect.height * (0.6 + CGFloat(layer) * 0.1)
        let alpha = 1.0 - (CGFloat(layer - 1) * 0.3)
        let darkness = 0.3 - (CGFloat(layer - 1) * 0.1)
        
        cgContext.setFillColor(UIColor(red: darkness, green: darkness + 0.1, blue: darkness + 0.2, alpha: alpha).cgColor)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: baseY))
        
        // Create jagged mountain silhouette
        let peaks = [
            (x: 0.1, height: 200 - CGFloat(layer) * 30),
            (x: 0.25, height: 300 - CGFloat(layer) * 50),
            (x: 0.4, height: 150 - CGFloat(layer) * 20),
            (x: 0.6, height: 350 - CGFloat(layer) * 60),
            (x: 0.75, height: 180 - CGFloat(layer) * 25),
            (x: 0.9, height: 250 - CGFloat(layer) * 40),
            (x: 1.0, height: 120 - CGFloat(layer) * 15)
        ]
        
        for peak in peaks {
            let x = rect.width * peak.x
            let y = baseY - peak.height
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.close()
        
        cgContext.addPath(path.cgPath)
        cgContext.fillPath()
    }
    
    private static func drawClouds(in rect: CGRect, cgContext: CGContext) {
        cgContext.setFillColor(UIColor.white.withAlphaComponent(0.8).cgColor)
        
        let cloudPositions = [
            (x: 0.2, y: 0.3, scale: 1.0),
            (x: 0.6, y: 0.2, scale: 0.7),
            (x: 0.8, y: 0.35, scale: 0.9)
        ]
        
        for cloud in cloudPositions {
            let centerX = rect.width * cloud.x
            let centerY = rect.height * cloud.y
            let scale = cloud.scale
            
            // Multiple overlapping circles for cloud shape
            let circles = [
                CGRect(x: centerX - 40 * scale, y: centerY - 15 * scale, width: 80 * scale, height: 30 * scale),
                CGRect(x: centerX - 25 * scale, y: centerY - 25 * scale, width: 50 * scale, height: 35 * scale),
                CGRect(x: centerX + 5 * scale, y: centerY - 20 * scale, width: 60 * scale, height: 30 * scale),
                CGRect(x: centerX + 20 * scale, y: centerY - 10 * scale, width: 40 * scale, height: 25 * scale)
            ]
            
            for circle in circles {
                cgContext.fillEllipse(in: circle)
            }
        }
    }
    
    // Additional helper methods for other effects
    private static func addSparkleEffect(in rect: CGRect, cgContext: CGContext) {
        cgContext.setFillColor(UIColor.white.withAlphaComponent(0.8).cgColor)
        for _ in 0..<50 {
            let x = CGFloat.random(in: 0...rect.width)
            let y = CGFloat.random(in: 0...rect.height)
            let size = CGFloat.random(in: 2...6)
            cgContext.fillEllipse(in: CGRect(x: x, y: y, width: size, height: size))
        }
    }
    
    private static func addWarmLighting(in rect: CGRect, cgContext: CGContext) {
        cgContext.setFillColor(UIColor(red: 1.0, green: 0.9, blue: 0.7, alpha: 0.2).cgColor)
        cgContext.fill(rect)
    }
    
    private static func drawMinimalGeometry(in rect: CGRect, cgContext: CGContext) {
        cgContext.setStrokeColor(UIColor(red: 0.8, green: 0.8, blue: 0.85, alpha: 0.6).cgColor)
        cgContext.setLineWidth(2)
        
        // Concentric circles
        let center = CGPoint(x: rect.midX, y: rect.midY)
        for i in 1...4 {
            let radius = CGFloat(i * 100)
            let circleRect = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
            cgContext.strokeEllipse(in: circleRect)
        }
    }
    
    private static func addSoftTexture(in rect: CGRect, cgContext: CGContext) {
        cgContext.setFillColor(UIColor.black.withAlphaComponent(0.02).cgColor)
        for _ in 0..<200 {
            let x = CGFloat.random(in: 0...rect.width)
            let y = CGFloat.random(in: 0...rect.height)
            let size = CGFloat.random(in: 1...3)
            cgContext.fillEllipse(in: CGRect(x: x, y: y, width: size, height: size))
        }
    }
    
    // Placeholder implementations for other methods (implement as needed)
    private static func drawForestSilhouettes(in rect: CGRect, cgContext: CGContext) {}
    private static func drawFloatingLeaves(in rect: CGRect, cgContext: CGContext) {}
    private static func addDappleSunlight(in rect: CGRect, cgContext: CGContext) {}
    private static func drawFluidShapes(in rect: CGRect, cgContext: CGContext) {}
    private static func addNeonGlow(in rect: CGRect, cgContext: CGContext) {}
    private static func drawParticles(in rect: CGRect, cgContext: CGContext) {}
    private static func drawSunOrb(in rect: CGRect, cgContext: CGContext) {}
    private static func drawCloudSilhouettes(in rect: CGRect, cgContext: CGContext) {}
    private static func addAtmosphericHaze(in rect: CGRect, cgContext: CGContext) {}
    private static func drawOceanWaves(in rect: CGRect, cgContext: CGContext) {}
    private static func drawBubbleTrails(in rect: CGRect, cgContext: CGContext) {}
    private static func addOceanReflections(in rect: CGRect, cgContext: CGContext) {}
    private static func drawNebulaField(in rect: CGRect, cgContext: CGContext) {}
    private static func drawStarField(in rect: CGRect, cgContext: CGContext) {}
    private static func drawGalaxySpiral(in rect: CGRect, cgContext: CGContext) {}
    private static func addCosmicDust(in rect: CGRect, cgContext: CGContext) {}
    private static func drawIsometricShapes(in rect: CGRect, cgContext: CGContext) {}
    private static func addGeometricPattern(in rect: CGRect, cgContext: CGContext) {}
    private static func applyShadowEffects(in rect: CGRect, cgContext: CGContext) {}
    private static func drawStormClouds(in rect: CGRect, cgContext: CGContext) {}
    private static func drawRainDrops(in rect: CGRect, cgContext: CGContext) {}
    private static func drawWindowDroplets(in rect: CGRect, cgContext: CGContext) {}
    private static func addLightningFlash(in rect: CGRect, cgContext: CGContext) {}
    private static func drawCoffeeBar(in rect: CGRect, cgContext: CGContext) {}
    private static func drawCoffeeMachine(in rect: CGRect, cgContext: CGContext) {}
    private static func drawSteam(in rect: CGRect, cgContext: CGContext) {}
    private static func drawCoffeeBeans(in rect: CGRect, cgContext: CGContext) {}
    private static func drawBarStools(in rect: CGRect, cgContext: CGContext) {}
    private static func addAmbientLighting(in rect: CGRect, cgContext: CGContext) {}
    private static func drawSnowCaps(in rect: CGRect, cgContext: CGContext) {}
    private static func addMountainMist(in rect: CGRect, cgContext: CGContext) {}
    private static func drawPineForest(in rect: CGRect, cgContext: CGContext) {}
    
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