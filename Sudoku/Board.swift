//
//  Board.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-14.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

final class Board {
    
    let width : Int
    var totalItems : Int {
        return (width * width)
    }
    var boardArray : [Int?]
    
    init(size : Int) {
        boardArray = [Int?]()
        width = size
        for _ in 0..<totalItems {
            boardArray.append(nil)
        }
    }
    
    private func at(_ x : Int, _ y : Int) -> Int? {
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


