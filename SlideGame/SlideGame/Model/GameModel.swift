//
//  GameModel.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import Foundation

protocol GameLogic: AnyObject {
    func moveToNextSpot(identifier: Int)
    
    func failedToMakeToANewSpot(identifier: Int)
    
    func deleteLevels(levels: [LevelModel])
}

class SlideGame {
    var player = PlayerModel()
    var count = 0
    var currentLevel = 1
    var currentSavedLevel = 1
    var gameLevels = [LevelModel]()
    weak var logic: GameLogic?
    
    init () {
        createLevels()
    }
    
    enum DidCameToNextSpot {
        case Success, Fail
    }
    
    func cameToNextSpot(nextSpot : DidCameToNextSpot) {
        switch nextSpot {
        case .Success:
            if var level = gameLevels.first(where: { $0.identifier == currentLevel + 1 } ) {
                if level.primeLevel == true {
                    count += 1
                    currentSavedLevel = level.identifier
                    checkLevel(&level)
                    deleteOldLevels(identifier: level.identifier)
                    createLevels()
                }
                checkLevel(&level)
                currentLevel = level.identifier }
        case .Fail:
            if player.bonuses[Bonus.Shield]! > 0 {
                player.bonuses[Bonus.Shield]! -= 1
            } else {
                currentLevel = currentSavedLevel
            }
            logic?.failedToMakeToANewSpot(identifier: currentLevel)
        }
    }
    
    func findNextSpot() {
        let newLevel = currentLevel + 1
        logic?.moveToNextSpot(identifier: newLevel)
    }
    
    func deleteOldLevels(identifier: Int) {
        let oldLevels = gameLevels.filter { $0.identifier < identifier }
        gameLevels.removeAll(where: { $0.identifier < identifier })
        logic?.deleteLevels(levels: oldLevels)
    }
    
    func checkLevel(_ level: inout LevelModel ) {
        if !level.wasChecked {
            player.bonuses[level.bonus!]! += level.bonusQouantity
            level.wasChecked = true
        }
    }
    
    func createLevels() {
        let maxRangeNumber = gameLevels.isEmpty ? 10 : 5
        for _ in 1...maxRangeNumber {
            let level = LevelModel()
            self.gameLevels.append(level)
        }
    }
}
