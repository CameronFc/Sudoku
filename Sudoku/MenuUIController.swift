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

    func toggleResumeButton(enabled : Bool) {
        if(enabled) {
            delegate?.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            delegate?.navigationItem.rightBarButtonItem?.isEnabled = false
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
    
    @objc func transitionToGame() {
        
        guard let viewController = delegate?.viewController, let navController = delegate?.navController else {
            return
        }
        let backButton = UIBarButtonItem(title: "Menu", style: .plain, target: nil, action: nil)
        delegate?.navigationItem.backBarButtonItem = backButton
        navController.pushViewController(viewController, animated: false)
    }
}
