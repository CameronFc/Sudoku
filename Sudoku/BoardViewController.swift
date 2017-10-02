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
        
        self.collectionView?.minimumZoomScale = 1.0
        self.collectionView?.maximumZoomScale = 2.0
        self.collectionView?.bouncesZoom = false
        
        self.collectionView?.removeGestureRecognizer((collectionView?.pinchGestureRecognizer)!)
        
        gameController = GameController()
        gameController?.gameBoard = gameController?.generateUnsolvedBoard(difficulty: .normal)
        
        collectionView?.allowsMultipleSelection = false
        
        //self.collectionView?.pinchGestureRecognizer?.isEnabled = false
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            (collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor))!,
            (collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor))!,
            (collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor))!,
            (collectionView?.topAnchor.constraint(equalTo: view.topAnchor))!
            ])
        
        collectionView?.layer.borderWidth = 1.0
        collectionView?.layer.cornerRadius = 2.0
        
        //collectionView?.isUserInteractionEnabled = false
        
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
            //let gestureRecognizer = UITapGestureRecognizer(target: gridCell, action: #selector(GridCell.tapHandler(recognizer:)))
            //gridCell.addGestureRecognizer(gestureRecognizer)
            //gestureRecognizer.delegate = self
            return gridCell
        }
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected \(indexPath.description)")
        print(collectionView.frame)
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? GridCell {
            if(selectedCell.layer.borderColor == UIColor.magenta.cgColor) {
                selectedCell.layer.borderColor = UIColor.black.cgColor
            } else {
                selectedCell.layer.borderColor = UIColor.magenta.cgColor
            }
            numberPickerView?.center = selectedCell.center
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

// Scrolling
extension BoardViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return view
    }
    
    override func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print(collectionView?.gestureRecognizers?.description ?? "NO")
        print("Just zoomed in the boardController")
    }
   /*
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
 */
}
