//
//  LevelModel.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import Foundation


class LevelModel {
    var primeLevel: Bool
    var identifier: Int {
        didSet {
            createEnemys(identifier: identifier)
        }
    }
    var wasChecked = false
    var bonus: Bonus?
    var bonusQouantity: Int
    var enemys = [EnemyModel]()
    
    
    static var identifierFactory = 0
    
    static func getUnicIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    
    func createEnemys(identifier: Int) {
        let qountity = Int.random(in: 1...16)
        if identifier != 1 {
            for _ in 0..<qountity {
                enemys.append(EnemyModel(speed: 400 + identifier * 2))
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
            bonus = Bonus.SpeedUP
            bonusQouantity = 3
            
        case 4...6:
            bonus = Bonus.Shield
            bonusQouantity = 5
        default:
            bonus = Bonus.Money
            bonusQouantity = 5
        }
    }
}
