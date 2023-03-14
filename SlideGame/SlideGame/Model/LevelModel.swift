//
//  LevelModel.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import Foundation


class LevelModel {
    var primeLevel: Bool
    var identifier: Int
    var bonus: Bonus?
    var bonusQouantity: Int
    var enemys = [EnemyModel]()
    
    
    static var identifierFactory = 0
    
    static func getUnicIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    
    func createEnemys() {
        let qountity = Int.random(in: 1...10)
        if identifier != 1 {
            for _ in 0..<qountity {
                enemys.append(EnemyModel(speed: 250 + identifier * 2))
            }
        }
    }
    
    init() {
        self.identifier = LevelModel.getUnicIdentifier()
        self.primeLevel = false
        if identifier % 5 == 0 || identifier == 1 {
            self.primeLevel = true
        }
        switch Int.random(in: 1...30) {
        case 1...3:
            bonus = Bonus.speedUp
            bonusQouantity = 3
            
        case 4...6:
            bonus = Bonus.shield
            bonusQouantity = 3
        default:
            bonus = Bonus.money
            bonusQouantity = 5
        }
        createEnemys()
    }
}
