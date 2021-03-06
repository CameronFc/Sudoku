//
//  BoardViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-18.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

// This ViewController is the visual representation of the sudoku board.
// This file is responsible for laying out cells on the board
// Most methods that interact with the board, or handle touch events, 


import UIKit

final class BoardViewController: UICollectionViewController {
    
    let reuseIdentifier = "GridCell"
    
    var gameState : GameState
    
    var pickerUI : PickerUIController
    
    var boardUI : BoardUIController
    
    init(gameState : GameState, pickerUI : PickerUIController, boardUI : BoardUIController) {
        self.pickerUI = pickerUI
        self.gameState = gameState
        self.boardUI = boardUI
        let viewLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: viewLayout)
        // Subscribe to game state updates
        self.gameState.subscribeToUpdates(subscriber: self)
        self.boardUI.delegate = self
    }
    
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.register(GridCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.reloadData()
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        
        collectionView?.layer.borderWidth = GameConstants.boardViewBorderWidth
        collectionView?.layer.cornerRadius = GameConstants.boardViewCornerRadius
        collectionView?.backgroundColor = AppColors.shouldNotBeSeen
    }
    
    func setupConstraints() {
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
    }
}


extension BoardViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = GameConstants.boardCellSize
        var cellWidth = widthPerItem
        var cellHeight = widthPerItem
        let x = indexPath.row % 9
        let y = indexPath.row / 9
        // Make certain cells bigger to account for thicker borders around regions
        if(x % 3 == 0 || x % 3 == 2) {
            cellWidth += GameConstants.extraCellSize
        }
        if(y % 3 == 0 || y % 3 == 2) {
            cellHeight += GameConstants.extraCellSize
        }
        return CGSize(width : cellWidth, height : cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let k = GameConstants.boardViewBorderWidth
        return UIEdgeInsetsMake(k,k,k,k)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
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
        
        collectionView?.reloadData()
    }
}

