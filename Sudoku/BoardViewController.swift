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
        collectionView?.backgroundColor = .green
        
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
        let indexPaths = collectionView!.indexPathsForVisibleItems
        for indexPath in indexPaths {
            if let cell = collectionView!.cellForItem(at: indexPath) as? GridCell {
                cell.layer.borderColor = UIColor.black.cgColor
            }
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
            gridCell.layer.borderColor = UIColor.black.cgColor
            return gridCell
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("Selected \(indexPath.description)")
        //print(collectionView.frame)
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? GridCell {
            if(selectedCell.layer.borderColor == UIColor.magenta.cgColor) {
                selectedCell.layer.borderColor = UIColor.black.cgColor
            } else {
                selectedCell.layer.borderColor = UIColor.magenta.cgColor
            }
            
            // Set the background color of the picker cells to indicate invalid choices
            var validChoices = gameState!.getValidChoicesFromCell(index: indexPath.row)
            validChoices = validChoices.map { $0 - 1} //Convert items from 1...9 to 0...8; Numbers to cellIndices
            pickerUIDelegate?.setSelectableCells(for: validChoices)
            pickerUIDelegate?.setSelectedBoardCell(at: indexPath.row)
           
            // Move the picker to the correct spot and show it if necessary
            if(gameState?.gameBoard.permanents[indexPath.row] == nil) {
                var newCenter = CGPoint(x : selectedCell.center.x * customZoomScale, y : selectedCell.center.y * customZoomScale)
                newCenter.y -= 150
                pickerUIDelegate?.repositionPicker(center: newCenter)
            } else {
                // Hide the picker if we select a permanent or a filled cell
                pickerUIDelegate?.hidePicker()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? GridCell {
            selectedCell.layer.borderColor = UIColor.black.cgColor
        }
    }
}

extension BoardViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = 326.0
        let widthPerItem = CGFloat((availableWidth / 9.0))
        return CGSize(width : floor(widthPerItem), height : floor(widthPerItem))
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


extension BoardViewController : UINavigationControllerDelegate {
    
}

