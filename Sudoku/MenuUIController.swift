//
//  MenuUIController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-10-16.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

// This class is responsible for handling state changes that occur on the main
// menu screen.

import Foundation
import UIKit

class MenuUIController {
    
    weak var delegate : MenuViewController?
    
    var wasLoaded = false // was loaded from Disk
    
    @objc func segueBackToGame() {
        if let viewController = delegate?.viewController {
            delegate?.navController?.show(viewController, sender: self)
        }
    }
    
    func toggleResumeButton(enabled : Bool) {
        // MARK : Dirty hack. This will only change the status of the current nav bar right item,
        // not necessarily the undo button.
        if(enabled) {
            if let button = delegate?.navController?.topViewController?.navigationItem.rightBarButtonItem {
                button.isEnabled = true
                //print("Enabling the resume button")
            }
        } else {
            if let button = delegate?.navController?.topViewController?.navigationItem.rightBarButtonItem {
                button.isEnabled = false
                //print("Disabling the resume button")
            }
        }
    }
    // Loading from old game
    func transitionIfLoaded() {
        
        if(wasLoaded) {
            if(delegate?.gameState.finished ?? true) { // Assume finished
                // Don't bother to transition if the loaded game is finished!
                return
            }
            transitionToGame()
        } else {
            print("Did not load from a previous game.")
        }
        
    }
    
    func transitionToGame() {
        
        guard let viewController = delegate?.viewController, let navController = delegate?.navController else {
            return
        }
        let backButton = UIBarButtonItem(title: "Menu", style: .plain, target: nil, action: nil)
        delegate?.navigationItem.backBarButtonItem = backButton
        navController.pushViewController(viewController, animated: false)
    }
}
