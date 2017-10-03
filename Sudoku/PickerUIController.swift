//
//  UIPickerController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-10-03.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import Foundation
import UIKit

enum CellStatus {
    case selectable
    case unselectable
}

class PickerUIController {
    
    let numberPickerDelegate : NumberPickerViewController!
    
    fileprivate var cellStatuses : [Int : CellStatus]
    
    var isHidden = true {
        didSet {
            numberPickerDelegate.view.isHidden = isHidden
        }
    }
    
    init(numberPickerDelegate : NumberPickerViewController) {
        self.numberPickerDelegate = numberPickerDelegate
        cellStatuses = [Int : CellStatus]()
        for index in 0..<9 {
            cellStatuses[index] = .unselectable
        }
    }
}

// State mangement
extension PickerUIController {
    // External accessors becuase property observers for dictionaries suck
    func getCellStatus(at index : Int) -> CellStatus {
        assert(0 <= index && index <= 8)
        return cellStatuses[index]!
    }
    
    func setCellStatus(at index : Int, status : CellStatus) {
        assert(0 <= index && index <= 8)
        cellStatuses[index] = status
        //
        numberPickerDelegate.setCellBackground(at: index, color: (status == .selectable) ? .red : .gray)
    }
    
    // Set all selectable cells
    func setSelectableCells(for indices : [Int]) {
        for index in 0..<cellStatuses.count {
            setCellStatus(at: index, status: .unselectable)
        }
        print(indices)
        for index in indices {
            setCellStatus(at: index, status: .selectable)
        }
    }
}

// External controls for manipulating the pickerView
extension PickerUIController {
    func repositionPicker(center : CGPoint) {
        numberPickerDelegate.view.center = center
    }
}
