//
//  MainController.swift
//  Sudoku
//
//  Created by Cameron Francis on 2017-09-15.
//  Copyright © 2017 Cameron Francis. All rights reserved.
//

import Foundation
import UIKit

final class MainController {
    
    let navController : UINavigationController
    
    init() {
        
        let menuViewController = MenuViewController()
        navController = UINavigationController(rootViewController: menuViewController)
        menuViewController.navController = navController
    }
}

