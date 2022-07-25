//
//  RecipesViewController.swift
//  Mealer
//
//  Created by Nelson Gou on 7/24/22.
//

import UIKit

class RecipesViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabBarVC = tabBarController as! TabBarViewController
        tabBarVC.setNavBarTitle(title: "Recipes")
    }
}
