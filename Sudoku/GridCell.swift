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
    
    var leftBorder : UIView!
    var rightBorder : UIView!
    var topBorder : UIView!
    var bottomBorder : UIView!
    
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.setNeedsUpdateConstraints()
        label.textAlignment = .center
        self.layer.borderWidth = 1.0
        backgroundColor = AppColors.shouldNotBeSeen
        
        leftBorder = UIView()
        rightBorder = UIView()
        topBorder = UIView()
        bottomBorder = UIView()
        leftBorder.backgroundColor = AppColors.cellBorder
        rightBorder.backgroundColor = AppColors.cellBorder
        topBorder.backgroundColor = AppColors.cellBorder
        bottomBorder.backgroundColor = AppColors.cellBorder
        self.addSubview(leftBorder)
        self.addSubview(rightBorder)
        self.addSubview(topBorder)
        self.addSubview(bottomBorder)
    }
}




