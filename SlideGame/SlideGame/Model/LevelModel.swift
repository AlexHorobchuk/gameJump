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
    var wasChecked = false
    var bonus: Bonus?
    var bonusQouantity: Int
    var enemys = [Enemy]()
    var hardness = Hardness.Easy
    
    enum Hardness {
        case Easy, Medium, Hard
    }
    
    static var identifierFactory = 0
    
    static func getUnicIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    func createEnemys(qountity: Int, hardness: Hardness) {
        var speed = 0
        switch hardness {
        case .Easy:
            speed = 400
        case .Medium:
            speed = 600
        case .Hard:
            speed = 800
        }
        for _ in 1...qountity {
            var enemy = Enemy(speed: speed)
            self.enemys.append(enemy)
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
        switch identifier {
            case 1:
            enemys = []
        case 2..<50:
            createEnemys(qountity: Int.random(in: 3...8), hardness: .Easy)
        case 50..<100:
            createEnemys(qountity: Int.random(in: 6...12), hardness: .Medium)
        case 100..<150:
            createEnemys(qountity: Int.random(in: 10...15), hardness: .Medium)
            hardness = .Medium
        case 150..<200:
            createEnemys(qountity: Int.random(in: 10...12), hardness: .Medium)
        case 200..<250:
            createEnemys(qountity: Int.random(in: 12...18), hardness: .Medium)
        case 250..<300:
            hardness = .Medium
            createEnemys(qountity: Int.random(in: 10...20), hardness: .Hard)
        default:
            hardness = .Hard
            createEnemys(qountity: Int.random(in: 10...30), hardness: .Hard)
        }
        
        
        
    }
}
