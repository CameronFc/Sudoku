//
//  ViewController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-14.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

// This ViewController is what the player sees when they are playing
// the game. It manages a scrollview that contains the boardView.
// It also is parent to the NumberPickerViewController.

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
    
    var gameState : GameState
    
    let pickerUI : PickerUIController
    
    let boardUI : BoardUIController
    
    var navController : UINavigationController?
    
    var boardViewController : BoardViewController
    
    var numberPickerViewController : NumberPickerViewController
    
    var scrollView : PassThroughScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        pickerUI.hidePicker(animated : false)
        autoSetUndoButton() 
    }
    
    init(gameState : GameState, pickerUI : PickerUIController, boardUI : BoardUIController) {
        self.gameState = gameState
        self.pickerUI = pickerUI
        self.boardUI = boardUI
        self.boardViewController = BoardViewController(gameState : gameState, pickerUI : pickerUI, boardUI : boardUI)
        self.numberPickerViewController = NumberPickerViewController(gameState : gameState, pickerUI : pickerUI)
        super.init(nibName: nil, bundle: nil)
        
        self.gameState.subscribeToUpdates(subscriber: self)
        
        self.addChildViewController(numberPickerViewController)
        numberPickerViewController.didMove(toParentViewController: self)
    }
    
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented.")
    }
}
//ScrollView zooming and dragging.
extension ViewController : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return boardViewController.view
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.setNeedsLayout()
        boardUI.customZoomScale = scrollView.zoomScale
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        pickerUI.hidePicker(animated : true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pickerUI.hidePicker(animated : true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pickerUI.hidePicker(animated : true)
        boardUI.deselectAllCells()
    }
}
// Touch events
extension ViewController {
    // Handles touches outside the board
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(touches.first?.tapCount == 1) {
            // This is executed if we tap once or more!
            // So this code will also execute during a double-tap
            pickerUI.hidePicker(animated : true)
            boardUI.deselectAllCells()
        }
        if(touches.first?.tapCount == 2) {
            centerBoardView(animated : true)
        }
        
        super.touchesBegan(touches, with: event)
    }
    // Method selected by Undo button
    func undoLastMove() {
        // If there are any moves to undo, get the cell index of that move
        if let index = gameState.undoLastMove() {
            boardUI.deselectAllCells()
            boardUI.selectCell(at: index)
        }
    }
    
    func autoSetUndoButton() {
        // Grayed-out button with no action if there are no moves to undo. Blue otherwise.
        if(gameState.moveStackIsEmpty()) {
            let undoButton = UIBarButtonItem(title: "Undo", style: .plain, target: self, action: nil)
            undoButton.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.gray], for: .normal)
            navController?.topViewController?.navigationItem.rightBarButtonItem = undoButton
        } else {
            let undoButton = UIBarButtonItem(title: "Undo", style: .plain, target: self, action: #selector(undoLastMove))
            undoButton.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.blue], for: .normal)
            navController?.topViewController?.navigationItem.rightBarButtonItem = undoButton
        }
    }
}
// Responding to game state changes
extension ViewController : GameStateDelegate {
    
    func gameStateDidChange(finished : Bool) {
        // Every time the state changes, check if we should enable/disable the undo button
        autoSetUndoButton()
        
        if(finished) {
            let alert = UIAlertController(title: "You Win!", message: "You have completed the game in 0.00s. Congratulations!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navController?.popViewController(animated: true)
            })
            present(alert, animated: true)
        }
    }
}
// Animations
extension ViewController {
    
    func centerBoardView(animated : Bool) {
        // Change contentOffsets to center the board
        let center = CGPoint(
                x : -(view.bounds.width - GameConstants.totalBoardSize) / 2,
                y : (GameConstants.totalBoardSize / 2) - view.bounds.height / 2)
        
        if(animated) {
            UIView.animate(withDuration: 0.20, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.scrollView.setZoomScale(1.0, animated: true)
            }, completion: { (someBoolean) in
                self.scrollView.contentOffset = center
            })
        } else {
            scrollView.contentOffset = center
            scrollView.setZoomScale(1.0, animated: false)
        }
    }
}
// MARK : View setup
extension ViewController {
    
    func setupSubviews() {
        
        let boardView = boardViewController.view!
        let numberPickerView = numberPickerViewController.view!
        
        view.backgroundColor = AppColors.shouldNotBeSeen
        
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
        scrollView.contentSize = CGSize(width: GameConstants.totalBoardSize, height : GameConstants.totalBoardSize)
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.bouncesZoom = false
        scrollView.delegate = self
        scrollView.backgroundColor = AppColors.gameBackground
        
        
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
        
        centerBoardView(animated: false)
        // MARK : Dirty scroll hack. We add +64.0 to the scrollview.bounds/scrollView.contentOffset
        // because the addition of the navigation bar and status bar shift the bounds up 64.0
        // sometime after this method ends.
        scrollView.contentOffset.y += 64.0
    }
}
