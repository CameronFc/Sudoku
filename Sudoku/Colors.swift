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
struct AppColors {
    let eggshellWhite = UIColor(red: 240.0 / m, green: 234.0 / m, blue: 214.0 / m, alpha: 1.0)
    let selectedCell = UIColor(red: 255 / m, green: 135 / m, blue: 30 / m, alpha: 1.0)
    let selectableCell = UIColor(red : 255 / m, green : 215 / m, blue : 0 / m , alpha : 1.0)
    let menuBackgroundColor = UIColor.white
}

let appColors = AppColors()
