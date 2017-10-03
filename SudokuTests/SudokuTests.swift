//
//  SudokuTests.swift
//  SudokuTests
//
//  Created by Cameron Francis on 2017-09-14.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import XCTest
@testable import Sudoku

class SudokuTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFullBoard() {
        let gameController = GameController()
        
        let board = gameController.generateRandomUnverifiedBoard()
        
        print(board.description())
        //print(board.row(8))
        //print(board.column(8))
        //print(board.region(7))
        
        XCTAssert(gameController.boardIsFull())
    }
    
    func testSubsectionValidation() {
        let testArray = [9,8,7,6,5,4,3,2,1] as [Int?]
        let gameController = GameController()
        let result = gameController.isValid(subArray : testArray)
        XCTAssert(result)
    }
    
    func testBoardValidation() {
        let gameController = GameController()
        let board1 = gameController.generateRandomUnverifiedBoard()
        board1.boardArray[0] = 2
        board1.boardArray[1] = 2
        let boardInit =
            [4,2,9,3,1,6,5,7,8,
             8,6,7,5,2,4,1,9,3,
             5,1,3,8,9,7,2,4,6,
             9,3,1,7,8,5,6,2,4,
             6,8,2,9,4,1,7,3,5,
             7,4,5,2,6,3,9,8,1,
             3,5,4,6,7,2,8,1,9,
             1,7,8,4,5,9,3,6,2,
             2,9,6,1,3,8,4,5,7] // Pre-solved example board
        let board2 = Board(size: 9, initArray : boardInit)
        
        //Board with duplicates in same region, row should fail
        gameController.gameBoard = board1
        XCTAssert(!gameController.boardIsSolved())
        gameController.gameBoard = board2
        XCTAssert(gameController.boardIsSolved())
    }
    
    func testBoardRegions() {
        let gameController = GameController()
        let board = gameController.generateRandomUnverifiedBoard()
        print(board.description())
        for region in 0..<9 {
            print(board.region(region).map {
                return $0!
            })
        }
    }
    
    func testIsNotValidSubarray() {
        let gameController = GameController()
        let testArray1 = [9,8,7,6,5,4,3,2,1] as [Int?]
        let testArray2 = [9,9,7,6,5,4,3,2,1] as [Int?]
        let testArray3 = [9,8,7,nil,nil,nil,3,2,nil] as [Int?]
        let testArray4 = [9,nil,nil,9,1,2,3,4,5] as [Int?]
        
        XCTAssert(gameController.isNotInvalid(subArray: testArray1))
        XCTAssert(!gameController.isNotInvalid(subArray: testArray2))
        XCTAssert(gameController.isNotInvalid(subArray: testArray3))
        XCTAssert(!gameController.isNotInvalid(subArray: testArray4))
        
    }
    
    func testBoardIsNotInvalid() {
        let gameController = GameController()
        let testBoard1 = gameController.generateRandomUnverifiedBoard()
        testBoard1.boardArray[0] = 1
        testBoard1.boardArray[1] = 1 // Duplicates should always fail
        let testBoard2 = Board(size : 9)
        testBoard2.boardArray[0] = 1
        testBoard2.boardArray[1] = 2
        testBoard2.boardArray[12] = 1 // in next row and region
        
        gameController.gameBoard = testBoard1
        XCTAssert(!gameController.boardIsNotInvalid())
        gameController.gameBoard = testBoard2
        XCTAssert(gameController.boardIsNotInvalid())
    }
    
    func testBoardGenerationSolved() {
        let gameController = GameController()
        let board = gameController.generateFullSolvedBoard()
        print(board.description())
        XCTAssert(gameController.boardIsSolved())
    }
    
    func testBoardGenerationUnsolved() {
        let gameController = GameController()
        let board = gameController.generateUnsolvedBoard(difficulty: .normal)
        print(board.description())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
