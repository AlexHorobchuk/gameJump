//
//  Level.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import Foundation
import SpriteKit

class Level: SKSpriteNode {
    static func createLevel(_ levelModel: LevelModel) -> Level {
        let level = Level()
        level.name = "\(levelModel.identifier)"
        level.texture = levelModel.primeLevel ? .init(image: UIImage(systemName: "house.circle.fill")!) :
            .init(image: UIImage(systemName: "questionmark.circle")!)
        level.size = .init(width: 120, height: 120)
        level.zPosition = -1
        level.physicsBody = .init(circleOfRadius: level.size.width / 2)
        level.physicsBody?.categoryBitMask = PhysicCategory.level
        level.physicsBody?.contactTestBitMask = PhysicCategory.player
        level.physicsBody?.collisionBitMask = .zero
        level.physicsBody?.usesPreciseCollisionDetection = true
        level.run(.repeatForever(.rotate(byAngle: .pi, duration: 3)))
        return level
        
    }
}
