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
            gridCell.label?.text = "\(indexPath.row + 1)"
            gridCell.backgroundColor = AppColors.normalCellBackground
            gridCell.layer.cornerRadius = 3.0
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let validChoices = gameState.getValidChoicesFromCell(index : pickerUI.selectedBoardCell)
        let chosenNumber = indexPath.row + 1
        if(!validChoices.contains(chosenNumber)) {
            return // Don't do anything if the number chosen from the picker is invalid
        }
        
        pickerUI.selectCell(at: indexPath.row)
        
        if let _ = collectionView.cellForItem(at: indexPath) as? GridCell {
            // Choosing the same number removes it
            if(chosenNumber == gameState.gameBoard?.boardArray[pickerUI.selectedBoardCell]) {
                gameState.changeCellNumber(at: pickerUI.selectedBoardCell, value: nil)
            } else {
                gameState.changeCellNumber(at: pickerUI.selectedBoardCell, value: chosenNumber)
            }
            // Remove the picker after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.pickerUI.hidePicker(animated : true)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        pickerUI.deselectCell(at: indexPath.row)
    }
}
