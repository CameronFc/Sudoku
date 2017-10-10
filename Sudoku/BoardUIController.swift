//
//  BoardUIController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-10-09.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import Foundation
import UIKit

class BoardUIController {
    
    weak var delegate : BoardViewController?
    
    var selectedCells = [Int : Bool]() {
        didSet {
            for pair in selectedCells {
                if let cell = delegate?.collectionView?.cellForItem(at: IndexPath( row : pair.key, section : 0)) as? GridCell {
                    if(pair.value) {
                        cell.backgroundColor = AppColors.selectedCell
                    } else {
                        cell.backgroundColor = AppColors.cellBackground
                    }
                }
            }
        }
    }
    
    // Gives us access to scrollView's zoom scale
    public var customZoomScale : CGFloat = 1.0
    
    public func deselectAllCells() {
        for pair in selectedCells {
            selectedCells[pair.key] = false
        }
    }
}
