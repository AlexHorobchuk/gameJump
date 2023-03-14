//
//  Level.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import UIKit
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
        //level.run(.repeatForever(.rotate(byAngle: .pi, duration: 3)))
        level.createEnemys(for: levelModel)
        return level
    }
    
    func createEnemys(for model: LevelModel) {
        let enemys = model.enemys.map { _ in EnemyFactory.createEnemy() }
        var count = enemys.count
        guard let enemyModel = model.enemys.first else { return }
        guard let enemyUI = enemys.first else { return }
        var lap = 1
        while count > 0 {
            let maxAmount = foundMaxAmountOfEnemys(enemySize: enemyUI.size.width, lap: lap)
            let random = Int.random(in: 2...maxAmount)
            let timeForOneCirlce = (self.size.width + enemyUI.size.width * CGFloat(lap)) * .pi / CGFloat(enemyModel.speed)
            for i in 1...random {
                if count > 0 {
                    let node = enemys[count - 1]
                    let offset = CGFloat(i) / CGFloat(maxAmount) * 2.2
                    let nodePath = createPath(lap: lap, enemySize: enemyUI.size.width, startAngle: offset)
                    let followPath = SKAction.follow(nodePath.cgPath, asOffset: false, orientToPath: true, duration: timeForOneCirlce)
                    node.run(.repeatForever(followPath))
                    self.addChild(node)
                }
                count -= 1
            }
            lap += 1
        }
    }
    
    func foundMaxAmountOfEnemys(enemySize: Double, lap: Int) -> Int {
        return Int((self.size.width + enemySize * CGFloat(lap)) / enemySize) * 2
    }
    
    func createPath(lap: Int, enemySize: CGFloat, startAngle: CGFloat) -> UIBezierPath {
        let direction = Bool.random()
        let endAngle = direction ? startAngle + .pi * 2 : startAngle - .pi * 2
        return UIBezierPath(arcCenter: self.position, radius: (self.size.width / 2 + (enemySize * CGFloat(lap)))  , startAngle: startAngle, endAngle: endAngle, clockwise: direction)
    }
    
    func checkIfwasVisited( level: LevelModel) {
        self.texture = level.bonus == nil ? .init(image: UIImage(systemName: "circle.dotted")!) : .init(image: UIImage(systemName: "questionmark.circle")!)
    }
}
