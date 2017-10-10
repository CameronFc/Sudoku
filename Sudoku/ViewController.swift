//
//  ViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-14.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import UIKit

// MARK : DIRTY HACK
class PassThroughScrollView : UIScrollView {
    
    // Let touch events propagate to children
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        super.touchesBegan(touches, with: event)
    }
}

fileprivate let boardCellSize = 36.0
fileprivate let borderSize = 1.0
fileprivate let extraCellSize = 1.0
fileprivate let totalBoardSize = CGFloat(boardCellSize * 9 + borderSize * 2 + 6 * extraCellSize)
fileprivate let numberPickerBorderWidth = 1.0
fileprivate let numberPickerCellWidth = 50.0
fileprivate let totalPickerWidth = CGFloat(3 * numberPickerCellWidth + 2 * numberPickerBorderWidth)

final class ViewController: UIViewController {
    
    var gameState : GameState!
    
    var scrollView : PassThroughScrollView!
    
    var boardViewController : BoardViewController!
    
    var navController : UINavigationController!
    
    var pickerUIController : PickerUIController!
    
    var numberPickerViewController : NumberPickerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = appColors.shouldNotBeSeen
        
        numberPickerViewController = NumberPickerViewController(delegate : gameState)
        pickerUIController = PickerUIController(numberPickerDelegate: numberPickerViewController)
        numberPickerViewController.pickerUIController = pickerUIController
        boardViewController = BoardViewController(delegate : gameState, pickerUIDelegate : pickerUIController!)
        self.addChildViewController(numberPickerViewController)
        numberPickerViewController.didMove(toParentViewController: self)
        
        pickerUIController.hidePicker()
        
        setupSubviews()
    }
    
    init(delegate : GameState) {
        self.gameState = delegate
        super.init(nibName: nil, bundle: nil)
        gameState.delegates.append(self)
    }
    
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented.")
    }
}

extension ViewController : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return boardViewController.view
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.setNeedsLayout()
        boardViewController?.customZoomScale = scrollView.zoomScale
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        pickerUIController?.hidePicker()
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
            // MARK : Hack
            let alert = UIAlertController(title: "You Win!", message: "You have completed the game in 0.00s. Congratulations!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navController?.popViewController(animated: true)
            })
            present(alert, animated: true)
        }
    }
}

extension ViewController {
    
    func setupSubviews() {
        
        let boardView = boardViewController.view!
        let numberPickerView = numberPickerViewController.view!
        
        scrollView = PassThroughScrollView()
        scrollView.addSubview(boardView)
        view.addSubview(scrollView)
        view.addSubview(numberPickerView)
        
        let containerViewBounds = boardView.bounds
        print(boardView.bounds)
        var scrollViewInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        scrollViewInsets.top = 320.0 //containerViewBounds.size.height
        scrollViewInsets.bottom = 320.0 //containerViewBounds.size.height
        scrollViewInsets.left = containerViewBounds.size.width/2.0
        scrollViewInsets.right = containerViewBounds.size.width/2.0
        scrollView.contentInset = scrollViewInsets
        scrollView.contentOffset = CGPoint(x : 0.0, y : 160 - view.bounds.height / 2)
        scrollView.contentSize = CGSize(width: 320, height : 320)
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.bouncesZoom = false
        scrollView.delegate = self
        scrollView.backgroundColor = appColors.gameBackground
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        let boardView = boardViewController.view!
        let numberPickerView = numberPickerViewController.view!
        
        numberPickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberPickerView.widthAnchor.constraint(equalToConstant: totalPickerWidth),
            numberPickerView.heightAnchor.constraint(equalToConstant: totalPickerWidth),
        ])
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        boardView.translatesAutoresizingMaskIntoConstraints = false
        boardView.widthAnchor.constraint(equalToConstant: totalBoardSize).isActive = true
        boardView.heightAnchor.constraint(equalToConstant: totalBoardSize).isActive = true
    }
    
    // Handles touches outside the board
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        pickerUIController?.hidePicker()
        boardViewController?.deselectAllCells()
    }
}
