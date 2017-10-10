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

fileprivate let customColors = [
    "eggshellWhite" : UIColor(red: 240.0 / m, green: 234.0 / m, blue: 214.0 / m, alpha: 1.0),
    "orange" : UIColor(red : 255 / m, green : 215 / m, blue : 0 / m , alpha : 1.0),
    "skyBlue" : UIColor(red: 135 / m, green: 206 / m, blue: 250 / m, alpha: 1.0)
]


struct AppColors {
    let cellBackground = customColors["eggshellWhite"]!
    let numberPickerCell = UIColor(red: 210.0 / m, green: 204.0 / m, blue: 184.0 / m, alpha: 1.0)
    let selectedCell = UIColor(red: 255 / m, green: 135 / m, blue: 30 / m, alpha: 1.0)
    let selectableCell = UIColor(red: 240.0 / m, green: 234.0 / m, blue: 214.0 / m, alpha: 1.0)
    let menuBackgroundColor = UIColor.white
    let gameBackground = customColors["skyBlue"]!
    let shouldNotBeSeen = UIColor.magenta
}

let appColors = AppColors()
