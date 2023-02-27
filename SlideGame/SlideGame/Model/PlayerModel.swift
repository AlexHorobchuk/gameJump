//
//  PlayerModel.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import Foundation

struct PlayerModel {
    var bonuses = [Bonus.Shield : 0,
                   Bonus.SpeedUP : 0,
                   Bonus.Money : 0]
    var speed: Int = 700
}
