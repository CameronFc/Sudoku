//
//  BoardMethods.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-10-12.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

// This class holds _all_ static methods for board generation and validation.
// Any method that manipulates or validates a board model is in this file.

import Foundation

class BoardMethods {
    
    static let boardSize = 9
    
    static func boardIsFull(_ board : Board) -> Bool {
        for item in board.boardArray {
            guard let _ = item else {
                return false
            }
        }
        return true
    }
    
    static func randomBoardNumber() -> Int {
        let rand = Int(arc4random_uniform(UInt32(boardSize)) + 1)
        return rand
    }
    
    static func generateRandomUnverifiedBoard() -> Board {
        let board = Board()
        for index in 0..<board.totalItems {
            board.boardArray[index] = randomBoardNumber()
        }
        return board
    }
    
    static func boardIsSolved(_ board : Board) -> Bool {
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
    
    static func boardIsNotInvalid(_ board : Board) -> Bool {
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
    
    static func isValid(subArray : [Int?]) -> Bool {
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
    
    static func isNotInvalid(subArray : [Int?]) -> Bool {
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
    
    
    static func generateUnsolvedBoard(difficulty : Difficulty) -> Board {
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
        
        // Note that the board permanents have changed
        BoardMethods.setBoardPermanents(board)
        return board
    }
    
    static func generateFullSolvedBoard() -> Board {
        
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
        var board : Board
        while(currentCellIndex < boardSize * boardSize) {
            // If we are rolling back and we have used up all our guesses for this cell, keep going back
            if(rollback && guesses[currentCellIndex] == randomSeedBoardArray[currentCellIndex]) {
                currentCellIndex -= 1
                continue
            }
            guesses[currentCellIndex] = ((guesses[currentCellIndex]) % (boardSize)) + 1
            //let guess = guesses[currentCellIndex]
            board = Board(initArray : Array(guesses[0...currentCellIndex]))
            if(boardIsNotInvalid(board)) {
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
        return Board(initArray : guesses)
    }
    
    static func setBoardPermanents(_ board : Board) {
        board.permanents = [Int : Int]()
        for index in 0..<board.totalItems {
            if let cellValue = board.boardArray[index] {
                board.permanents[index] = cellValue
            }
        }
    }
    
    static func getValidChoicesFromCell(board : Board, index : Int) -> [Int] {
        // Can't replace permanents
        if let _ = board.permanents[index] {
            return []
        }
        let rcr = board.getRowColRegion(from: index)
        let placesToCheck = [board.column(rcr.row), board.row(rcr.column), board.region(rcr.region)]
        // Take each section and remove nils, then flatten to a single set.
        guard let filteredPlaces = (placesToCheck.map { $0.filter { $0 != nil }}) as? [[Int]] else {
            return [] // This should never return here unless someone changes board cells to have a non-Int type.
        }
        var flattened = Set<Int>(filteredPlaces.flatMap { $0 })
        if let currentCellNumber = board.boardArray[index] {
            flattened = flattened.subtracting([currentCellNumber])// Choosing the same number is permitted.
        }
        var validChoices : Set = [1,2,3,4,5,6,7,8,9]
        // Remove invalid choices.
        validChoices = validChoices.subtracting(validChoices.intersection(flattened))
        return Array(validChoices)
    }
}
