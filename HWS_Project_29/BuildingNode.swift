//
//  BuildingNode.swift
//  HWS_Project_29
//
//  Created by Cory Tepper on 2/9/21.
//

import SpriteKit
import UIKit

class BuildingNode: SKSpriteNode {
    // MARK: Properties
    var currentImage: UIImage!

    // MARK: Methods
    func setup() {
        name = "building"
        
        currentImage = drawBuidling(size: size)
        texture = SKTexture(image: currentImage)
        
        configurePhysics()
    }

    func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionTypes.building.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
    }
    
    func drawBuidling(size: CGSize) -> UIImage {
        // 1. Create a new Core Graphics context the size of our building
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let img = renderer.image { ctx in
            // 2. Fill it with a rectangle the same size and 1 of 3 colors
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            let color: UIColor
            
            switch Int.random(in: 0...2) {
            case 0:
                color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
            case 1:
                color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
            
            default:
                color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
            }
            
            color.setFill()
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
            
            // 3. Draw windows in a grid format on the buidlings - two colors ot represent lights on or lights off
            let lightOnColor = UIColor(hue: 0.19, saturation: 0.67, brightness: 0.99, alpha: 1)
            let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
            
            
            for row in stride(from: 10, to: Int(size.height - 10), by: 40) {
                for col in stride(from: 10, to: Int(size.width - 10), by: 40) {
                    if Bool.random() {
                        lightOnColor.setFill()
                    } else {
                        lightOffColor.setFill()
                    }
                    
                    ctx.cgContext.fill(CGRect(x: col, y: row, width: 15, height: 20))
                 
                }
            }
        }
        
        // 4. return the resulting render as a UIImage to use elsewhere
        return img
        
    }
    
    func hit(at point: CGPoint) {
        // 1. Determine where the building was hit. SpriteKit positions form the center - Core Graphics from the bottom left
        let convertedPoint = CGPoint(x: point.x + size.width / 2, y: abs(point.y - (size.height / 2)))
        
        // 2. Create a new Core Graphics context the size of our current sprite
        let renderer = UIGraphicsImageRenderer(size: size)
        
        // 3. Draw our current building image into the context. This will be the full size buidling but will degrade with each banana hit
        let img = renderer.image { ctx in
            currentImage.draw(at: .zero)
            
            // 4. Create an ellipse at the collision point. Posistion the 64px x 64px ellipse up and over 32px to center it at the collision point
            ctx.cgContext.addEllipse(in: CGRect(x: convertedPoint.x - 32, y: convertedPoint.y - 32, width: 64, height: 64))
            
            // 5. Set the blend mode to .clear and draw the ellipse to remove it form the building
            ctx.cgContext.setBlendMode(.clear)
            ctx.cgContext.drawPath(using: .fill)
        }
        // 6. Convert the contents of the Core Graphics context back to UIImage, save it to currentImage to update the texture for the building
        texture = SKTexture(image: img)
        currentImage = img
        
        // 7. Call configurePhysics() again so SpriteKit will recalculate the per-pixel physics for the damaged building
        configurePhysics()
    }
    
}
