//
//  Colors.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-10-06.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import Foundation
import UIKit

fileprivate let m = CGFloat(256.0)

struct CustomColors {
    static let eggshellWhite = UIColor(red: 240.0 / m, green: 234.0 / m, blue: 214.0 / m, alpha: 1.0)
    static let orange = UIColor(red : 255 / m, green : 215 / m, blue : 0 / m , alpha : 1.0)
    static let skyBlue = UIColor(red: 135 / m, green: 206 / m, blue: 250 / m, alpha: 1.0)
}

struct AppColors {
    static let cellBackground = CustomColors.eggshellWhite
    static let cellBorder = UIColor.black
    static let numberPickerCell = UIColor(red: 210.0 / m, green: 204.0 / m, blue: 184.0 / m, alpha: 1.0)
    static let selectedCell = UIColor(red: 255 / m, green: 135 / m, blue: 30 / m, alpha: 1.0)
    static let selectableCell = UIColor(red: 240.0 / m, green: 234.0 / m, blue: 214.0 / m, alpha: 1.0)
    static let menuBackgroundColor = UIColor.white
    static let gameBackground = CustomColors.skyBlue
    static let shouldNotBeSeen = UIColor.magenta
}
