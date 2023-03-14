//
//  Settings.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 3/10/23.
//

import UIKit

enum Settings: String {
    case music = "music", sound = "sound", vibration = "vibration"
}

class ButtonFactory {
    
    static func createButton(isON: Bool, isOnImage: UIImage, isOffImage: UIImage, title: String ) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = isON ? isOnImage : isOffImage
        button.setBackgroundImage(image, for: .normal)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)])
        return button
    }
    
    static func createSettingsButton(type: Settings) -> UIButton {
        switch type {
        case .music:
            return createButton(isON: UserDefaultsManager.shared.isMusicEnabled, isOnImage: UIImage(systemName: "speaker.wave.2.circle.fill")!, isOffImage: UIImage(systemName: "speaker.slash.circle.fill")!, title: type.rawValue)
        case .sound:
            return createButton(isON: UserDefaultsManager.shared.isSoundEnabled, isOnImage: UIImage(systemName: "ear.and.waveform")!, isOffImage: UIImage(systemName: "ear")!, title: type.rawValue)
        case .vibration:
            return createButton(isON: UserDefaultsManager.shared.isVibrationEnabled, isOnImage: UIImage(systemName: "iphone.homebutton.radiowaves.left.and.right.circle")!, isOffImage: UIImage(systemName: "iphone.homebutton.circle")!, title: type.rawValue)
        }
    }
}
