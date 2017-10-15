//
//  BoardUIController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-10-09.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

// This class is responsible for handling state-related methods concerning the 
// board view. It is also an interface that other viewControllers use 
// to access the board view. It can modify both the game-related UI state
// and the properties of the board view.

import Foundation
import UIKit

class BoardUIController {
    
    weak var delegate : BoardViewController?
    
    var selectedCells : [Bool]
    
    init() {
        selectedCells = [Bool]()
        for _ in 0..<81 {
            selectedCells.append(false)
        }
    }
    
    // Gives us access to scrollView's zoom scale
    public var customZoomScale : CGFloat = 1.0
    
    public func deselectAllCells() {
        selectedCells = selectedCells.map({ (wasHighlightedBefore) in false })
        if let boardCells = delegate?.collectionView?.visibleCells {
            for cell in boardCells{
                cell.backgroundColor = AppColors.normalCellBackground
            }
        } else {
            print("The board collection view reported no cells were visible!")
        }
    }
    
    public func selectCell(at index : Int) {
        if let cell = getBoardCell(at: index) {
            selectedCells[index] = true
            cell.backgroundColor = AppColors.selectedCellBackground
        } else {
            print("Tried to select invalid board cell at : \(index)")
        }
    }
    
    func getBoardCell(at index : Int) -> UIView? {
        // MARK : DIRTY Hack. In certain contexts (like clicking the undo button), calls to
        // .cellForRowAt will always return nil - the collectionView thinks none of the cells are
        // visible, when clearly they can be seen. In these cases, we use .dequeueReusableCell instead;
        // this alternate method shows that the gridCells have their .Hidden property set to true,
        // which explains why .visibleCells and .cellForRowAt returns nil in these contexts.
        if(delegate?.collectionView?.visibleCells.isEmpty ?? false) {
            return delegate?.collectionView?.dequeueReusableCell(withReuseIdentifier: "GridCell", for: IndexPath(row : index, section : 0)) as? GridCell
        } else {
            return delegate?.collectionView?.cellForItem(at: IndexPath(row : index, section : 0)) as? GridCell
        }
    }
}
