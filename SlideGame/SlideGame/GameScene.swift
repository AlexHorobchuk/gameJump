//
//  GameScene.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//
import UIKit
import SpriteKit

class GameScene: SKScene {
    
    var player = PlayerFactory.createPlater()
    var game : SlideGame
    var cam = SKCameraNode()
    
    init(game: SlideGame, size: CGSize) {
        self.game = game
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        updateCam()
    }
    
    func updateCam() {
        cam.removeAllActions()
        guard let currentLevel = findLevelNode(identifier: game.currentLevel) else {
            return print("current level wasn`t found") }
        guard let nextLevel = findLevelNode(identifier: game.currentLevel + 1) else {
            return print("next level wasn`t found") }
        let camPosition = currentLevel.position.middlePosition(between: nextLevel.position)
        let distance = (currentLevel.position.distance(point: nextLevel.position))
        let aimScale = distance / (frame.height * 0.4)
        let ratio = aimScale / cam.yScale
        cam.run(.sequence([.move(to: camPosition, duration: 0.3), .scale(by: ratio, duration: 0.7)]))
    }
    
    func updateUI() {
        updateSpritesForLevels(levels: game.gameLevels)
        updateCam()
        checkLevelEnemys()
        player.position = self.childNode(withName: String(game.currentLevel))!.position
    }
    
    func updateSpritesForLevels(levels: [LevelModel]) {
        for level in levels {
            if self.childNode(withName: String(level.identifier)) == nil {
                let spriteLevel = Level.createLevel(level)
                if level.identifier == 1 {
                    spriteLevel.position = .init(x: frame.midX, y: 100)
                } else {
                    guard let priviusSpriteLevel = self.childNode(withName: String(level.identifier - 1)) else {
                       return print("cannot update sprites")
                    }
                    spriteLevel.position = .init(x: CGFloat.random(in: frame.minX...frame.maxX), y: (priviusSpriteLevel.position.y) + CGFloat.random(in: 510...700))
                }
                self.addChild(spriteLevel)
            } else {
                if !level.primeLevel {
                    let existingSprite = self.childNode(withName: String(level.identifier)) as! Level
                    existingSprite.checkIfwasVisited(level: level)
                }
            }
        }
    }
    
    func checkLevelEnemys() {
        self.children.forEach { child in
            guard let level = child as? Level else { return }
            if Int(level.name!)! <= game.currentLevel {
                level.children.forEach { enemy in
                    enemy.isHidden = true
                    enemy.physicsBody?.categoryBitMask = PhysicCategory.notActiveEnemy
                }
            } else {
                level.children.forEach { enemy in
                    enemy.isHidden = false
                    enemy.physicsBody?.categoryBitMask = PhysicCategory.enemy

                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        game.moveToNextSpot()
        }
    
    func findLevelNode(identifier: Int) -> Level? {
        if let level = self.childNode(withName: String(identifier)) as? Level {
            return level
        }
        return nil
    }
}

extension GameScene: GameLogic {

    func goToNextSpot(identifier: Int, speed: Int) {
        if let nextSpot = findLevelNode(identifier: identifier) {
            let distance = nextSpot.position.distance(point: player.position)
            let time = distance / CGFloat(speed)
            player.run(.move(to: nextSpot.position, duration: time))
            SoundManager.shared.playSound(for: .jump)
        }
    }
    
    
    func deleteLevels(levels: [LevelModel]) {
        for level in levels {
            if let levelNode = findLevelNode(identifier: level.identifier) {
                levelNode.removeFromParent()
            }
        }
    }
    
    func failedToMakeToANewSpot(identifier: Int) {
        player.removeAllActions()
        if let goBackToSpot = findLevelNode(identifier: identifier) {
            player.run(.move(to: goBackToSpot.position, duration: 0))
        }
    }
}
