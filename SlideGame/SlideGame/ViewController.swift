//
//  ViewController.swift
//  SlideGame
//
//  Created by Olha Dzhyhirei on 2/20/23.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = SKView()
        view = skView
        skView.presentScene(scene)
    }


}

