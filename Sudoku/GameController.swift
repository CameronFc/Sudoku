//
//  GameController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-21.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import Foundation

enum Difficulty : String {
    case superEasy = "Super Easy"
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"
}

class GameController {
    
    // TODO: Remove this and all mutations, move board code to a Board Controller
    var gameBoard : Board?
    var finished : Bool
    
    private var boardSize : Int
    var subscribers : [GameStateDelegate] // List of views that subscribe to updates
    
    init() {
        boardSize = 9
        finished = false
        subscribers = [GameStateDelegate]()
        let _ = generateFullSolvedBoard()
    }
    
    func boardIsFull() -> Bool {
        guard let gameBoard = gameBoard else {
            return false
        }
        for item in gameBoard.boardArray {
            guard let _ = item else {
                return false
            }
        }
        return true
    }
    
    func randomBoardNumber() -> Int {
        let rand = Int(arc4random_uniform(UInt32(boardSize)) + 1)
        return rand
    }
    
    func generateRandomUnverifiedBoard() -> Board {
        let board = Board(size : boardSize)
        for index in 0..<board.totalItems {
            board.boardArray[index] = randomBoardNumber()
        }
        return board
    }
    
    func boardIsSolved() -> Bool {
        guard let gameBoard = gameBoard else {
            return false
        }
        assert(gameBoard.width == 9, "Only implemented for normal-sized boards.")
        for y in 0..<gameBoard.width {
            let subArray = gameBoard.row(y)
            if (!isValid(subArray: subArray)) {
                return false
            }
        }
        
        for x in 0..<gameBoard.width {
            let subArray = gameBoard.column(x)
            if (!isValid(subArray: subArray)) {
                return false
            }
        }
        
        for region in 0..<gameBoard.width {
            let subArray = gameBoard.region(region)
            if (!isValid(subArray: subArray)) {
                return false
            }
        }
        return true
    }
    
    func boardIsNotInvalid() -> Bool {
        guard let gameBoard = gameBoard else {
            return false
        }
        assert(gameBoard.width == 9, "Only implemented for normal-sized boards.")
        for y in 0..<gameBoard.width {
            let subArray = gameBoard.row(y)
            if (!isNotInvalid(subArray: subArray)) {
                return false
            }
        }
        
        for x in 0..<gameBoard.width {
            let subArray = gameBoard.column(x)
            if (!isNotInvalid(subArray: subArray)) {
                return false
            }
        }
        
        for region in 0..<gameBoard.width {
            let subArray = gameBoard.region(region)
            if (!isNotInvalid(subArray: subArray)) {
                return false
            }
        }
        return true
        
    }
    
    func isValid(subArray : [Int?]) -> Bool {
        assert(boardSize == 9, "Only implemented for normal-sized boards.")
        guard let intArray = subArray as? [Int] else {
            return false
        }
        
        let expectedArray = [1,2,3,4,5,6,7,8,9]
        let sortedArray = intArray.sorted()
        
        if(sortedArray == expectedArray) {
            return true
        } else {
            return false
        }
    }
    
    func isNotInvalid(subArray : [Int?]) -> Bool {
        assert(boardSize == 9, "Only implemented for normal-sized boards.")
        assert(subArray.count == 9, "Did not pass a length-9 array to validation checker")
        var boolArray = [false,false,false,false,false,false,false,false,false]
        for index in 0..<9 {
            if let cellNumber = subArray[index] {
                if(boolArray[cellNumber - 1] == true) {
                    return false
                } else {
                    boolArray[cellNumber - 1] = true
                }
            }
        }
        return true
    }
    
    
    func generateUnsolvedBoard(difficulty : Difficulty) -> Board {
        let board = generateFullSolvedBoard()
        let range : (low : Int, high : Int)
        
        switch difficulty {
        case .easy :
            range = (35, 45)
        case .normal:
            range = (20, 35)
        case .hard:
            range = (10, 15)
        case .superEasy:
            range = (95, 98)
        }
        
        let randRange : Int = Int(arc4random_uniform(UInt32(range.high - range.low))) + range.low
        let numToRemove = Int(board.totalItems * (100 - randRange)/100)
        
        var cellsToKeepAlive = [Int]()
        for index in 0..<(board.totalItems) {
            cellsToKeepAlive.append(index)
        }
        
        for _ in 0..<numToRemove{
            let rand = Int(arc4random_uniform(UInt32(cellsToKeepAlive.count)))
            cellsToKeepAlive.remove(at: rand)
        }
        
        for index in 0..<board.boardArray.count {
            if !cellsToKeepAlive.contains(index) {
                board.boardArray[index] = nil
            }
        }
        
        return board
    }
    
    func generateFullSolvedBoard() -> Board {
        
        var randomSeedBoardArray = [Int]()
        for _ in 0..<boardSize*boardSize {
            randomSeedBoardArray.append(randomBoardNumber())
        }
        
        var guesses = randomSeedBoardArray
        
        // Backtracking algorithm
            /*
             start with board from random seed. Keep constant
             try to use current guess
             check ifNotInvalidBoard // area
             true : continue with next guess
             false : if we can still guess new numbers, try that.
             Detect if we can guess a new number by keeping track of its relative position to the cell's seed base.
             If we can't do it, pop the current guess and increment the previous one. Start again.
            */
        var rollback = false
        var currentCellIndex = 0 {
            willSet {
                if newValue < currentCellIndex {
                    rollback = true
                } else  {
                    rollback = false
                }
            }
        }
        while(currentCellIndex < boardSize * boardSize) {
            // If we are rolling back and we have used up all our guesses for this cell, keep going back
            if(rollback && guesses[currentCellIndex] == randomSeedBoardArray[currentCellIndex]) {
                currentCellIndex -= 1
                continue
            }
            guesses[currentCellIndex] = ((guesses[currentCellIndex]) % (boardSize)) + 1
            //let guess = guesses[currentCellIndex]
            gameBoard = Board(size : 9, initArray : Array(guesses[0...currentCellIndex]))
            if(boardIsNotInvalid()) {
                currentCellIndex += 1
                continue
            } else {
                if(guesses[currentCellIndex] == randomSeedBoardArray[currentCellIndex]) {
                    // If our current guess was equal to the base seed, we have tried all we can; rollback
                    currentCellIndex -= 1
                } else {
                    // Keep incrementing on the current guess
                    continue
                }
            }
        }
        // MARK : Code smell - this should be moved elsewhere - notifications should be implicit
        self.finished = false
        notifySubscribers()
        return Board(size : boardSize, initArray : guesses)
    }
    
    func setBoardPermanents() {
        guard let gameBoard = gameBoard else {
            return
        }
        gameBoard.permanents = [Int : Int]()
        for index in 0..<gameBoard.totalItems {
            if let cellValue = gameBoard.boardArray[index] {
                gameBoard.permanents[index] = cellValue
            }
        }
    }
    
    func getValidChoicesFromCell(index : Int) -> [Int] {
        guard let gameBoard = gameBoard else {
            return [] // Return - Can't do anything without a board
        }
        // Can't replace permanents
        if let _ = gameBoard.permanents[index] {
            return []
        }
        let rcr = gameBoard.getRowColRegion(from: index)
        let placesToCheck = [gameBoard.column(rcr.row), gameBoard.row(rcr.column), gameBoard.region(rcr.region)]
        // Take each section and remove nils, then flatten to a single set.
        guard let filteredPlaces = (placesToCheck.map { $0.filter { $0 != nil }}) as? [[Int]] else {
            return [] // This should never return here unless someone changes board cells to have a non-Int type.
        }
        var flattened = Set<Int>(filteredPlaces.flatMap { $0 })
        if let currentCellNumber = gameBoard.boardArray[index] {
            flattened = flattened.subtracting([currentCellNumber])// Choosing the same number is permitted.
        }
        var validChoices : Set = [1,2,3,4,5,6,7,8,9]
        // Remove invalid choices.
        validChoices = validChoices.subtracting(validChoices.intersection(flattened))
        return Array(validChoices)
    }
}

extension GameController : GameState {}

// Exposes game state to views.
protocol GameState {
    var finished : Bool { get set }
    var gameBoard : Board? { get set }
    var subscribers : [GameStateDelegate] { get set }
    func getValidChoicesFromCell(index : Int) -> [Int]
    func boardIsSolved() -> Bool
    func setBoardPermanents()
    func generateUnsolvedBoard(difficulty : Difficulty) -> Board
}

extension GameState {
    
    func notifySubscribers() {
        for subscriber in subscribers {
            subscriber.gameStateDidChange(finished : self.finished)
        }
    }
    
    mutating func subscribeToUpdates(subscriber : GameStateDelegate) {
        subscribers.append(subscriber)
    }
    
    mutating func changeCellNumber(at index : Int, value : Int?) {
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

// Views subscribe to the gameController through this protocol to be notified of updates to the gameState.
protocol GameStateDelegate {
    func gameStateDidChange(finished : Bool)
}
