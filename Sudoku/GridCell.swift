//
//  GridCell.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-15.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

class GridCell: UICollectionViewCell {
    
    var label : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Has not yet been implemented.")
    }
    
    func setupViews() {
        label = UILabel()
        self.addSubview(label)
        //label.text = "Default"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.setNeedsUpdateConstraints()
        label.textAlignment = .center
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 2.0
        backgroundColor = .red
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
