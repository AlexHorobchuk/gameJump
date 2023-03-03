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
        level.run(.repeatForever(.rotate(byAngle: .pi, duration: 3)))
        level.createEnemys(for: levelModel)
        return level
    }
    
    func createEnemys(for model: LevelModel) {
        let enemys = model.enemys.map { _ in Enemy.createEnemy() }
        var count = enemys.count
        var lap = 1
        while count > 0 {
            let maxAmount = foundMaxAmountOfEnemys(enemySize: enemys.first!.size.width, lap: lap)
            let random = Int.random(in: 2...maxAmount)
            let pathCoeficient = CGFloat(1 / maxAmount)
            let timeForOneCirlce = self.size.width * .pi * CGFloat(lap)  / CGFloat(model.enemys.first!.speed)
            for i in 1...random {
                if count > 0 {
                    let node = enemys[count - 1]
                    let offset = CGFloat(i) * pathCoeficient
                    let nodePath = createPath(lap: lap, enemySize: (enemys.first?.size.width)!, startAngle: offset)
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
        return Int(self.size.width * .pi * CGFloat(lap) / enemySize) / 2
    }
    
    func createPath(lap: Int, enemySize: CGFloat, startAngle: CGFloat) -> UIBezierPath {
        return UIBezierPath(arcCenter: self.position, radius: self.size.width + (enemySize / 2 * CGFloat(lap)) , startAngle: startAngle, endAngle: startAngle + .pi * 2, clockwise: true)
    }
}
