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
    
    var isHidden : Bool {
        didSet {
            numberPickerDelegate.view.isHidden = isHidden
        }
    }
    
    init(numberPickerDelegate : NumberPickerViewController) {
        self.numberPickerDelegate = numberPickerDelegate
        self.isHidden = true
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
        if(status == .selectable) {
            numberPickerDelegate.setCellBackground(at: index, color : appColors.selectableCell)
        } else {
            numberPickerDelegate.setCellBackground(at: index, color : appColors.eggshellWhite)
        }
    }
    
    // Set all selectable cells
    func setSelectableCells(for indices : [Int]) {
        for index in 0..<cellStatuses.count {
            setCellStatus(at: index, status: .unselectable)
        }
        //print(indices)
        for index in indices {
            setCellStatus(at: index, status: .selectable)
        }
    }
    
    func setSelectedBoardCell(at index : Int) {
        numberPickerDelegate.selectedBoardCell = index
    }
}

// External controls for manipulating the pickerView
extension PickerUIController {
    func repositionPicker(center : CGPoint) {
        self.isHidden = false
        //let oldFrame = numberPickerDelegate.view.frame
        //print(center)
        //numberPickerDelegate.view.frame = CGRect(origin : CGPoint(x: 50.0, y: 50.0), size : oldFrame.size)
            //self.numberPickerDelegate.view.alpha = 1.0
        numberPickerDelegate.view.center = center
        numberPickerDelegate.view.center.y += 50
        numberPickerDelegate.view.alpha = 0.1
        UIView.animate(withDuration: 0.3, delay : 0.0, options : [.curveEaseInOut], animations: { [unowned self] in
            self.numberPickerDelegate.view.center.y -= 50
            self.numberPickerDelegate.view.alpha = 1.0
            }, completion : nil)
    }
    
    func hidePicker() {
        UIView.animate(withDuration: 0.1, delay : 0.0, options : [.curveEaseIn], animations: { [unowned self] in
            self.numberPickerDelegate.view.alpha = 0.0
        }, completion : { (someBool) in
            self.isHidden = true
        })
    }
}
