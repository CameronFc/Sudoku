//
//  GridCell.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-15.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

// GridCell is used by both the BoardView and NumberPicker for collection view
// cells. It has methods to decorate the cell with directional borders
// of different attributes.

import UIKit

enum BorderDirection {
    case left
    case top
    case right
    case bottom
}

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
    
    func setBorderWidth(_ direction : BorderDirection, width : CGFloat) {
        switch direction {
        case .left:
            leftBorder?.frame = CGRect(x: 0 , y: 0 , width: width, height: self.frame.height)
        case .top:
            topBorder?.frame = CGRect(x: 0 , y: 0 , width: self.frame.width, height: width)
        case .right:
            rightBorder?.frame = CGRect(x: self.frame.width - width, y: 0 , width: width, height: self.frame.height)
        case .bottom:
            bottomBorder?.frame = CGRect(x: 0 , y: self.frame.height - width , width: self.frame.width, height: width)
        }
    }
}




