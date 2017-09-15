//
//  Board.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-14.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import Foundation

final class Board {
    
    let width : Int
    private var boardArray : [Int?]
    
    init(size : Int) {
        boardArray = [Int?]()
        width = size
        for _ in 0..<(size * size) {
            boardArray.append(nil)
        }
    }
    
    func at(_ x : Int, _ y : Int) -> Int? {
        guard x < boardArray.count
            && x >= 0
            && y < boardArray.count
            && y >= 0 else {
            return nil
        }
        return boardArray[x * (y + 1)]
    }
    
    subscript(_ x: Int, _ y: Int) -> Int?{
        return self.at(x, y)
    }
}
