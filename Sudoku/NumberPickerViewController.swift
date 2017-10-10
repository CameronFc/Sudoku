//
//  NumberPickerViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-21.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

fileprivate let sectionInsets = UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)

class NumberPickerViewController: UICollectionViewController {
    
    let reuseIdentifier = "NumberCell"
    
    var gameStateDelegate : GameState
    
    var pickerUIDelegate : PickerUIController
    
    init(gameStateDelegate : GameState, pickerUIDelegate : PickerUIController) {
        let numberPickerLayout = UICollectionViewFlowLayout()
        self.gameStateDelegate = gameStateDelegate
        self.pickerUIDelegate = pickerUIDelegate
        super.init(collectionViewLayout: numberPickerLayout)
        
        self.pickerUIDelegate.delegate = self
    }
    
    
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not yet implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(GridCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.reloadData()
        setupSubviews()
    }
    
    func setupSubviews() {
        
        collectionView?.layer.borderWidth = 1.0
        collectionView?.layer.cornerRadius = 2.0
        
        // Needs to be same color as cell border
        collectionView!.backgroundColor = AppColors.cellBorder
        
        view.backgroundColor = AppColors.shouldNotBeSeen
        view.layer.cornerRadius = 3.0
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
                print("Could not change cell background color.")
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
