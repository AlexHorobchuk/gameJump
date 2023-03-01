//
//  Enemy.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode {
    static func createEnemy(at point: CGPoint) -> Enemy {
       let enemy = Enemy()
        return enemy
    }
}
