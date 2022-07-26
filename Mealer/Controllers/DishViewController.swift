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
    @IBOutlet weak var tableView: UITableView!
    
    var recipe: Recipe?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = recipe?.name
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "IngredientTableViewCell", bundle: nil), forCellReuseIdentifier: "DishIngredientCell")
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table View Data Source Methods

extension DishViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishIngredientCell", for: indexPath) as! IngredientTableViewCell
                
        cell.ingredient.text = recipe?.ingredients[indexPath.row]
        cell.quantity.text = "\(recipe?.quantities[indexPath.row] ?? 0)"
        
        return cell
    }
}
