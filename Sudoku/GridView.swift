//
//  GridView.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-15.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import Foundation
import UIKit

class GridView<CellType : UIView> : UIView {
    
    let cells : [CellType]
    let numCells : (Int, Int)
    let cellBorderWidth : CGFloat = 3.0
    let cellBorderColor : CGColor = UIColor(white: 0.0, alpha: 1.0).cgColor
    
    func cellAtIndex(_ x : Int, _ y : Int) -> CellType? {
        let pos = y * numCells.0 + x
        // Safe bounds checking
        if(x < 0 || x >= numCells.0 || y < 0 || y >= numCells.1) {
            return nil
        }
        return cells[pos]
    }
    
    init?(frame : CGRect, cells : [CellType], numCells : (Int, Int), options : [String]) {
        self.cells = cells
        self.numCells = numCells
        super.init(frame : frame)
        
        // Assert that the provided grid dimensions match the size of the provided cell array
        guard cells.count == (numCells.0 * numCells.1) else {
            return nil 
        }
        
        // Setup the cells with everything but their constraints
        for y in 0..<numCells.1 {
            for x in 0..<numCells.0 {
                let cell = cellAtIndex(x, y)!
                cell.backgroundColor = .white
                cell.layer.borderColor = cellBorderColor
                cell.layer.borderWidth = cellBorderWidth
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.layer.cornerRadius = 6
                self.addSubview(cell)
            }
        }
        
        setupConstraints()
    }
    
    // Constraints we want: Cells have same size,
    //Assert: Cell borders completely overlap on interior cells
    // MARK: Constraints
    func setupConstraints() {
        //let totalWidth = Double(numCells.0 + 1) * Double(cellBorderWidth)
        //let totalHeight = Double(numCells.1 + 1) * Double(cellBorderWidth)
        for y in 0..<numCells.1 {
            for x in 0..<numCells.0 {
                let cell = cellAtIndex(x, y)!
                
                let cellLeadingAnchor = cellAtIndex(x - 1, y)?.trailingAnchor ?? leadingAnchor
                let cellTopAnchor = cellAtIndex(x, y - 1)?.bottomAnchor ?? topAnchor
                
                NSLayoutConstraint.activate([
                    // Assert cells have equal width and height. They are 1 nth of the size of the container
                    cell.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CGFloat(1.0 / Double(numCells.0)) ),
                    cell.heightAnchor.constraint(equalTo: cell.widthAnchor),
                    cell.leadingAnchor.constraint(equalTo : cellLeadingAnchor, constant: -cellBorderWidth),
                    cell.topAnchor.constraint(equalTo : cellTopAnchor, constant: -cellBorderWidth)
                ])
                cell.setNeedsUpdateConstraints()
                
            }
        }
    }
    
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        numCells = (0,0)
        cells = []
        super.init(coder : aDecoder)
    }
}
