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
    
    var dumpsterView : UIView!
    
    var scrollView : UIScrollView!
    
    var boardViewController : BoardViewController?
    
    var lastLoaction : CGPoint = CGPoint(x: 0, y: 0)
    
    var scrollViewWidthConstraint : NSLayoutConstraint?
    var scrollViewHeightConstraint : NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //delegate.newGame()
        scale = 1.0
        
        view.backgroundColor = .cyan
        let viewLayout = UICollectionViewFlowLayout()
        //viewLayout.itemSize = CGSize(width: 20, height: 20)
        
        scrollView = UIScrollView()
        boardViewController = BoardViewController(superScrollView : scrollView, collectionViewLayout: viewLayout)
        boardView = boardViewController!.view!
        view.addSubview(scrollView)
        scrollView.addSubview(boardView)
        
        /*
        dumpsterView = UIView()
        scrollView.addSubview(dumpsterView)
        dumpsterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //dumpsterView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            //dumpsterView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            dumpsterView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            dumpsterView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        ])
        dumpsterView.setNeedsLayout()
        dumpsterView.backgroundColor = .brown
        */
        
        boardView.translatesAutoresizingMaskIntoConstraints = false
        // MARK : Constraints
        NSLayoutConstraint.activate([
            boardView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            boardView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            boardView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            boardView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            boardView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            boardView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        boardView.setNeedsUpdateConstraints()
        boardView.backgroundColor = .yellow
       
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: scrollView.heightAnchor), // Make sure the board is always square!
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        scrollViewWidthConstraint = scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -5)
        scrollViewHeightConstraint = scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, constant : -5)
        scrollView.setNeedsUpdateConstraints()
        scrollView.backgroundColor = .blue
        
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
        boardViewController?.collectionView?.reloadData()
        super.viewWillLayoutSubviews()
        if(view.bounds.width < view.bounds.height) {
            scrollViewHeightConstraint!.isActive = false
            scrollViewWidthConstraint!.isActive = true
        } else {
            scrollViewWidthConstraint!.isActive = false
            scrollViewHeightConstraint!.isActive = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        print("After layoutSubviews in ViewController")
        print("ViewController's child, UICollectionViewContainer, has frame: \(boardView.frame)'")
        super.viewDidLayoutSubviews()
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return boardView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        print("")
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("We just zoomed!")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("Wow! Just ended zooming!")
    }
}
