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
    fileprivate var moveStack = [(index : Int, oldValue : Int?, newValue : Int?)]() // Stack of moves for use in undoing player moves
    
    init() {
        finished = false
        subscribers = [GameStateDelegate]()
        gameBoard = BoardMethods.generateFullSolvedBoard()
    }
    
}
// Convenience methods to modify the state
extension GameState {
    
    func startNewGame(at difficulty: Difficulty) {
        gameBoard = BoardMethods.generateUnsolvedBoard(difficulty: difficulty)
        finished = false
        moveStack.removeAll()
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
        //Save the old value to add to the stack later
        let oldValue : Int? = gameBoard.boardArray[index]
        // Only allow changing non-permanents
        if(gameBoard.permanents[index] == nil) {
            gameBoard.boardArray[index] = value
        }
        if(boardIsSolved()) {
            self.finished = true
        } else {
            self.finished = false
        }
        
        let currentMove = (index : index, oldValue : oldValue, newValue : value)
        moveStack.append(currentMove)
        
        notifySubscribers()
    }
    
    // Returns the cells index of the last move, if it exists
    func undoLastMove() -> Int? {
        // Check is stack is empty and unwrap
        guard let lastMove = moveStack.popLast() else {
            return nil
        }
        gameBoard?.boardArray[lastMove.index] = lastMove.oldValue
        notifySubscribers()
        return lastMove.index
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
