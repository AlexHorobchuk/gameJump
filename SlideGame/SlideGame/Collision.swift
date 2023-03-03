//
//  Collision.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import Foundation
import SpriteKit

struct PhysicCategory {
    static let all  : UInt32 = 0xFFFFFFFF
    static let player: UInt32 = 1
    static let level: UInt32 = 2
    static let enemy: UInt32 = 4
}

extension GameScene: SKPhysicsContactDelegate {
    func didEnd(_ contact: SKPhysicsContact) {
        guard let bodyA = contact.bodyA.node as? SKSpriteNode else { return print("nil") }
        guard let bodyB = contact.bodyB.node as? SKSpriteNode else { return print("nil") }
        let type = detectCollisionType(bodyA: bodyA, bodyB: bodyB)
        collisionEndActionSwitch(type: type, bodyA: bodyA, bodyB: bodyB)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let bodyA = contact.bodyA.node as? SKSpriteNode else { return print("nil") }
        guard let bodyB = contact.bodyB.node as? SKSpriteNode else { return print("nil") }
        let type = detectCollisionType(bodyA: bodyA, bodyB: bodyB)
        collisionActionSwitch(type: type, bodyA: bodyA, bodyB: bodyB)
    }
    
    func detectCollisionType(bodyA: SKSpriteNode, bodyB: SKSpriteNode ) -> PhysicCollisionType {
        switch (bodyA.physicsBody?.categoryBitMask, bodyB.physicsBody?.categoryBitMask) {
        case (PhysicCategory.player, PhysicCategory.level), (PhysicCategory.level, PhysicCategory.player):
            return .playerStation
        case (PhysicCategory.player, PhysicCategory.enemy), (PhysicCategory.enemy, PhysicCategory.player):
            return .playerEnemy
        case (_, _):
            return .unknown
        }
    }
    
    func collisionEndActionSwitch(type: PhysicCollisionType, bodyA: SKSpriteNode, bodyB: SKSpriteNode ) {
        switch type {
        case .playerStation:
            isColliding = true
            
        case .playerEnemy:
            isColliding = false
        case .unknown:
            print("unkown colliusion")
        }
    }
    
    func collisionActionSwitch(type: PhysicCollisionType, bodyA: SKSpriteNode, bodyB: SKSpriteNode ) {
        switch type {
        case .playerStation:
            if isColliding {
                game.cameToNextSpot(nextSpot: .Success)
                updateUI()
                isColliding = false
            }
        case .playerEnemy:
            isColliding = false
            game.cameToNextSpot(nextSpot: .Fail)
            updateUI()
        case .unknown:
            print("unkown colliusion")
        }
    }
    
    enum PhysicCollisionType {
        case playerStation
        case playerEnemy
        case unknown
    }
}
