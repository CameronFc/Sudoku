//
//  BoardViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-18.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GridCell"
fileprivate let sectionInsets = UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)

final class BoardViewController: UICollectionViewController {
    
    var superScrollView : UIView?
    
    var gameState : GameState?
    
    var pickerUIDelegate : PickerUIController?
    
    var selectedCells = [Int : Bool]() {
        didSet {
            for pair in selectedCells {
                if let cell = collectionView?.cellForItem(at: IndexPath( row : pair.key, section : 0)) as? GridCell {
                    if(pair.value) {
                        cell.backgroundColor = appColors.selectedCell
                    } else {
                        cell.backgroundColor = appColors.eggshellWhite
                    }
                }
            }
        }
    }
    
    // Gives us access to scrollView's zoom scale
    public var customZoomScale : CGFloat = 1.0
    
    init(delegate : GameState, pickerUIDelegate : PickerUIController) {
        self.pickerUIDelegate = pickerUIDelegate
        gameState = delegate
        let viewLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: viewLayout)
        // Subscribe to game state updates
        gameState?.delegates.append(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.allowsMultipleSelection = false
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.layer.borderWidth = 1.0
        collectionView?.layer.cornerRadius = 2.0
        collectionView?.backgroundColor = .magenta
        
        self.collectionView!.register(GridCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        //print("doing viewWillLayoutSubviews in boardController")
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
}

// MARK : Auxillary methods
extension BoardViewController {
    
    public func deselectAllCells() {
        for pair in selectedCells {
            selectedCells[pair.key] = false
        }
    }
}

// MARK: UICollectionViewDataSource
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
            let cellText = (gameState?.gameBoard?.boardArray[indexPath.row])?.description ?? " "
            gridCell.label.text = cellText
            if (gameState?.gameBoard.permanents[indexPath.row] != nil) {
                gridCell.label.font = UIFont(name: "Helvetica-Bold", size: 20)
            } else {
                gridCell.label.font = UIFont(name: "Helvetica", size: 18)
            }
            gridCell.backgroundColor = appColors.eggshellWhite
            
            let x = indexPath.row % 9
            let y = indexPath.row / 9
            let borderWidth = CGFloat(2.0)
            // Add right borders
            if( x % 3 == 2 ) {
                gridCell.rightBorder.frame = CGRect(x: gridCell.frame.width - borderWidth, y: 0 , width: borderWidth, height: gridCell.frame.height)
            } else {
                gridCell.rightBorder.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            }
            // Add left borders
            if( x % 3 == 0 ) {
                gridCell.leftBorder.frame = CGRect(x: 0 , y: 0 , width: borderWidth, height: gridCell.frame.height)
            } else {
                gridCell.leftBorder.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            }
            // Add top borders
            if( y % 3 == 0 ) {
                gridCell.topBorder.frame = CGRect(x: 0 , y: 0 , width: gridCell.frame.height, height: borderWidth)
            } else {
                gridCell.topBorder.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            }
            // Add bottom borders
            if( y % 3 == 2 ) {
                gridCell.bottomBorder.frame = CGRect(x: 0 , y: gridCell.frame.height - borderWidth , width: gridCell.frame.height, height: borderWidth)
            } else {
                gridCell.bottomBorder.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            }
            return gridCell
        }
        assertionFailure("Could not generate board cell properly.")
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("Selected \(indexPath.description)")
        //print(collectionView.frame)
        
        // Remove all other highlights, just in case
        deselectAllCells()
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? GridCell {
            selectedCells[indexPath.row] = true
            
            // Set the background color of the picker cells to indicate invalid choices
            var validChoices = gameState!.getValidChoicesFromCell(index: indexPath.row)
            validChoices = validChoices.map { $0 - 1} //Convert items from 1...9 to 0...8; Numbers to cellIndices
            pickerUIDelegate?.setSelectableCells(for: validChoices)
            pickerUIDelegate?.setSelectedBoardCell(at: indexPath.row)
           
            // Move the picker to the correct spot and show it if necessary
            if(gameState?.gameBoard.permanents[indexPath.row] == nil) {
                //print("The boardview's super bounds is \((view.superview?.bounds.origin))")
                // Assemble the vector from the mainView's origin to where the center of the picker should spawn
                var newPickerCenter = view.superview?.bounds.origin ?? CGPoint (x : 0.0 , y: 0.0)
                newPickerCenter.x *= -1
                newPickerCenter.y *= -1
                newPickerCenter.x += selectedCell.center.x * customZoomScale
                newPickerCenter.y += selectedCell.center.y * customZoomScale
                newPickerCenter.y -= 130
                //var newCenter = CGPoint(x : selectedCell.center.x * customZoomScale, y : selectedCell.center.y * customZoomScale)
                pickerUIDelegate?.repositionPicker(center: newPickerCenter)
            } else {
                // Hide the picker if we select a permanent or a filled cell
                pickerUIDelegate?.hidePicker()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let _ = collectionView.cellForItem(at: indexPath) as? GridCell {
            selectedCells[indexPath.row] = false
        }
    }
}

extension BoardViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let availableWidth = 326.0
        let widthPerItem = 36.0 // CGFloat((availableWidth / 9.0))
        var cellWidth = widthPerItem
        var cellHeight = widthPerItem
        let x = indexPath.row % 9
        let y = indexPath.row / 9
        if(x % 3 == 0 || x % 3 == 2) {
            cellWidth += 1
        }
        if(y % 3 == 0 || y % 3 == 2) {
            cellHeight += 1
        }
        return CGSize(width : cellWidth, height : cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0 //sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0 //sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width : 0, height : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width : 0, height : 0)
    }
}

extension BoardViewController : GameStateDelegate {
    func gameStateDidChange(finished : Bool) {
        //print("The gameState is letting us know that it has updated.")
        collectionView?.reloadData()
    }
}

