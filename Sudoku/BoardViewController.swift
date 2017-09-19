//
//  BoardViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-18.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GridCell"
fileprivate let sectionInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)

final class BoardViewController: UICollectionViewController {
    
    var board : Board?
    fileprivate var scale : CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.minimumZoomScale = 0.5
        self.collectionView?.maximumZoomScale = 2.0
        
        scale = 1.0
        let recognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchGesture(gesture:)))
        collectionView?.addGestureRecognizer(recognizer)
        
        //collectionView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            (collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor))!,
            (collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor))!,
            (collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor))!,
            (collectionView?.topAnchor.constraint(equalTo: view.topAnchor))!
            ])
        
        collectionView?.layer.borderWidth = 3.0
        
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
            gridCell.label.text = "\(arc4random_uniform(9) + 1)"
            return gridCell
        }
        return cell
    }
}

extension BoardViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (9 + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = CGFloat(availableWidth / 9.0)
        
        return CGSize(width : widthPerItem * scale!, height : widthPerItem * scale!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width : 0, height : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width : 0, height : 0)
    }
    
}

// Scrolling
extension BoardViewController {

    /*
 
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return view
    }
    */
    
    override func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.view.setNeedsUpdateConstraints()
    }
    
    func handlePinchGesture(gesture : UIPinchGestureRecognizer) {
        var scaleStart : CGFloat = 1.0
        if(gesture.state == .began) {
            scaleStart = scale!
        } else if (gesture.state == .changed) {
            scale = scaleStart * gesture.scale
            collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
}
