//
//  BoardViewDataSource.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-10-09.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

// This file handles board touch events, and the creation of cells.

import Foundation
import UIKit

// UICollectionViewDataSource conformance
extension BoardViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let gridCell = cell as? GridCell {
            let cellText = (gameState.gameBoard?.boardArray[indexPath.row])?.description ?? " "
            gridCell.label?.text = cellText
            if (gameState.gameBoard?.permanents[indexPath.row] != nil) {
                gridCell.label?.font = UIFont.fromPreset(GameConstants.bigCellText)
            } else {
                gridCell.label?.font = UIFont.fromPreset(GameConstants.normalCellText)
            }
            
            if(boardUI.selectedCells[indexPath.row]) {
                gridCell.backgroundColor = AppColors.selectedCellBackground
            } else {
                gridCell.backgroundColor = AppColors.normalCellBackground
            }
            
            let x = indexPath.row % 9
            let y = indexPath.row / 9
            let borderWidth = CGFloat(2.0)
            // Add right borders
            if( x % 3 == 2 ) {
                gridCell.setBorderWidth(.right, width: borderWidth)
            } else {
                gridCell.setBorderWidth(.right, width: 0.0)
            }
            // Add left borders
            if( x % 3 == 0 ) {
                gridCell.setBorderWidth(.left, width: borderWidth)
            } else {
                gridCell.setBorderWidth(.left, width: 0.0)
            }
            // Add top borders
            if( y % 3 == 0 ) {
                gridCell.setBorderWidth(.top, width: borderWidth)
            } else {
                gridCell.setBorderWidth(.top, width: 0.0)
            }
            // Add bottom borders
            if( y % 3 == 2 ) {
                gridCell.setBorderWidth(.bottom, width: borderWidth)
            } else {
                gridCell.setBorderWidth(.bottom, width: 0.0)
            }
            return gridCell
        }
        assertionFailure("Could not generate board cell properly.")
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        boardUI.deselectAllCells()
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? GridCell {
            
            boardUI.selectCell(at: indexPath.row)
            
            // Set the background color of the picker cells to indicate invalid choices
            var validChoices = gameState.getValidChoicesFromCell(index: indexPath.row)
            validChoices = validChoices.map { $0 - 1} //Convert items from 1...9 to 0...8; Numbers to cellIndices
            pickerUI.setSelectableCells(for: validChoices)
            pickerUI.selectedBoardCell = indexPath.row
           
            // Move the picker to the correct spot and show it if necessary
            if(gameState.gameBoard?.permanents[indexPath.row] == nil) {
                let cellCenter = selectedCell.center
                pickerUI.repositionPicker(center: cellCenter)
            } else {
                // Hide the picker if we select a permanent or a filled cell
                pickerUI.hidePicker(animated : true)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //Deselection state management is done by BoardUIController.
    }
}
