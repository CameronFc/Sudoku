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
        
        view.backgroundColor = appColors.menuBackgroundColor
        
        titleLabel = UILabel()
        titleLabel.text = "SUDOKU!"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Helvetica", size: 64)
        view.addSubview(titleLabel)
        
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
        gameMenu.spacing = 5
        gameMenu.backgroundColor = .magenta
        
        gameMenu.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameMenu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameMenu.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        let difficulties = [Difficulty.superEasy, .easy, .normal, .hard]
        for difficulty in difficulties {
            let newGameButton = UIButton(type : .system)
            newGameButton.setTitle(difficulty.rawValue, for: .normal)
            newGameButton.backgroundColor = .green
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
        
        viewController = ViewController(delegate : gameController)
        viewController?.navControllerDelegate = navControllerDelegate
        
        //navControllerDelegate?.pushViewController(viewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleDifficultyButtonPress(sender : UIButton) {
        //print("Shit! We just pressed one of the buttons!")
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
        gameController.setBoardPermanents() // DON"T KILL PLEASE
        
        if(navControllerDelegate!.viewControllers.contains(viewController!)) {
            navControllerDelegate?.show(viewController!, sender: self)
        } else {
            navControllerDelegate?.pushViewController(viewController!, animated: false)
        }
        //navControllerDelegate?.setNavigationBarHidden(true, animated: false)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class DifficultyButton : UIButton {
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
    }
}







