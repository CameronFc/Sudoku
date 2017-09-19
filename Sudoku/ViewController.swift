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
    
    var boardView : UIView!
    
    var boardViewController : BoardViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //delegate.newGame()
        
        view.backgroundColor = .cyan
        let viewLayout = UICollectionViewFlowLayout()
        //viewLayout.itemSize = CGSize(width: 20, height: 20)
        boardViewController = BoardViewController(collectionViewLayout: viewLayout)
        boardView = boardViewController!.view!
        view.addSubview(boardView)
       
        boardView.translatesAutoresizingMaskIntoConstraints = false // GET WRECKED STORYBOARD
        // MARK : Constraints
        NSLayoutConstraint.activate([
            boardView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -5),
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
    
    override func viewWillLayoutSubviews() {
        boardViewController?.collectionView?.reloadData()
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        print("After layoutSubviews in ViewController")
        print("ViewController's child, UICollectionViewContainer, has frame: \(boardView.frame)'")
        super.viewDidLayoutSubviews()
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

