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
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.minimumZoomScale = 0.5
        self.collectionView?.maximumZoomScale = 3.0
        
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //return board?.totalItems ?? 0
        return 81
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        //let cell = GridCell(frame : view.frame)
        if let gridCell = cell as? GridCell {
            gridCell.label.text = "\(arc4random_uniform(9) + 1)"
            return gridCell
        }
        // Configure the cell
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        print("doing viewWillLayoutSubviews in boardController")
        super.viewWillLayoutSubviews()
    }
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension BoardViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (9 + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = CGFloat(availableWidth / 9.0)
        
        return CGSize(width : widthPerItem, height : widthPerItem)
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
