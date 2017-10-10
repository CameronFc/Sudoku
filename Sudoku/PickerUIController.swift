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
    
    var delegate : NumberPickerViewController!
    
    var boardUIDelegate : BoardUIController!
    
    fileprivate var cellStatuses : [Int : CellStatus]
    
    var isHidden : Bool {
        
        didSet {
            delegate.view.isHidden = isHidden
        }
    }
    
    var selectedCells = [Int : Bool]() {
        
        didSet {
            for pair in selectedCells {
                if let cell = delegate.collectionView?.cellForItem(at: IndexPath( row : pair.key, section : 0)) as? GridCell {
                    if(pair.value) {
                        cell.backgroundColor = AppColors.selectedCell
                    } else {
                        cell.backgroundColor = AppColors.numberPickerCell
                    }
                }
            }
        }
    }
    
    var selectedBoardCell = 0
    
    init() {
        
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
        if(status == .selectable) {
            delegate.setCellBackground(at: index, color : AppColors.selectableCell)
            if let gridCell = delegate.collectionView?.cellForItem(at: IndexPath(row : index, section : 0)) as? GridCell {
                gridCell.label.textColor = .black
            }
            
        } else {
            delegate.setCellBackground(at: index, color : AppColors.numberPickerCell)
            if let gridCell = delegate.collectionView?.cellForItem(at: IndexPath(row : index, section : 0)) as? GridCell {
                gridCell.label.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
            }
        }
    }
    // Set all selectable cells
    func setSelectableCells(for indices : [Int]) {
        
        for index in 0..<cellStatuses.count {
            setCellStatus(at: index, status: .unselectable)
        }
        for index in indices {
            setCellStatus(at: index, status: .selectable)
        }
    }
    
    func setSelectedBoardCell(at index : Int) {
        
        selectedBoardCell = index
    }
}

// External controls for manipulating the pickerView
extension PickerUIController {
    func repositionPicker(center : CGPoint) {
        // Assemble the vector from the mainView's origin to where the center of the picker should spawn
        var newPickerCenter = boardUIDelegate.delegate.view.superview?.bounds.origin ?? CGPoint (x : 0.0 , y: 0.0)
        newPickerCenter.x *= -1
        newPickerCenter.y *= -1
        newPickerCenter.x += center.x * boardUIDelegate.customZoomScale
        newPickerCenter.y += center.y * boardUIDelegate.customZoomScale
        newPickerCenter.y -= 130
        
        self.isHidden = false
        
        delegate.view.center = newPickerCenter
        delegate.view.center.y += 50
        delegate.view.alpha = 0.1
        UIView.animate(withDuration: 0.3, delay : 0.0, options : [.curveEaseInOut], animations: { [unowned self] in
            self.delegate.view.center.y -= 50
            self.delegate.view.alpha = 1.0
            }, completion : nil)
    }
    
    func hidePicker() {
        
        UIView.animate(withDuration: 0.1, delay : 0.0, options : [.curveEaseIn], animations: { [unowned self] in
            self.delegate.view.alpha = 0.0
        }, completion : { (someBool) in
            self.isHidden = true
        })
    }
}
