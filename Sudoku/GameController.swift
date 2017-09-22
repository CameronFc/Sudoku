//
//  GameController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-21.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import Foundation

class GameController {
    
    var gameBoard : Board?
    private var boardSize : Int
    
    init() {
        boardSize = 9
        gameBoard = generateFullSolvedBoard()
    }
    
    func boardIsFull(board : Board) -> Bool{
        for item in board.boardArray {
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
    
    func boardIsSolved(board : Board) -> Bool {
        assert(board.width == 9, "Only implemented for normal-sized boards.")
        for y in 0..<board.width {
            let subArray = board.row(y)
            if (!isValid(subArray: subArray)) {
                return false
            }
        }
        
        for x in 0..<board.width {
            let subArray = board.column(x)
            if (!isValid(subArray: subArray)) {
                return false
            }
        }
        
        for region in 0..<board.width {
            let subArray = board.region(region)
            if (!isValid(subArray: subArray)) {
                return false
            }
        }
        return true
    }
    
    func boardIsNotInvalid(board : Board) -> Bool {
        assert(board.width == 9, "Only implemented for normal-sized boards.")
        for y in 0..<board.width {
            let subArray = board.row(y)
            if (!isNotInvalid(subArray: subArray)) {
                return false
            }
        }
        
        for x in 0..<board.width {
            let subArray = board.column(x)
            if (!isNotInvalid(subArray: subArray)) {
                return false
            }
        }
        
        for region in 0..<board.width {
            let subArray = board.region(region)
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
        
        print(cellsToKeepAlive)
        for _ in 0..<numToRemove{
            let rand = Int(arc4random_uniform(UInt32(cellsToKeepAlive.count)))
            print(rand)
            cellsToKeepAlive.remove(at: rand)
        }
        print(cellsToKeepAlive)
        
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
            let board = Board(size : 9, initArray : Array(guesses[0...currentCellIndex]))
            if(boardIsNotInvalid(board: board)) {
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
}
