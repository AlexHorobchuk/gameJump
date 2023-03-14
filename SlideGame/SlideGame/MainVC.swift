//
//  ViewController.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import UIKit
import SpriteKit

class MainVC: UIViewController {
    
    var game = SlideGame()
    var scoreLevelLabel: UILabel!
    var bonusStack: UIStackView!
    var settingsButton: UIButton!
    var settingsStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        let scene = GameScene(game: game, size: view.bounds.size)
        let skView = SKView()
        view = skView
        game.updatePlayersInfo = self
        skView.presentScene(scene)
        scoreLevelLabel = setupLevelLabel()
        bonusStack = createBonusStack()
        updateBonusStack()
        settingsButton = setupSettingsButton()
        MusicManager.shared.playBackgroundMusic()
        setupSettingsStack()
    }
    
    func setupLevelLabel() -> UILabel {
        let label = UILabel()
        label.text = "Level: \(game.score)"
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
        return label
    }
    
    func createBonusStack() -> UIStackView {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .equalSpacing
        vStack.spacing = 10
        view.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.leftAnchor.constraint(equalTo: view.leftAnchor),
            vStack.rightAnchor.constraint(equalTo: scoreLevelLabel.leftAnchor),
            vStack.topAnchor.constraint(equalTo: scoreLevelLabel.bottomAnchor)
        ])
        
        for bonus in Bonus.allCases {
            let bonusImage = UIImageView(image: createImageForBonus(bonus: bonus))
            let label = UILabel()
            label.text = String(game.bonuses[bonus]!)
            label.textColor = .systemBlue
            label.font = .systemFont(ofSize: 24, weight: .medium)
            bonusImage.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bonusImage.widthAnchor.constraint(equalToConstant: 40),
                bonusImage.heightAnchor.constraint(equalToConstant: 40),
                label.leadingAnchor.constraint(equalTo: bonusImage.trailingAnchor, constant: 10),
                label.centerYAnchor.constraint(equalTo: bonusImage.centerYAnchor)
            ])
            vStack.addArrangedSubview(bonusImage)
        }
        return vStack
    }
    
    func setupSettingsButton() -> UIButton {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "gear.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 45),
            button.heightAnchor.constraint(equalToConstant: 45),
            button.topAnchor.constraint(equalTo: scoreLevelLabel.bottomAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)])
        
        return button
    }
    
    func updateBonusStack() {
        bonusStack.subviews.forEach { $0.removeFromSuperview() }
        for bonus in Bonus.allCases {
            let bonusImage = UIImageView(image: createImageForBonus(bonus: bonus))
            let label = UILabel()
            label.text = String(game.bonuses[bonus]!)
            label.textColor = .systemBlue
            label.font = .systemFont(ofSize: 24, weight: .medium)
            bonusImage.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bonusImage.widthAnchor.constraint(equalToConstant: 40),
                bonusImage.heightAnchor.constraint(equalToConstant: 40),
                label.leadingAnchor.constraint(equalTo: bonusImage.trailingAnchor, constant: 10),
                label.centerYAnchor.constraint(equalTo: bonusImage.centerYAnchor)
            ])
            bonusStack.addArrangedSubview(bonusImage)
        }
    }
    
    func createImageForBonus(bonus: Bonus) -> UIImage {
        switch bonus {
        case .money:
            return UIImage(systemName: "dollarsign.circle.fill")!
        case .shield:
            return UIImage(systemName: "shield.fill")!
        case .speedUp:
            return UIImage(systemName: "bolt.circle.fill")!
        }
    }
    
    func setupSettingsStack() {
        settingsStack.axis = .vertical
        settingsStack.alignment = .center
        settingsStack.distribution = .equalSpacing
        settingsStack.spacing = 10
        view.addSubview(settingsStack)
        settingsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsStack.rightAnchor.constraint(equalTo: settingsButton.rightAnchor),
            settingsStack.centerXAnchor.constraint(equalTo: settingsButton.centerXAnchor),
            settingsStack.topAnchor.constraint(equalTo: settingsButton.bottomAnchor),
            settingsStack.leftAnchor.constraint(equalTo: settingsButton.leftAnchor)
        ])
        updateSettingsStack()
        settingsStack.subviews.forEach { button in
            button.isHidden = true
            button.alpha = 0
        }
    }
    
    func updateSettingsStack() {
        settingsStack.subviews.forEach { $0.removeFromSuperview() }
        let musicButton = ButtonFactory.createSettingsButton(type: .music)
        let soundButton = ButtonFactory.createSettingsButton(type: .sound)
        let vibrationButton = ButtonFactory.createSettingsButton(type: .vibration)
        [musicButton, soundButton, vibrationButton].forEach { button in
            settingsStack.addArrangedSubview(button)
            button.addTarget(self, action: #selector(musicButtonPressed), for: .touchUpInside)
        }
    }
    
    @objc func showSettings() {
        settingsStack.subviews.forEach { button in
            UIView.animate(withDuration: 0.7) {
                button.isHidden = !button.isHidden
                button.alpha = button.alpha == 0 ? 1 : 0
            }
        }
        SoundManager.shared.playSound(for: .click)
    }
    
    @objc func musicButtonPressed(_ sender: UIButton) {
        switch sender.currentTitle {
        case Settings.music.rawValue:
            UserDefaultsManager.shared.isMusicEnabled.toggle()
        case Settings.sound.rawValue:
            UserDefaultsManager.shared.isSoundEnabled.toggle()
        case Settings.vibration.rawValue:
            UserDefaultsManager.shared.isVibrationEnabled.toggle()
        default:
            print("no action")
        }
        updateSettingsStack()
        SoundManager.shared.playSound(for: .click)
    }
}
    

extension MainVC: UpdatePlayersInfo {
    func updateScore(score: Int) {
        scoreLevelLabel.text = "Level: \(score)"
    }
    
    func updateBonus() {
        updateBonusStack()
    }
}

