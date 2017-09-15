//
//  MainController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-15.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import Foundation

// Exposes functionality to 
protocol GameControllerDelegate {
    
    func newGame()
    func endGame()
    func getHint()
}

/*
 Must be able to save current board state to disk
*/ 

final class MainController {
    
}

extension MainController : GameControllerDelegate {
    
    func newGame() {
        assertionFailure("A \(type(of: self)) method has not yet implemented.")
    }
    
    func endGame() {
        assertionFailure("A \(type(of: self)) method has not yet implemented.")
    }
    
    func getHint() {
        assertionFailure("A \(type(of: self)) method has not yet implemented.")
    }
}
