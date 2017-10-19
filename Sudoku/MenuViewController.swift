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
    
    let menuUI : MenuUIController
    
    var gameState : GameState! // Mark: Forced unwrapping
    
    var viewController : ViewController?
    
    var titleLabel : UILabel!
    
    var gameMenu : UIStackView!
    
    init() {
        menuUI = MenuUIController()
        super.init(nibName: nil, bundle: nil)
        // Mark : Hack - this is kinda backwards, set properties first..
        if let gameState = NSKeyedUnarchiver.unarchiveObject(withFile: GameState.ArchiveURL.path) as? GameState {
            menuUI.wasLoaded = true
            self.gameState = gameState
        } else {
            menuUI.wasLoaded = false
            self.gameState = GameState()
        }
        
        menuUI.delegate = self
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
        setupConstraints()
        menuUI.transitionIfLoaded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("Menu view will appear.")
        if(gameState.finished) {
            menuUI.toggleResumeButton(enabled: false)
        } else {
            menuUI.toggleResumeButton(enabled: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for i in 0..<10 {
            let numberLabel = UILabel()
            numberLabel.text = "\(i)"
            numberLabel.font = UIFont.fromPreset(GameConstants.normalCellText)
            numberLabel.textAlignment = .center
            
            view.addSubview(numberLabel)
            numberLabel.frame = CGRect(x: view.bounds.width / 2, y: view.bounds.height / 2, width: 20.0, height: 20.0)
            numberLabel.bounds = CGRect(x: -10.0, y: -10.0, width: 20.0, height: 20.0)

            let rx = (Double(arc4random_uniform(1000)) - 500.0) / 1000.0
            let ry = (Double(arc4random_uniform(1000)) - 500.0) / 1000.0
            let xvec = CGFloat(rx) * (view.bounds.width)
            let yvec = CGFloat(ry) * (view.bounds.height)
            
            numberLabel.backgroundColor = .magenta
            // MARK : DIRTY HACK
            func inline () {
                UIView.animate(withDuration: 1.0, delay: 0.0, options : [.curveLinear], animations: {
                    let rx = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
                    let ry = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
                    let rz = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
                    let transform = CATransform3DRotate(numberLabel.layer.transform, (3.14), rx, ry, rz)
                    numberLabel.layer.transform = transform
                    numberLabel.center.y += 50
                }, completion : { [weak self] (result) in
                    if let frame = self?.view.frame {
                            if(numberLabel.center.y > frame.height) {
                                numberLabel.center.y -= (frame.height * 1.2)
                            }
                    }
                    inline()
                })
            }
            inline()
            UIView.animate(withDuration: 1.0, animations: {
                numberLabel.center.x -= xvec
                numberLabel.center.y -= yvec
            })
        }
 
    }

}
// Handling touch events
extension MenuViewController {
    
    func handleDifficultyButtonPress(difficulty : Difficulty) {
        gameState.startNewGame(at: difficulty)
        menuUI.transitionToGame()
    }
    // Displays the alertview allowing user to select new game difficulty
    @objc func showGameDifficulties() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Super Easy", style: .default) { [weak self] _ in
            self?.handleDifficultyButtonPress(difficulty: .superEasy)
        })
        alert.addAction(UIAlertAction(title: "Easy", style: .default) { [weak self] _ in
            self?.handleDifficultyButtonPress(difficulty: .easy)
        })
        alert.addAction(UIAlertAction(title: "Normal", style: .default) { [weak self] _ in
            self?.handleDifficultyButtonPress(difficulty: .normal)
        })
        alert.addAction(UIAlertAction(title: "Hard", style: .default) { [weak self] _ in
            self?.handleDifficultyButtonPress(difficulty: .hard)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true)
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
        
        let newGameButton = UIButton(type : .system)
        newGameButton.setTitle("New Game", for: .normal)
        newGameButton.backgroundColor = AppColors.normalCellBackground
        newGameButton.layer.cornerRadius = GameConstants.menuButtonCornerRadius
        newGameButton.layer.borderWidth = GameConstants.menuButtonBorderWidth
        newGameButton.addTarget(self, action: #selector(self.showGameDifficulties), for: .touchUpInside)
        gameMenu.addArrangedSubview(newGameButton)
        // Add the resume button
        let existingGameButton = UIBarButtonItem(title: "Resume", style: .done, target: menuUI, action: #selector(menuUI.transitionToGame))
        navController?.topViewController?.navigationItem.rightBarButtonItem = existingGameButton
        menuUI.toggleResumeButton(enabled: false)
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
            gameMenu.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -50.0),
            gameMenu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameMenu.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier : 0.5)
        ])
    }
}

