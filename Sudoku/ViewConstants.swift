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
    static private let extraCellSize = 1.0
    static private let numberPickerBorderWidth = 1.0
    static private let numberPickerCellWidth = 50.0
    static let boardCellSize = 35.0
    static let totalBoardSize = CGFloat(boardCellSize * 9 + borderSize * 2 + 6 * extraCellSize)
    static let totalPickerWidth = CGFloat(3 * numberPickerCellWidth + 2 * numberPickerBorderWidth)
}
