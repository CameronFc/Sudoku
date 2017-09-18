//
//  ViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-14.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    // The controller we talk to that handles all the business of the app
    let delegate : GameControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //delegate.newGame()
        
        view.backgroundColor = .cyan
        let gridViewController = GridViewController()
        let boardView = gridViewController.view!
        view.addSubview(gridViewController.view)
        
        boardView.translatesAutoresizingMaskIntoConstraints = false // GET WRECKED STORYBOARD
        boardView.backgroundColor = .green
        
        // MARK : Constraints
        NSLayoutConstraint.activate([
            boardView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            boardView.widthAnchor.constraint(equalTo: boardView.heightAnchor), // Make sure the board is always square!
            boardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boardView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        boardView.setNeedsUpdateConstraints()
        
        view.setNeedsUpdateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(delegate : GameControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    // Need to implement this to inject MainController into this file - But we never use this method!
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        delegate = nil
        super.init(coder: aDecoder)
    }


}

