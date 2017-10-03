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
    
    var gameStateDelegate : GameControllerDelegate!
    
    init(delegate : GameControllerDelegate) {
        let numberPickerLayout = UICollectionViewFlowLayout()
        gameStateDelegate = delegate
        super.init(collectionViewLayout: numberPickerLayout)
    }
    
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
    
    /*
     MARK : RANTING
     Use grid cells
     Has a total width of ~ 3 * 36
     Same kind of spacing as the board, 1 section 9 rows
     Also has same border - 1 px. Rounder corners.
     This controller does not control where the numberPicker is drawn.
     This controller is responsible for making sure that picker is drawn correctly within its own bounds.
     This controller is responsible for handling the tap event that lets the user add a number to the board.
     This controller is responsible for making certain numbers greyed out.
     Probably going to need a delegateProtocol to handle some of the board interactions - like looking up what numbers can be entered.
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: UICollectionViewDataSource
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
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? GridCell {
            if(selectedCell.layer.borderColor == UIColor.magenta.cgColor) {
                selectedCell.layer.borderColor = UIColor.black.cgColor
            } else {
                selectedCell.layer.borderColor = UIColor.magenta.cgColor
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
        //let paddingSpace = 0.0 //sectionInsets.left * (9 + 1)
        let availableWidth = view.frame.width - 2 //- paddingSpace
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





