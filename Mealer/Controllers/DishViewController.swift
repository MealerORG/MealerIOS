//
//  DishChangeViewController.swift
//  Mealer
//
//  Created by Nelson Gou on 7/25/22.
//

import UIKit
import RealmSwift

class DishViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ingredientsTable: UITableView!
    
    let realm = try! Realm()
    var recipe: Recipe?
    var sender: UIViewController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        
        ingredientsTable.dataSource = self
        ingredientsTable.register(UINib(nibName: "IngredientTableViewCell", bundle: nil), forCellReuseIdentifier: "DishChangeIngredientCell")
        
        // if recipe == nil, then trying to add a new recipe, so create one
        // otherwise, fill in with given recipe attributes
        if recipe == nil {
            recipe = Recipe()
            
            do {
                try realm.write {
                    realm.add(recipe!)
                }
            } catch {
                print(error)
            }
        } else {
            nameField.text = recipe?.name
        }
    }
    
    // MARK: - Add Ingredients
    
    @IBAction func addIngredient(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Ingredient", message: nil, preferredStyle: .alert)
        
        var ingredientField = UITextField()
        alert.addTextField { field in
            ingredientField = field
            field.placeholder = "Enter ingredient name"
        }
        
        var quantityField = UITextField()
        alert.addTextField() { field in
            quantityField = field
            field.placeholder = "Enter ingredient quantity"
            field.keyboardType = .numberPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            do {
                try self.realm.write {
                    self.recipe?.ingredients.append(ingredientField.text ?? "")
                    self.recipe?.quantities.append(Int(quantityField.text ?? "") ?? 0)
                }
            } catch {
                print(error)
            }
            
            self.ingredientsTable.reloadData()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Save New Recipe
    
    @IBAction func submitPressed(_ sender: UIButton) {
        dismiss(animated: true) {
            let recipesVC = self.sender as! RecipesViewController
            recipesVC.loadRecipes()
        }
    }
}

// MARK: - Table View Data Source Methods

extension DishViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTable.dequeueReusableCell(withIdentifier: "DishChangeIngredientCell", for: indexPath) as! IngredientTableViewCell
        
        cell.ingredient.text = recipe?.ingredients[indexPath.row]
        cell.quantity.text = "\(recipe?.quantities[indexPath.row] ?? 0)"
        
        return cell
    }
}

extension DishViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        do {
            try realm.write {
                recipe?.name = textField.text ?? ""
            }
        } catch {
            print(error)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
