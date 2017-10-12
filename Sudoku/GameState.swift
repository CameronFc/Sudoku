//
//  GameController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-21.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

// This singleton class manages all state information of the board.
// It is responsible for maintaining a board, keeping a stack of player
// moves, keeping track if the game is finished, and notifiying
// subscribers when the board state has changed as a result of
// player interaction.

import Foundation

enum Difficulty : String {
    case superEasy = "Super Easy"
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"
}

class GameState {
    
    var gameBoard : Board?
    var finished : Bool
    
    var subscribers : [GameStateDelegate] // List of views that subscribe to updates
    fileprivate var moveStack = [(index : Int, value : Int)]() // Stack of moves for use in undoing player moves
    
    init() {
        finished = false
        subscribers = [GameStateDelegate]()
        gameBoard = BoardMethods.generateFullSolvedBoard()
    }
    
}
// Convenience methods to modify the state
extension GameState {
    
    func generateUnsolvedBoard(difficulty: Difficulty) {
        gameBoard = BoardMethods.generateUnsolvedBoard(difficulty: difficulty)
        notifySubscribers()
    }
    
    func getValidChoicesFromCell(index: Int) -> [Int] {
        guard let gameBoard = gameBoard else {
            return []
        }
        return BoardMethods.getValidChoicesFromCell(board: gameBoard, index: index)
    }
    
    func boardIsSolved() -> Bool {
        guard let gameBoard = gameBoard else {
            return false
        }
        return BoardMethods.boardIsSolved(gameBoard)
    }
    
    func changeCellNumber(at index : Int, value : Int?) {
        guard let gameBoard = gameBoard else {
            return
        }
        // Only allow changing non-permanents
        if(gameBoard.permanents[index] == nil) {
            gameBoard.boardArray[index] = value
        }
        if(boardIsSolved()) {
            self.finished = true
        } else {
            self.finished = false
        }
        
        notifySubscribers()
    }
}

extension GameState {
    
    func notifySubscribers() {
        for subscriber in subscribers {
            subscriber.gameStateDidChange(finished : self.finished)
        }
    }
    
    func subscribeToUpdates(subscriber : GameStateDelegate) {
        subscribers.append(subscriber)
    }
}

// Views subscribe to the gameController through this protocol to be notified of updates to the gameState.
protocol GameStateDelegate {
    func gameStateDidChange(finished : Bool)
}
