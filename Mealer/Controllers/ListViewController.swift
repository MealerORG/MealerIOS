//
//  ListViewController.swift
//  Mealer
//
//  Created by Nelson Gou on 7/24/22.
//

import UIKit

struct Ingredient {
    var name: String = ""
    var quantity: Int = 0
    var category: String? = ""
}

class ListViewController: UITableViewController {
    let categories = ["Bread", "Dairy", "Dried Goods", "Meat & Fish", "Snacks", "Vegetables & Fruit", "Uncategorized"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        // tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabBarVC = tabBarController as! TabBarViewController
        tabBarVC.setNavBarTitle(title: "Shopping List")
    }
}
