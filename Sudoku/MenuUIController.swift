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
        
        guard let navController = delegate?.navController, let viewController = delegate?.viewController else {
            return
        }
        if(wasLoaded) {
            //toggleResumeButton(enabled: true)
            if(navController.viewControllers.contains(viewController)) {
                navController.show(viewController, sender: self)
            } else {
                navController.pushViewController(viewController, animated: false)
            }
        } else {
            print("Did not load from a previous game.")
        }
        
    }
    
    func transitionToGame() {
        
        guard let viewController = delegate?.viewController, let navController = delegate?.navController else {
            return
        }
        //if(delegate?.navController.viewControllers.contains(viewController) ?? false) {
            //navController.show(viewController, sender: self)
        //} else {
            navController.pushViewController(viewController, animated: false)
        //}
    }
}
