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
    
    weak var delegate : NumberPickerViewController?
    
    var boardUI : BoardUIController?
    
    fileprivate var cellStatuses : [CellStatus] // Indicates which cells are selectale
    
    fileprivate var selectedCells : [Bool] // Indicates which cells have a highlight applied
    
    var selectedBoardCell = 0
    
    init() {
        
        cellStatuses = [CellStatus]()
        selectedCells = [Bool]()
        
        for _ in 0..<9 {
            selectedCells.append(false)
            cellStatuses.append(.unselectable)
        }
        
        hidePicker(animated: false)
    }
}

// State mangement
extension PickerUIController {
    
    func getCellStatus(at index : Int) -> CellStatus {
        
        assert(0 <= index && index <= 8)
        return cellStatuses[index]
    }
    
    func setCellStatus(at index : Int, status : CellStatus) {
        
        assert(0 <= index && index <= 8)
        cellStatuses[index] = status
        
        if(status == .selectable) {
            changeCellGrayedOut(at: index, grayedOut: false)
        } else {
            changeCellGrayedOut(at: index, grayedOut: true)
        }
    }
    
    // selectMultipleCells
    func setSelectableCells(for indices : [Int]) {
        
        for index in 0..<cellStatuses.count {
            setCellStatus(at: index, status: .unselectable)
        }
        for index in indices {
            setCellStatus(at: index, status: .selectable)
        }
    }
    
    func selectCell(at index : Int) {
        
        changeCellHighlight(at: index, highlighted: true)
    }
    
    func deselectCell(at index : Int) {
        
        changeCellHighlight(at: index, highlighted: false)
    }
    
    func getPickerCell(at index : Int) -> GridCell? {
        
        return delegate?.collectionView?.cellForItem(at: IndexPath( row : index, section : 0)) as? GridCell
    }
}

// Controls for changing view appearance
extension PickerUIController {
    
    func changeCellHighlight(at index : Int, highlighted : Bool) {
        
        if let cell = getPickerCell(at: index) {
            if(highlighted) {
                cell.backgroundColor = AppColors.selectedCellBackground
            } else {
                cell.backgroundColor = AppColors.normalCellBackground
            }
        }
    }
    
    func changeCellGrayedOut(at index : Int, grayedOut : Bool) {
        
        if let cell = getPickerCell(at: index) {
            if(grayedOut) {
                cell.backgroundColor = AppColors.unselectableCellBackground
                cell.label?.textColor = AppColors.cellGrayText
            } else {
                cell.backgroundColor = AppColors.normalCellBackground
                cell.label?.textColor = AppColors.cellText
            }
        }
    }
}

// External controls for manipulating the pickerView
extension PickerUIController {
    
    func repositionPicker(center : CGPoint) {
        
        // Assemble the vector from the mainView's origin to where the center of the picker should spawn
        var newPickerCenter = boardUI?.delegate?.view.superview?.bounds.origin ?? CGPoint (x : 0.0 , y: 0.0)
        newPickerCenter.x *= -1
        newPickerCenter.y *= -1
        newPickerCenter.x += center.x * (boardUI?.customZoomScale ?? 1.0)
        newPickerCenter.y += center.y * (boardUI?.customZoomScale ?? 1.0)
        newPickerCenter.y -= 130
        
        delegate?.view.center = newPickerCenter
        showPicker(animated: true)
    }
    
    func showPicker(animated : Bool) {
        
        delegate?.view.isHidden = false
        
        if(!animated) {
            delegate?.view.alpha = 1.0
        } else {
            delegate?.view.center.y += 50
            delegate?.view.alpha = 0.1
            UIView.animate(withDuration: 0.3, delay : 0.0, options : [.curveEaseInOut], animations: { [unowned self] in
                self.delegate?.view.center.y -= 50
                self.delegate?.view.alpha = 1.0
            }, completion : nil)
        }
    }
    
    func hidePicker(animated : Bool) {
        
        if(animated) {
            UIView.animate(withDuration: 0.1, delay : 0.0, options : [.curveEaseIn], animations: { [unowned self] in
                self.delegate?.view.alpha = 0.0
            }, completion : { (someBool) in
                self.delegate?.view.isHidden = true
            })
        } else {
            delegate?.view.isHidden = true
        }
    }
}
