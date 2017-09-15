//
//  GridViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-15.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

class GridViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for x in 0..<9 {
            for y in 0..<9 {
                let gridCell = UILabel()
                gridCell.text = "\(x * 9 + y)"
                view.addSubview(gridCell)
                gridCell.translatesAutoresizingMaskIntoConstraints = false
                gridCell.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
                gridCell.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: CGFloat(x * 50)).isActive = true
                gridCell.backgroundColor = .red
                gridCell.setNeedsUpdateConstraints()
            }
        }
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
