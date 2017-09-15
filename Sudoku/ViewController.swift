//
//  ViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-14.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // The controller we talk to that handles all the business of the app
    let delegate : GameControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //delegate.newGame()
        
        view.backgroundColor = .cyan
        let gridViewController = GridViewController()
        gridViewController.view.backgroundColor = .green
        view.addSubview(gridViewController.view)
        gridViewController.view.translatesAutoresizingMaskIntoConstraints = false
        gridViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        gridViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -50).isActive = true
        gridViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gridViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        gridViewController.view.setNeedsUpdateConstraints()
        
        
        let label = UILabel()
        view.addSubview(label)
        label.text = "Test"
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50.0).isActive = true
        label.setNeedsUpdateConstraints()
        
        view.setNeedsLayout()
        
        
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

