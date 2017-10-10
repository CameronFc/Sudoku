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

final class ViewController: UIViewController {
    
    var gameStateDelegate : GameState
    
    var pickerUIDelegate : PickerUIController
    
    var navDelegate : UINavigationController!
    
    var boardViewController : BoardViewController!
    
    var numberPickerViewController : NumberPickerViewController!
    
    var scrollView : PassThroughScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.shouldNotBeSeen
        
        numberPickerViewController = NumberPickerViewController(delegate : gameStateDelegate)
        numberPickerViewController.pickerUIController = pickerUIDelegate
        boardViewController = BoardViewController(delegate : gameStateDelegate, pickerUIDelegate : pickerUIDelegate)
        self.addChildViewController(numberPickerViewController)
        numberPickerViewController.didMove(toParentViewController: self)
        
        self.pickerUIDelegate.numberPickerDelegate = numberPickerViewController
        
        pickerUIDelegate.hidePicker()
        
        setupSubviews()
    }
    
    init(gameStateDelegate : GameState, pickerUIDelegate : PickerUIController) {
        self.gameStateDelegate = gameStateDelegate
        self.pickerUIDelegate = pickerUIDelegate
        super.init(nibName: nil, bundle: nil)
        self.gameStateDelegate.delegates.append(self)
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
        boardViewController.customZoomScale = scrollView.zoomScale
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        pickerUIDelegate.hidePicker()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pickerUIDelegate.hidePicker()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pickerUIDelegate.hidePicker()
        boardViewController.deselectAllCells()
    }
}

extension ViewController : GameStateDelegate {
    
    func gameStateDidChange(finished : Bool) {
        
        if(finished) {
            // MARK : Hack
            let alert = UIAlertController(title: "You Win!", message: "You have completed the game in 0.00s. Congratulations!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navDelegate?.popViewController(animated: true)
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
        
        var scrollViewInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        scrollViewInsets.top = GameConstants.totalBoardSize // Provide more room for picker above
        scrollViewInsets.bottom = GameConstants.totalBoardSize / 2
        scrollViewInsets.left = GameConstants.totalBoardSize / 2
        scrollViewInsets.right = GameConstants.totalBoardSize / 2
        scrollView.contentInset = scrollViewInsets
        scrollView.contentOffset = CGPoint(
            x : -(view.bounds.width - GameConstants.totalBoardSize) / 2,
            y : (GameConstants.totalBoardSize / 2) - view.bounds.height / 2)
        scrollView.contentSize = CGSize(width: GameConstants.totalBoardSize, height : GameConstants.totalBoardSize)
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.bouncesZoom = false
        scrollView.delegate = self
        scrollView.backgroundColor = AppColors.gameBackground
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        let boardView = boardViewController.view!
        let numberPickerView = numberPickerViewController.view!
        
        numberPickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberPickerView.widthAnchor.constraint(equalToConstant: GameConstants.totalPickerWidth),
            numberPickerView.heightAnchor.constraint(equalToConstant: GameConstants.totalPickerWidth),
        ])
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        boardView.translatesAutoresizingMaskIntoConstraints = false
        boardView.widthAnchor.constraint(equalToConstant: GameConstants.totalBoardSize).isActive = true
        boardView.heightAnchor.constraint(equalToConstant: GameConstants.totalBoardSize).isActive = true
    }
    
    // Handles touches outside the board
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        pickerUIDelegate.hidePicker()
        boardViewController.deselectAllCells()
    }
}
