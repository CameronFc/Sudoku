//
//  ViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-14.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    fileprivate var scale : CGFloat?
    // The controller we talk to that handles all the business of the app
    let delegate : GameControllerDelegate!
    
    var boardView : UIView!
    
    var scrollView : UIScrollView!
    
    var numberPickerView : UIView!
    
    var boardViewController : BoardViewController?
    
    var lastLoaction : CGPoint = CGPoint(x: 0, y: 0)
    
    var boardViewWidthConstraint : NSLayoutConstraint?
    var boardViewHeightConstraint : NSLayoutConstraint?
    var boardViewCenterXConstraint : NSLayoutConstraint?
    var boardViewCenterYConstraint : NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //delegate.newGame()
        scale = 1.0
        
        view.backgroundColor = .cyan
        //viewLayout.itemSize = CGSize(width: 20, height: 20)
        
        let numberPickerViewController = NumberPickerViewController()
        numberPickerView = numberPickerViewController.view!
        let numberPickerBorderWidth = 1.0
        let numberPickerCellWidth = 70.0//50.0
        let totalPickerWidth = CGFloat(3 * numberPickerCellWidth + 6 * numberPickerBorderWidth)
        numberPickerView.backgroundColor = .magenta
        
        //numberPickerView.layer.zPosition = 1 // Always on top
        numberPickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberPickerView.widthAnchor.constraint(equalToConstant: totalPickerWidth),
            numberPickerView.heightAnchor.constraint(equalToConstant: totalPickerWidth),
        ])
        numberPickerView.setNeedsUpdateConstraints()
        
        scrollView = UIScrollView()
        boardViewController = BoardViewController(numberPickerView : numberPickerView)
        boardView = boardViewController!.view!
        view.addSubview(scrollView)
        scrollView.addSubview(boardView)
        scrollView.addSubview(numberPickerView)
        self.addChildViewController(numberPickerViewController)
        numberPickerViewController.didMove(toParentViewController: self)
        
        //boardView.translatesAutoresizingMaskIntoConstraints = false
        // MARK : Constraints
        
        NSLayoutConstraint.activate([
            //boardView.widthAnchor.constraint(equalTo: boardView.heightAnchor)
            boardView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            boardView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            boardView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            boardView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        
        //boardViewCenterXConstraint = boardView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        //boardViewCenterYConstraint = boardView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        //boardViewCenterXConstraint?.isActive = true
        //boardViewCenterYConstraint?.isActive = true
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
            //scrollView.widthAnchor.constraint(equalTo: scrollView.heightAnchor), // Make sure the board is always square!
            //scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            //scrollView.heightAnchor.constraint(equalTo: view.heightAnchor)
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        //boardViewWidthConstraint = boardView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -5)
        //boardViewHeightConstraint = boardView.heightAnchor.constraint(equalTo: view.heightAnchor, constant : -5)
        scrollView.setNeedsUpdateConstraints()
        scrollView.backgroundColor = .blue
        //scrollView.contentOffset = CGPoint(x : 320, y : 0)
        //scrollView.contentSize = CGSize(width: 320 * 2, height : 320 * 2)
        
        view.setNeedsUpdateConstraints()
        
        //let recognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(gesture:)))
        //recognizer.delegate = self
        //view.addGestureRecognizer(recognizer)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.bouncesZoom = false
        scrollView.delegate = self
        //let panRecogizer = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        //let touchRecognizer = UIGestureRecognizer(target: self, action: #selector(touchHandler))
        //scrollView.addGestureRecognizer(panRecogizer)
        //scrollView.addGestureRecognizer(touchRecognizer)
    }
    
    func touchHandler(recognizer : UIGestureRecognizer) {
        print("Touch handler called!")
        if(recognizer.state == .began) {
            print(boardView.center)
        }
        //lastLoaction = boardView.center
    }
    
    func panHandler(recognizer : UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        boardView.center = CGPoint(x: lastLoaction.x + translation.x, y: lastLoaction.y + translation.y)
        print(boardView.center)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        //boardViewController?.collectionView?.reloadData()
        super.viewWillLayoutSubviews()
        /*
        if(view.bounds.width < view.bounds.height) {
            boardViewHeightConstraint!.isActive = false
            boardViewWidthConstraint!.isActive = true
        } else {
            boardViewWidthConstraint!.isActive = false
            boardViewHeightConstraint!.isActive = true
        }
        */
    }
    
    override func viewDidLayoutSubviews() {
        print("After layoutSubviews in ViewController")
        print("ViewController's child, UICollectionViewContainer, has frame: \(boardView.frame)'")
        super.viewDidLayoutSubviews()
        
        let scrollViewBounds = scrollView.bounds
        let containerViewBounds = boardView.bounds
        
        var scrollViewInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        scrollViewInsets.top = scrollViewBounds.size.height/2.0
        scrollViewInsets.top -= containerViewBounds.size.height/2.0
        
        scrollViewInsets.bottom = scrollViewBounds.size.height/2.0
        scrollViewInsets.bottom -= containerViewBounds.size.height/2.0
        scrollViewInsets.bottom += 1
        
        scrollViewInsets.left = containerViewBounds.size.width/2.0
        scrollViewInsets.right = containerViewBounds.size.width/2.0
        
        scrollView.contentInset = scrollViewInsets
        
    }
    
    init(delegate : GameControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    // Need to implement this to inject MainController into this file - But we never use this method!
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        delegate = nil
        super.init(coder: aDecoder)
    }


}

// MARK : GESTURES
extension ViewController : UIGestureRecognizerDelegate {
    
    func handlePinchGesture(gesture : UIPinchGestureRecognizer) {
        //print("FUQ \(self.scale as Any)")
        var scaleStart : CGFloat = 1.0
        if(gesture.state == .began) {
            scaleStart = scale!
        } else if (gesture.state == .changed) {
            scale = scaleStart * gesture.scale
        } else if (gesture.state == .ended) {
            print("Ended pinch gesture.")
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}

extension ViewController : UIScrollViewDelegate {
    
    func updateConstraintsForSize(_ size: CGSize) {
        //let yOffset = max(0, (size.height - scrollView.frame.height) / 2)
        //boardViewCenterYConstraint?.constant = yOffset
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return boardView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(boardView.bounds.size)
        //print("We just zoomed!")
        scrollView.setNeedsLayout()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        //print("Wow! Just ended zooming!")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //numberPickerView.center = CGPoint(x: 10, y: 20)
        //numberPickerView.layoutSubviews()
    }
}
