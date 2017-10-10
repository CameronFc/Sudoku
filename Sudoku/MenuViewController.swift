//
//  MenuViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-10-04.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    var navControllerDelegate : UINavigationController?
    
    var titleLabel : UILabel!
    
    var gameMenu : UIStackView!
    
    var difficultyButtons = [DifficultyButton]()
    
    var selectedDifficulty = Difficulty.easy
    
    let gameController = GameController()
    
    var viewController : ViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.menuBackgroundColor
        
        titleLabel = UILabel()
        titleLabel.text = "SUDOKU!"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Helvetica", size: 64)
        view.addSubview(titleLabel)
        
        titleLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseIn], animations: {
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: { (result : Bool) in
        
        })
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 300),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        gameMenu = UIStackView()
        view.addSubview(gameMenu)
        gameMenu.axis = .vertical
        gameMenu.distribution = .fillEqually
        gameMenu.alignment = .fill
        gameMenu.spacing = 8.0
        gameMenu.backgroundColor = .magenta
        
        gameMenu.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameMenu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameMenu.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gameMenu.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier : 0.5)
        ])
        
        let difficulties = [Difficulty.superEasy, .easy, .normal, .hard]
        for difficulty in difficulties {
            let newGameButton = UIButton(type : .system)
            newGameButton.setTitle(difficulty.rawValue, for: .normal)
            newGameButton.backgroundColor = AppColors.cellBackground
            newGameButton.layer.cornerRadius = 15.0
            newGameButton.layer.borderWidth = 2.0
            // MARK : SMELLS BAD
            var tag = 0
            switch(difficulty) {
            case .superEasy :
                tag = 0
            case .easy :
                tag = 1
            case .normal :
                tag = 2
            case .hard :
                tag = 3
            }
            newGameButton.tag = tag
            
            newGameButton.addTarget(self, action: #selector(self.handleDifficultyButtonPress), for: .touchUpInside)
            gameMenu.addArrangedSubview(newGameButton)
        }
        
        let pickerUI = PickerUIController()
        let boardUI = BoardUIController()
        pickerUI.boardUIDelegate = boardUI
        viewController = ViewController(gameStateDelegate : gameController, pickerUIDelegate : pickerUI, boardUIDelegate : boardUI)
        viewController?.navDelegate = navControllerDelegate
    }
    
    func handleDifficultyButtonPress(sender : UIButton) {
        var difficulty = Difficulty.superEasy
        switch(sender.tag) {
        case 0 :
            difficulty = .superEasy
        case 1 :
            difficulty = .easy
        case 2 :
            difficulty = .normal
        case 3 :
            difficulty = .hard
        default :
            assertionFailure("Something bad went wrong with the buttons!")
        }
        // Do any additional setup after loading the view.
        gameController.gameBoard = gameController.generateUnsolvedBoard(difficulty: difficulty)
        gameController.setBoardPermanents() // DON'T REMOVE; REFACTOR LATER
        
        if(navControllerDelegate!.viewControllers.contains(viewController!)) {
            navControllerDelegate?.show(viewController!, sender: self)
        } else {
            navControllerDelegate?.pushViewController(viewController!, animated: false)
        }
        
    }

}

class DifficultyButton : UIButton {
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
    }
}







