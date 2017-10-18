//
//  constants.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-10-09.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

// This file describes constants that are used in the remainder of the code.
// Its purpose is to avoid magic numbers and to encourage reuse of 
// existing constants (and fonts).

import Foundation
import UIKit

struct GameConstants {
    static private let numberPickerBorderWidth = 1.0
    static private let numberPickerCellWidth = 50.0
    static let extraCellSize = 1.0 // How much a cell contributes to it's region border, if it has one
    static let boardCellSize = 34.0 // Internal size of a cell (does not include borders)
    // The game board is 9 cell widths across. 6 of these cells are extra-sized to account for
    // large borders on the regions and board edges.
    static let totalBoardSize = CGFloat(boardCellSize * 9 + 6 * extraCellSize) + (boardViewBorderWidth * 2)
    static let totalPickerWidth = CGFloat(3 * numberPickerCellWidth + 2 * numberPickerBorderWidth)
    static let cellBorderWidth = CGFloat(1.0) // Default cell border width.
    
    static let boardViewBorderWidth : CGFloat = 2.0
    static let boardViewCornerRadius : CGFloat = 2.0
    
    static let pickerViewBorderWidth : CGFloat = 1.0
    static let pickerViewCornerRadius : CGFloat = 2.0
    
    static let menuButtonCornerRadius : CGFloat = 15.0
    static let menuButtonBorderWidth : CGFloat = 2.0
    
    static let bigCellText = (name : "Helvetica-Bold", size: 20)
    static let normalCellText = (name: "Helvetica", size: 18)
}

extension UIFont {
    static func fromPreset(_ input : (name : String, size : Int)) -> UIFont? {
        return UIFont(name: input.name, size: CGFloat(input.size))
    }
}
