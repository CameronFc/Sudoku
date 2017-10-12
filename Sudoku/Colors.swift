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
    static let deepOrange = UIColor(red: 255 / m, green: 135 / m, blue: 30 / m, alpha: 1.0)
    static let fadedEggshell = UIColor(red: 210.0 / m, green: 204.0 / m, blue: 184.0 / m, alpha: 1.0)
    static let darkGray = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
}

struct AppColors {
    static let normalCellBackground = CustomColors.eggshellWhite
    static let unselectableCellBackground = CustomColors.fadedEggshell
    static let selectedCellBackground = CustomColors.deepOrange
    static let cellBorder = UIColor.black
    static let cellText = UIColor.black
    static let cellGrayText = CustomColors.darkGray
    static let menuBackground = UIColor.white
    static let gameBackground = CustomColors.skyBlue
    static let shouldNotBeSeen = UIColor.magenta
}
