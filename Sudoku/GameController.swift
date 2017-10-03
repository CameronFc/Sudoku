//
//  GameController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-21.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import Foundation

class GameController {
    
    // TODO: Remove this and all mutations, move board code to a Board Controller
    var gameBoard : Board!
    
    private var boardSize : Int
    
    init() {
        boardSize = 9
        let _ = generateFullSolvedBoard()
    }
    
    func boardIsFull() -> Bool{
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
    
    enum Difficulty {
        case easy
        case normal
        case hard
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
        }
        
        let randRange : Int = Int(arc4random_uniform(UInt32(range.high - range.low))) + range.low
        let numToRemove = Int(board.totalItems * (100 - randRange)/100)
        
        var cellsToKeepAlive = [Int]()
        for index in 0..<(board.totalItems) {
            cellsToKeepAlive.append(index)
        }
        
        //print(cellsToKeepAlive)
        for _ in 0..<numToRemove{
            let rand = Int(arc4random_uniform(UInt32(cellsToKeepAlive.count)))
            //print(rand)
            cellsToKeepAlive.remove(at: rand)
        }
        //print(cellsToKeepAlive)
        
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
            //print("Current cell : \(currentCellIndex)")
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
        
        return Board(size : boardSize, initArray : guesses)
    }
    
    func setBoardPermanents() {
        gameBoard.permanents = [Int : Int]()
        for index in 0..<gameBoard.totalItems {
            if let cellValue = gameBoard.boardArray[index] {
                gameBoard.permanents[index] = cellValue
            }
        }
    }
    
    func getValidChoicesFromCell(index : Int) -> [Int] {
        if let _ = gameBoard.permanents[index] {
            return []
        }
        return [1, 2, 3]
    }
}

extension GameController : GameControllerDelegate {}

// Exposes game state to views.
protocol GameControllerDelegate {
    var gameBoard : Board! { get }
    func getValidChoicesFromCell(index : Int) -> [Int]
}




