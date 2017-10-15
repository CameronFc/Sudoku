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

struct GameStatePropertyKey {
    static let gameBoard = "gameBoard"
    static let finished = "finished"
    static let moveStack = "moveStack"
}

class GameState : NSObject {
    // MARK: Force unwrapping. Should be safe.
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first! 
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("gameState")
    
    var gameBoard : Board?
    var finished : Bool = false
    
    var subscribers : [GameStateDelegate] // List of views that subscribe to updates
    
    fileprivate var moveStack = [Move]() // Stack of moves for use in undoing player moves
    // Init with fully solved board by default
    override init() {
        subscribers = [GameStateDelegate]()
        gameBoard = BoardMethods.generateFullSolvedBoard()
        super.init()
    }
    // Load from disk
    required init?(coder aDecoder: NSCoder) {
        
        guard let gameBoard = aDecoder.decodeObject(forKey: GameStatePropertyKey.gameBoard) as? Board else {
            print("Could not load board from previously saved game.")
            return nil
        }
        guard let moveStack = aDecoder.decodeObject(forKey: GameStatePropertyKey.moveStack) as? [Move] else {
            print("Could not load move stack from previous game.")
            return nil
        }
        self.gameBoard = gameBoard
        finished = aDecoder.decodeBool(forKey: GameStatePropertyKey.finished)
        self.moveStack = moveStack
        // We can't easily save the subscriber list because we are going to
        // remake those viewControllers anyway - so start with an empty subscriber list on load.
        self.subscribers = [GameStateDelegate]() 
        
        super.init()
    }
}
// Persistence related methods
extension GameState : NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(gameBoard, forKey: GameStatePropertyKey.gameBoard)
        aCoder.encode(finished, forKey: GameStatePropertyKey.finished)
        aCoder.encode(moveStack, forKey: GameStatePropertyKey.moveStack)
    }
    
    func saveGame() {
        let wasSuccessful = NSKeyedArchiver.archiveRootObject(self, toFile: GameState.ArchiveURL.path)
        if(wasSuccessful) {
            //print("Successfully saved.")
        } else {
            print("There was an error in saving the game.")
        }
    }
}
// Convenience methods to modify the state
extension GameState {
    
    func startNewGame(at difficulty: Difficulty) {
        
        gameBoard = BoardMethods.generateUnsolvedBoard(difficulty: difficulty)
        finished = false
        moveStack.removeAll()
        notifySubscribers()
        saveGame()
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
        
        let currentMove = Move(index, oldValue, value)
        moveStack.append(currentMove)
        
        notifySubscribers()
        saveGame()
    }
    
    // Returns the cells index of the last move, if it exists
    func undoLastMove() -> Int? {
        // Check is stack is empty and unwrap
        guard let lastMove = moveStack.popLast() else {
            return nil
        }
        gameBoard?.boardArray[lastMove.index] = lastMove.oldValue
        notifySubscribers()
        saveGame()
        return lastMove.index
    }
    
    func moveStackIsEmpty() -> Bool {
        return moveStack.isEmpty
    }
}
// Pub-Sub methods
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
// Makes game moves a nested class. This makes serialization easier.
extension GameState {
    
    private struct PropertyKeys {
        static let index = "index"
        static let oldValue = "oldValue"
        static let newValue = "newValue"
    }
    
    class Move : NSObject, NSCoding {
        let index : Int
        let oldValue : Int?
        let newValue : Int?
        
        init(_ index : Int, _ oldValue : Int?, _ newValue : Int?) {
            self.index = index
            self.oldValue = oldValue
            self.newValue = newValue
            super.init()
        }
        
        required init?(coder aDecoder: NSCoder) {
            index = aDecoder.decodeInteger(forKey: PropertyKeys.index)
            oldValue = aDecoder.decodeObject(forKey: PropertyKeys.oldValue) as? Int
            newValue = aDecoder.decodeObject(forKey : PropertyKeys.newValue ) as? Int
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(index, forKey : PropertyKeys.index)
            aCoder.encode(oldValue, forKey : PropertyKeys.oldValue)
            aCoder.encode(newValue, forKey : PropertyKeys.newValue)
        }
    }
}
