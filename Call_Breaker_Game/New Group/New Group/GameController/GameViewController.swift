//
//  GameViewController.swift
//  Call_Breaker_Game
//
//  Created by MACPC on 19/04/24.
//
//
//  GameViewController.swift
//  Donut_Game
//
//  Created by MACPC on 18/04/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
let skview : SKView = {
let view = SKView()
view.translatesAutoresizingMaskIntoConstraints = false
return view
    }()
    
//    let slider : UISlider = {
//        let slider = UISlider()
//        slider.translatesAutoresizingMaskIntoConstraints = false
//        slider.min
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(skview)

        skview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        skview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        skview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        skview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        
        let scene = GameScene(size: CGSize(width: ScreenSize.width, height: ScreenSize.height ))
        scene.scaleMode = .aspectFill
        skview.presentScene(scene)
        skview.ignoresSiblingOrder = true
    }

}
