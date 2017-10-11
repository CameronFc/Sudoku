//
//  constants.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-10-09.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import Foundation
import UIKit

struct GameConstants {
    static private let borderSize = 1.0
    static private let numberPickerBorderWidth = 1.0
    static private let numberPickerCellWidth = 50.0
    static let extraCellSize = 1.0
    static let boardCellSize = 35.0
    static let totalBoardSize = CGFloat(boardCellSize * 9 + borderSize * 2 + 6 * extraCellSize)
    static let totalPickerWidth = CGFloat(3 * numberPickerCellWidth + 2 * numberPickerBorderWidth)
    
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
