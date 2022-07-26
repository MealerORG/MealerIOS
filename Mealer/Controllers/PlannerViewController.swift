//
//  PlannerViewController.swift
//  Mealer
//
//  Created by Nelson Gou on 7/13/22.
//

import UIKit

class PlannerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabBarVC = tabBarController as! TabBarViewController
        tabBarVC.setNavBarTitle(title: "Planner")
        tabBarVC.navigationItem.rightBarButtonItem = nil
    }
}
