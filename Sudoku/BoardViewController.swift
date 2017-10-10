//
//  BoardViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-18.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

final class BoardViewController: UICollectionViewController {
    
    let reuseIdentifier = "GridCell"
    
    var gameStateDelegate : GameState
    
    var pickerUIDelegate : PickerUIController
    
    var boardUIDelegate : BoardUIController
    
    init(gameStateDelegate : GameState, pickerUIDelegate : PickerUIController, boardUIDelegate : BoardUIController) {
        
        self.pickerUIDelegate = pickerUIDelegate
        self.gameStateDelegate = gameStateDelegate
        self.boardUIDelegate = boardUIDelegate
        let viewLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: viewLayout)
        // Subscribe to game state updates
        self.gameStateDelegate.delegates.append(self)
        self.boardUIDelegate.delegate = self
        
    }
    
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(GridCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.reloadData()
    }
    
    func setupSubviews() {
        
        collectionView?.layer.borderWidth = 1.0
        collectionView?.layer.cornerRadius = 2.0
        collectionView?.backgroundColor = .magenta
        
        setupConstraints()
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
        if(x % 3 == 0 || x % 3 == 2) {
            cellWidth += GameConstants.extraCellSize
        }
        if(y % 3 == 0 || y % 3 == 2) {
            cellHeight += GameConstants.extraCellSize
        }
        return CGSize(width : cellWidth, height : cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)
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

