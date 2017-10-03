//
//  WinViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-10-03.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

class VictoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
        
        let label = UILabel()
        view.addSubview(label)
        label.text = "UR WINNER!"
        label.font = UIFont(name: "Helvetica", size: 48)
        label.backgroundColor = .red
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        label.setNeedsUpdateConstraints()
        
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
