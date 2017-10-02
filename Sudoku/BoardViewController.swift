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
    
    var board : Board?
    
    var superScrollView : UIView?
    
    var gameController : GameController?
    
    var numberPickerView : UIView?
    
    // Gives us access to scrollView's zoom scale
    public var customZoomScale : CGFloat = 1.0
    
    init(numberPickerView : UIView) {
        self.numberPickerView = numberPickerView
        let viewLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: viewLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameController = GameController()
        gameController?.gameBoard = gameController?.generateUnsolvedBoard(difficulty: .normal)
        
        collectionView?.allowsMultipleSelection = false
        
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        /*
        NSLayoutConstraint.activate([
            (collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor))!,
            (collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor))!,
            (collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor))!,
            (collectionView?.topAnchor.constraint(equalTo: view.topAnchor))!
            ])
        */
        collectionView?.layer.borderWidth = 1.0
        collectionView?.layer.cornerRadius = 2.0
        
        
        board = Board(size: 9)
        collectionView?.backgroundColor = .green

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return board?.totalItems ?? 0
        return 81
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let gridCell = cell as? GridCell {
            let cellText = (gameController?.gameBoard?.boardArray[indexPath.row])?.description ?? " "
            gridCell.label.text = cellText
            gridCell.label.font = UIFont(name: "Helvetica-Bold", size: 18)
            return gridCell
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected \(indexPath.description)")
        print(collectionView.frame)
        // Hack back the picker
        numberPickerView?.isHidden = false
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? GridCell {
            if(selectedCell.layer.borderColor == UIColor.magenta.cgColor) {
                selectedCell.layer.borderColor = UIColor.black.cgColor
            } else {
                selectedCell.layer.borderColor = UIColor.magenta.cgColor
            }
            numberPickerView?.center.x = selectedCell.center.x * customZoomScale
            numberPickerView?.center.y = selectedCell.center.y * customZoomScale
            numberPickerView?.center.y -= 150
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
        
        //let paddingSpace = 0.0 //sectionInsets.left * (9 + 1)
        let availableWidth = view.frame.width //- paddingSpace
        let widthPerItem = CGFloat((availableWidth / 9.0))
        //print(indexPath.row)
        
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
