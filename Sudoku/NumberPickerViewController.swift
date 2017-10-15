//
//  NumberPickerViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-21.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

// This ViewController is what the user sees when they want to enter
// a number onto the board. This file only deals with managing
// the size of cells on the picker.

import UIKit

class NumberPickerViewController: UICollectionViewController {
    
    let reuseIdentifier = "NumberCell"
    
    var gameState : GameState
    
    var pickerUI : PickerUIController
    
    init(gameState : GameState, pickerUI : PickerUIController) {
        let numberPickerLayout = UICollectionViewFlowLayout()
        self.gameState = gameState
        self.pickerUI = pickerUI
        super.init(collectionViewLayout: numberPickerLayout)
        
        self.pickerUI.delegate = self
    }
    
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not yet implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.register(GridCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.reloadData()
        setupSubviews()
    }
    
    func setupSubviews() {
        
        collectionView?.layer.borderWidth = GameConstants.pickerViewBorderWidth
        collectionView?.layer.cornerRadius = GameConstants.pickerViewCornerRadius
        // Needs to be same color as cell border
        collectionView?.backgroundColor = AppColors.cellBorder
        
        view.backgroundColor = AppColors.shouldNotBeSeen
    }
}


extension NumberPickerViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width - 2
        let widthPerItem = CGFloat((availableWidth / 3.0))
        return CGSize(width : floor(widthPerItem), height : floor(widthPerItem))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)
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
