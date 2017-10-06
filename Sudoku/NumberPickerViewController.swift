//
//  NumberPickerViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-21.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "NumberCell"
fileprivate let sectionInsets = UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)

class NumberPickerViewController: UICollectionViewController {
    
    var gameStateDelegate : GameState!
    
    init(delegate : GameState) {
        let numberPickerLayout = UICollectionViewFlowLayout()
        gameStateDelegate = delegate
        super.init(collectionViewLayout: numberPickerLayout)
    }
    
    var selectedBoardCell = 0
    
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not yet implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(GridCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.reloadData()
        
        collectionView?.layer.borderWidth = 1.0
        collectionView?.layer.cornerRadius = 2.0
        
        collectionView!.backgroundColor = .orange
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Number picker view is going to appear.")
        super.viewWillAppear(animated)
    }
    

}

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
            gridCell.backgroundColor = .gray
            gridCell.layer.cornerRadius = 3.0
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let validChoices = gameStateDelegate.getValidChoicesFromCell(index : selectedBoardCell)
        let chosenNumber = indexPath.row + 1
        if(!validChoices.contains(chosenNumber)) {
            return // Don't do anything if the number chosen from the picker is invalid
        }
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? GridCell {
            if(selectedCell.backgroundColor == UIColor.magenta) {
                selectedCell.backgroundColor = UIColor.white
            } else {
                selectedCell.backgroundColor = UIColor.magenta
            }
            // Choosing the same number removes it
            if(chosenNumber == gameStateDelegate.gameBoard.boardArray[selectedBoardCell]) {
                gameStateDelegate.changeCellNumber(at: selectedBoardCell, value: nil)
            } else {
                gameStateDelegate.changeCellNumber(at: selectedBoardCell, value: chosenNumber)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? GridCell {
            selectedCell.layer.borderColor = UIColor.black.cgColor
        }
    }
}

extension NumberPickerViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width - 2
        let widthPerItem = CGFloat((availableWidth / 3.0))
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

extension NumberPickerViewController {
    
    func setCellBackground(at index : Int, color : UIColor) {
        // cellForItemAt does not like to play nice with custom indexPaths.. so hack instead!
        let indexPaths = (collectionView?.indexPathsForVisibleItems)!
        for indexPath in indexPaths {
            if indexPath.row != index {
                continue
            }
            if let pickerCell = collectionView?.cellForItem(at: indexPath){
                pickerCell.backgroundColor = color
            } else {
                print("COULD NOT GET CELL TO CHANGE COLOR.")
            }
        }
    }
    
    func setAllCellBackgrounds(color : UIColor) {
        for cell in collectionView!.visibleCells {
            if let pickerCell = cell as? GridCell {
                pickerCell.backgroundColor = color
            }
        }
    }
}





