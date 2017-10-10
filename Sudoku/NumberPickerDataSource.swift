//
//  NumberPickerDataSource.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-10-09.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import Foundation
import UIKit

// Mark : UICollectionViewDataSource
extension NumberPickerViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let gridCell = cell as? GridCell {
            gridCell.label.text = "\(indexPath.row + 1)"
            gridCell.backgroundColor = AppColors.numberPickerCell
            gridCell.layer.cornerRadius = 3.0
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let validChoices = gameStateDelegate.getValidChoicesFromCell(index : pickerUIDelegate.selectedBoardCell)
        let chosenNumber = indexPath.row + 1
        if(!validChoices.contains(chosenNumber)) {
            return // Don't do anything if the number chosen from the picker is invalid
        }
        
        pickerUIDelegate.selectedCells[indexPath.row] = true
        
        if let _ = collectionView.cellForItem(at: indexPath) as? GridCell {
            // Choosing the same number removes it
            if(chosenNumber == gameStateDelegate.gameBoard.boardArray[pickerUIDelegate.selectedBoardCell]) {
                gameStateDelegate.changeCellNumber(at: pickerUIDelegate.selectedBoardCell, value: nil)
            } else {
                gameStateDelegate.changeCellNumber(at: pickerUIDelegate.selectedBoardCell, value: chosenNumber)
            }
            // Remove the picker after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.pickerUIDelegate.hidePicker()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        pickerUIDelegate.selectedCells[indexPath.row] = false
    }
}