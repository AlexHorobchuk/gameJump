//
//  GameScene.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//
import UIKit
import SpriteKit

class GameScene: SKScene {
    var isColliding = false
    var player = Player.createPlater()
    var game = SlideGame()
    var cam = SKCameraNode()
    
    override func didMove(to view: SKView) {
        anchorPoint = .init(x: 0, y: 0)
        backgroundColor = .white
        game.logic = self
        updateUI()
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        self.addChild(player)
        player.position = self.childNode(withName: String(game.gameLevels.first!.identifier))!.position
        configureCam()
    }
    
    func configureCam() {
        self.addChild(cam)
        self.camera = cam
        cam.setScale(1.5)
        cam.run(.move(to: .init(x: player.position.x, y: player.position.y + frame.height * 0.3), duration: 1))
    }
    
    func updateCam() {
        let currentLevel = findLevelNode(identifier: game.currentLevel)
        let nextLevel = findLevelNode(identifier: game.currentLevel + 1)
        let distance = (currentLevel?.position.distance(point: nextLevel!.position))!
        let aimScale = distance / (frame.height * 0.4)
        let ratio = aimScale / cam.yScale
        cam.run(.sequence([.move(to: .init(x: (currentLevel?.position.x)!, y: (currentLevel?.position.y)! + frame.height * 0.3), duration: 0.3), .scale(by: ratio, duration: 0.7)]))
    }
    
    func updateUI() {
        updateSpritesForLevels(levels: game.gameLevels)
        updateCam()
        player.position = self.childNode(withName: String(game.currentLevel))!.position
    }
    
    func updateSpritesForLevels(levels: [LevelModel]) {
        for level in levels {
            if self.childNode(withName: String(level.identifier)) == nil {
                let spriteLevel = Level.createLevel(level)
                let priviusSpriteLevel = self.childNode(withName: String(level.identifier - 1))
                if level.identifier == 1 {
                    spriteLevel.position = .init(x: frame.midX, y: 100)
                } else {
                    spriteLevel.position = .init(x: CGFloat.random(in: frame.minX...frame.maxX), y: (priviusSpriteLevel?.position.y)! + CGFloat.random(in: 450...600))
                }
                self.addChild(spriteLevel)
            } else {
                if !level.primeLevel {
                    let existingSprite = self.childNode(withName: String(level.identifier)) as! Level
                    existingSprite.texture = level.wasChecked ? .init(image: UIImage(systemName: "circle.dotted")!) : .init(image: UIImage(systemName: "questionmark.circle")!)
                }
            }
        }
    }
    
    func deleteSpritesForLevels() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        game.findNextSpot()
        }
    
    func findLevelNode(identifier: Int) -> Level? {
        guard  let level = self.childNode(withName: String(identifier)) as? Level else {
           return nil }
        return level
    }
}

extension CGPoint {
    func distance(point: CGPoint) -> CGFloat {
        return abs(CGFloat(hypotf(Float(point.x - x), Float(point.y - y))))
    }
}

extension GameScene: GameLogic {
    func deleteLevels(levels: [LevelModel]) {
        for level in levels {
            let levelNode = findLevelNode(identifier: level.identifier)
            levelNode?.removeFromParent()
        }
    }
    
    func failedToMakeToANewSpot(identifier: Int) {
        player.removeAllActions()
        let goBackToSpot = findLevelNode(identifier: identifier)
        player.run(.move(to: goBackToSpot!.position, duration: 0.1))
    }
    
    func moveToNextSpot(identifier: Int) {
        let nextSpot = findLevelNode(identifier: identifier)
        let distance = nextSpot!.position.distance(point: player.position)
            let time = distance / CGFloat(game.player.speed)
        player.run(.move(to: nextSpot!.position, duration: time))
    }
    
    
}
