//
//  TabBarViewController.swift
//  Mealer
//
//  Created by Nelson Gou on 7/24/22.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
    }
    
    func setNavBarTitle(title: String) {
        navigationItem.title = title
    }
}
