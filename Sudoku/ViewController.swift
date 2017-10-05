//
//  ViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-14.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    var boardView : UIView!
    
    // The controller we talk to that handles all the business of the app
    var gameStateDelegate : GameState!
    
    var boardCollectionView : UICollectionView!
    
    var scrollView : UIScrollView!
    
    var numberPickerView : UIView!
    
    var boardViewController : BoardViewController?
    
    var navControllerDelegate : UINavigationController?
    
    var pickerUIController : PickerUIController?
    
    var victoryViewController : VictoryViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        
        let numberPickerViewController = NumberPickerViewController(delegate : gameStateDelegate)
        numberPickerView = numberPickerViewController.view!
        pickerUIController = PickerUIController(numberPickerDelegate: numberPickerViewController)
        let numberPickerBorderWidth = 1.0
        let numberPickerCellWidth = 50.0
        let totalPickerWidth = CGFloat(3 * numberPickerCellWidth + 2 * numberPickerBorderWidth)
        numberPickerView.backgroundColor = .magenta
        numberPickerView.layer.cornerRadius = 3.0
        
        //numberPickerView.layer.zPosition = 1 // Always on top
        numberPickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberPickerView.widthAnchor.constraint(equalToConstant: totalPickerWidth),
            numberPickerView.heightAnchor.constraint(equalToConstant: totalPickerWidth),
        ])
        numberPickerView.setNeedsUpdateConstraints()
        numberPickerView.isHidden = true
        
        scrollView = UIScrollView()
        boardViewController = BoardViewController(delegate : gameStateDelegate, pickerUIDelegate : pickerUIController!)
        boardView = boardViewController!.view!
        boardCollectionView = boardViewController!.collectionView!
        view.addSubview(scrollView)
        scrollView.addSubview(boardView)
        scrollView.addSubview(numberPickerView)
        self.addChildViewController(numberPickerViewController)
        numberPickerViewController.didMove(toParentViewController: self)
        
        victoryViewController = VictoryViewController()
        
        boardView.translatesAutoresizingMaskIntoConstraints = false
        let boardCellSize = 36.0
        let borderSize = 1.0
        let totalBoardSize = CGFloat(boardCellSize * 9 + borderSize * 2)
        boardView.widthAnchor.constraint(equalToConstant: totalBoardSize).isActive = true
        boardView.heightAnchor.constraint(equalToConstant: totalBoardSize).isActive = true
        
        boardView.setNeedsUpdateConstraints()
        boardView.backgroundColor = .yellow
       
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        scrollView.setNeedsUpdateConstraints()
        scrollView.backgroundColor = .blue
        
        let containerViewBounds = boardView.bounds
        var scrollViewInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        scrollViewInsets.top = 320.0 //containerViewBounds.size.height
        scrollViewInsets.bottom = 320.0 //containerViewBounds.size.height
        scrollViewInsets.left = containerViewBounds.size.width/2.0
        scrollViewInsets.right = containerViewBounds.size.width/2.0
        scrollView.contentInset = scrollViewInsets
        scrollView.contentOffset = CGPoint(x : 0.0, y : 160 - view.bounds.height / 2)
        scrollView.contentSize = CGSize(width: 320, height : 320)
        
        view.setNeedsUpdateConstraints()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.bouncesZoom = false
        scrollView.delegate = self
        
        // MARK : Animations
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name : kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromBottom
        navControllerDelegate?.view.layer.add(transition, forKey: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        //print("After layoutSubviews in ViewController")
        //print("ViewController's child, UICollectionViewContainer, has frame: \(boardView.frame)'")
        super.viewDidLayoutSubviews()
    }
    
    init(delegate : GameState) {
        self.gameStateDelegate = delegate
        super.init(nibName: nil, bundle: nil)
        gameStateDelegate.delegates.append(self)
    }
    
    // Need to implement this to inject MainController into this file - But we never use this method!
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented.")
    }
}

extension ViewController : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return boardView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //print("We just zoomed!")
        scrollView.setNeedsLayout()
        boardViewController?.customZoomScale = scrollView.zoomScale
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        //print("Wow! Just ended zooming!")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pickerUIController?.hidePicker()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pickerUIController?.hidePicker()
        boardViewController?.deselectAllCells()
    }
}

extension ViewController : GameStateDelegate {
    func gameStateDidChange(finished : Bool) {
        if(finished) {
            if(navControllerDelegate!.viewControllers.contains(victoryViewController!)) {
                navControllerDelegate?.show(victoryViewController!, sender: true)
            } else {
                navControllerDelegate?.pushViewController(victoryViewController!, animated: false)
            }
        }
    }
}
