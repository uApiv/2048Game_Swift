//
//  ViewController.swift
//  my_2048
//
//  Created by Pan Xingyuan on 2020/11/25.
//  Copyright © 2020 Pan Xingyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GameViewDelegate {
    
    private let size = 4
    @IBOutlet weak var gameView: GameView! {
        didSet {
            gameView.size = size
            
        }
    }
    private lazy var game = Game(size: size)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameView.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.startGame()
        }
        
    }
    
    private func startGame() {
        self.game.start { (startCards) in
            self.gameView.performActions(startCards)
        }
    }
    
    func slideEnded(offset: CGPoint) {
        
        let direction: Direction
        if offset.y > offset.x {
            if offset.y > -offset.x {
                direction = .down
            } else {
                direction = .left
            }
        } else {
            if offset.y > -offset.x {
                direction = .right
            } else {
                direction = .up
            }
        }
        game.move(direction) { (actions) in
            gameView.performActions(actions)
            
        }
    }

}

