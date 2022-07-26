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
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension DishViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishIngredientCell", for: indexPath)
        
        if let ingredients = recipe?.ingredients, let quantities = recipe?.quantities {
            var config = cell.defaultContentConfiguration()
            config.text = "\(ingredients[indexPath.row]) — \(quantities[indexPath.row])"
            cell.contentConfiguration = config
        }
        
        return cell
    }
}
