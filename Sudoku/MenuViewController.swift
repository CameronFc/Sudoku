//
//  MenuViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-10-04.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    var navDelegate : UINavigationController!
    
    var gameStateDelegate : GameState
    
    var viewController : ViewController?
    
    var titleLabel : UILabel!
    
    var gameMenu : UIStackView!
    
    init(gameStateDelegate : GameState) {
        self.gameStateDelegate = gameStateDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerUI = PickerUIController()
        let boardUI = BoardUIController()
        pickerUI.boardUIDelegate = boardUI
        viewController = ViewController(gameStateDelegate : gameStateDelegate, pickerUIDelegate : pickerUI, boardUIDelegate : boardUI)
        viewController?.navDelegate = navDelegate
        
        setupSubviews()
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
        gameStateDelegate.gameBoard = gameStateDelegate.generateUnsolvedBoard(difficulty: difficulty)
        gameStateDelegate.setBoardPermanents() // DON'T REMOVE; REFACTOR LATER
        
        if(navDelegate.viewControllers.contains(viewController!)) {
            navDelegate.show(viewController!, sender: self)
        } else {
            navDelegate.pushViewController(viewController!, animated: false)
        }
        
    }
    
    func setupSubviews() {
        
        titleLabel = UILabel()
        gameMenu = UIStackView()
        
        view.backgroundColor = AppColors.menuBackgroundColor
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
            newGameButton.backgroundColor = AppColors.cellBackground
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
    }
}
