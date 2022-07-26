//
//  DishViewController.swift
//  Mealer
//
//  Created by Nelson Gou on 7/24/22.
//

import UIKit
import RealmSwift

class DishViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    
    var recipe: Recipe?
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        name.text = recipe?.name
        // print(recipe?.ingredients)
        // print(recipe?.quantities)
    }
}
