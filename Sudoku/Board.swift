//
//  Board.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-14.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit
import Foundation

struct PropertyKey{
    static let boardArray = "boardArray"
    static let permanents = "permanents"
}

final class Board : NSObject, NSCoding {
    
    let width = 9
    var totalItems : Int {
        return (width * width)
    }
    var boardArray : [Int?]
    var permanents : [Int : Int] // Index, Value
    
    required init?(coder aDecoder: NSCoder) {
        guard let boardArray = aDecoder.decodeObject(forKey: PropertyKey.boardArray) as? [Int?],
            let permanents = aDecoder.decodeObject(forKey: PropertyKey.permanents) as? [Int : Int] else {
            print("Failed to resture board state from save.")
            return nil
        }
        self.boardArray = boardArray
        self.permanents = permanents
    }
    
    override init() {
        boardArray = [Int?]()
        permanents = [Int : Int]()
        super.init()
        
        for _ in 0..<totalItems {
            boardArray.append(nil)
        }
    }
    
    init(initArray : [Int?]) {
        boardArray = [Int?]()
        permanents = [Int : Int]()
        super.init()
        
        if(initArray.count > totalItems) {
            assert(false, "Can't pass \(initArray.count) items to board with total size \(totalItems)")
        }
        boardArray.append(contentsOf: initArray)
        for _ in 0..<(totalItems - initArray.count) {
            boardArray.append(nil)
        }
        // Automatically set board permanents when any board is generated.
        BoardMethods.setBoardPermanents(self)
    }
}
// NSCoding
extension Board {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(boardArray, forKey: PropertyKey.boardArray)
        aCoder.encode(permanents, forKey: PropertyKey.permanents)
    }
}
// Board model methods
extension Board {

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
    
    func row(_ at : Int) -> [Int?] {
        let indices = (at * width)..<((at + 1) * width)
        return Array(boardArray[indices])
    }
    
    func column(_ at : Int) -> [Int?] {
        var out =  [Int?]()
        for row in 0..<width {
            out.append(boardArray[row * width + at])
        }
        return out
    }
    
    func region(_ at : Int) -> [Int?] {
        assert(width == 9, "Only implemented for normal-sized boards.")
        let baseX = (at % 3) * 3
        let baseY = Int(floor(Double(at) / 3)) * 3
        var out =  [Int?]()
        for y in 0..<3 {
            for x in 0..<3 {
                let index = (baseY + y) * width + baseX + x
                out.append(boardArray[index])
            }
        }
        return out
    }
    
    func getRowColRegion(from index : Int) -> (row : Int, column : Int, region : Int) {
        return (
            row : index % 9,
            column : index / 9,
            region : ((index / 9) / 3) * 3 + ((index % 9) / 3)
        )
    }
    
    func boardDescription() -> String {
        var out = ""
        for index in 0..<totalItems {
            if let x = boardArray[index] {
                out.append(String(describing : x) + ",")
            } else {
                out.append(" ")
            }
            if(index % width == width - 1) {
                out.append("\n")
            }
        }
        return out
    }
}


