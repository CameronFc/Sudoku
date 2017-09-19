//
//  GridViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-15.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

final class GridViewController: UIViewController {
    
    var gridView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView = UICollectionView(frame: view.frame)

        // Do any additional setup after loading the view.
        
        var cellContainers = [UIView]()
        
        for _ in 0..<9 {
            for _ in 0..<9 {
                let gridLabel = UILabel()
                let cellContainer = UIView()
                cellContainer.addSubview(gridLabel)
                
                // MARK: Constraints
                NSLayoutConstraint.activate([
                    gridLabel.leadingAnchor.constraint(equalTo: cellContainer.leadingAnchor),
                    gridLabel.topAnchor.constraint(equalTo: cellContainer.topAnchor)
                    ])
                gridLabel.translatesAutoresizingMaskIntoConstraints = false
                gridLabel.setNeedsUpdateConstraints()
                
                gridLabel.text = ""//"\(y * 9 + x)"
                gridLabel.backgroundColor = .red
                
                cellContainers.append(cellContainer)
            }
        }
        
        //gridView = GridView<UIView>(frame: view.frame, cells: cellContainers, numCells: (9,9), options: [])
        view.addSubview(gridView!)
        
        view.setNeedsUpdateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

