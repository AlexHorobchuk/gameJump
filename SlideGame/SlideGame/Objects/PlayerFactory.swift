//
//  Player.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import SpriteKit

class PlayerFactory {
    static func createPlater() -> SKSpriteNode {
        let player = SKSpriteNode(texture: .init(image: UIImage(systemName: "face.smiling.inverse")!))
        let aimWidth: CGFloat = 70
        let ratio = aimWidth / player.size.width
        player.setScale(ratio)
        player.physicsBody = .init(circleOfRadius: player.size.width / 2)
        player.physicsBody?.categoryBitMask = PhysicCategory.player
        player.physicsBody?.contactTestBitMask = PhysicCategory.enemy | PhysicCategory.level
        player.physicsBody?.collisionBitMask = .zero
        player.physicsBody?.usesPreciseCollisionDetection = true
        return player
    }
}
