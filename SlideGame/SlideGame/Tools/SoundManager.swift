//
//  soundManager.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 3/6/23.
//

import Foundation

import AVFAudio

class SoundManager {
    static let shared = SoundManager()
    private init() {}
    var player: AVAudioPlayer?
    
    enum Sounds: String {
        case jump = "Jump",
        faild = "Faild",
        madeToStation = "MadeToStation",
        click = "Click"
    }
    
    func playSound(for name: Sounds) {
        let isSoundOn = UserDefaultsManager.shared.isSoundEnabled
        if isSoundOn {
            if let url = Bundle.main.url(forResource: name.rawValue, withExtension: "mp3") {
                do {
                    player = try AVAudioPlayer(contentsOf: url)
                    player?.play()
                    
                } catch {
                    print("mussic error")
                }
            }
        } else {
            player?.stop()
            player = nil
        }
    }
}
