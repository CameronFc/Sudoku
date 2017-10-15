//
//  MenuViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-10-04.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

// This ViewController is seen when the user launches the app without having a saved game,
// or if they go back to the main menu.

import UIKit

class MenuViewController: UIViewController {
    
    var navController : UINavigationController?
    
    var gameState : GameState! // Mark: Forced unwrapping
    
    var viewController : ViewController?
    
    var titleLabel : UILabel!
    
    var gameMenu : UIStackView!
    
    var wasLoaded = false // was loaded from Disk
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // Mark : Hack - this is kinda backwards, set properties first..
        if let gameState = NSKeyedUnarchiver.unarchiveObject(withFile: GameState.ArchiveURL.path) as? GameState {
            wasLoaded = true
            self.gameState = gameState
        } else {
            wasLoaded = false
            self.gameState = GameState()
        }
    }
    
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerUI = PickerUIController()
        let boardUI = BoardUIController()
        pickerUI.boardUI = boardUI
        viewController = ViewController(gameState : gameState, pickerUI : pickerUI, boardUI : boardUI)
        viewController?.navController = navController
        
        setupSubviews()
    }
    
    func segueBackToGame() {
        if let viewController = viewController {
            navController?.show(viewController, sender: self)
        }
    }
    
    func toggleResumeButton(enabled : Bool) {
        
        if(enabled) {
            // Add the resume button after clicking one of the difficulty buttons
            let existingGameButton = UIBarButtonItem(title: "Resume", style: .done, target: self, action: #selector(segueBackToGame))
            navController?.topViewController?.navigationItem.rightBarButtonItem = existingGameButton
        } else {
            navController?.topViewController?.navigationItem.rightBarButtonItem = nil
        }
    }
}
// Handling touch events
extension MenuViewController {
    
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
        
        gameState.startNewGame(at: difficulty)
        
        guard let navController = navController, let viewController = viewController else {
            return
        }
        
        toggleResumeButton(enabled: true)
        
        if(navController.viewControllers.contains(viewController)) {
            navController.show(viewController, sender: self)
        } else {
            navController.pushViewController(viewController, animated: false)
        }
    }
}
// View initalization
extension MenuViewController {

    func setupSubviews() {
        
        titleLabel = UILabel()
        gameMenu = UIStackView()
        
        view.backgroundColor = AppColors.menuBackground
        titleLabel.text = "SUDOKU!"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Helvetica", size: 64)
        view.addSubview(titleLabel)
        
        titleLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseIn], animations: {
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        
        view.addSubview(gameMenu)
        gameMenu.axis = .vertical
        gameMenu.distribution = .fillEqually
        gameMenu.alignment = .fill
        gameMenu.spacing = 8.0
        gameMenu.backgroundColor = AppColors.shouldNotBeSeen
        
        let difficulties = [Difficulty.superEasy, .easy, .normal, .hard]
        for difficulty in difficulties {
            let newGameButton = UIButton(type : .system)
            newGameButton.setTitle(difficulty.rawValue, for: .normal)
            newGameButton.backgroundColor = AppColors.normalCellBackground
            newGameButton.layer.cornerRadius = GameConstants.menuButtonCornerRadius
            newGameButton.layer.borderWidth = GameConstants.menuButtonBorderWidth
            // Easiest way to attach data to a button press. 
            // We could use a collectionView or tableView instead.
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
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 300),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        gameMenu.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameMenu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameMenu.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gameMenu.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier : 0.5)
        ])
        
        transitionIfLoaded()
    }
}
// Loading from old game
extension MenuViewController {

    func transitionIfLoaded() {
        
        guard let navController = navController, let viewController = viewController else {
            return
        }
        if(wasLoaded) {
            toggleResumeButton(enabled: true)
            if(navController.viewControllers.contains(viewController)) {
                navController.show(viewController, sender: self)
            } else {
                navController.pushViewController(viewController, animated: false)
            }
        } else {
            print("Was not loaded!! :(")
        }
        
    }
}
