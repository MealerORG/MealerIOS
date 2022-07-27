//
//  DishViewController.swift
//  Mealer
//
//  Created by Nelson Gou on 7/25/22.
//

import UIKit
import RealmSwift
import SwipeCellKit

class DishViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ingredientsTable: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var ingredientAddButton: UIButton!
    
    let realm = try! Realm()
    var recipe: Recipe?
    var sender: UIViewController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        
        ingredientsTable.dataSource = self
        ingredientsTable.delegate = self
        ingredientsTable.register(UINib(nibName: "IngredientTableViewCell", bundle: nil), forCellReuseIdentifier: "DishIngredientCell")
        
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
            nameField.text = recipe!.name
        }
        
        // if coming from planner VC, disable modification abilities
        if let _ = sender as? PlannerViewController {
            deleteButton.isHidden = true
            ingredientAddButton.isHidden = true
            nameField.isEnabled = false
            ingredientsTable.allowsSelection = false
        }
    }
    
    // MARK: - Add Ingredients
    
    func askIngredient(row: Int) {
        let alert = UIAlertController(title: (row < 0 ? "Add Ingredient" : "Edit Ingredient"), message: nil, preferredStyle: .alert)
        
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
            let name = ingredientField.text ?? ""
            let quantity = Int(quantityField.text ?? "") ?? 0
            
            do {
                try self.realm.write {
                    if row < 0 {
                        self.recipe!.ingredients.append(name)
                        self.recipe!.quantities.append(quantity)
                    } else {
                        self.recipe!.ingredients[row] = name
                        self.recipe!.quantities[row] = quantity
                    }
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
    
    @IBAction func addIngredient(_ sender: UIButton) {
        askIngredient(row: -1)
    }
    
    // MARK: - Save New Recipe
    
    @IBAction func donePressed(_ sender: UIButton) {
        dismiss(animated: true) {
            if let recipesVC = self.sender as? RecipesViewController {
                recipesVC.loadRecipes()
            }
        }
    }
    
    // MARK: - Delete Recipes
    
    @IBAction func deletePressed(_ sender: UIButton) {
        do {
            try realm.write {
                realm.delete(recipe!)
            }
        } catch {
            print(error)
        }
                
        dismiss(animated: true) {
            if let recipesVC = self.sender as? RecipesViewController {
                recipesVC.loadRecipes()
            }
        }
    }
}

// MARK: - Table View Data Source Methods

extension DishViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe!.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTable.dequeueReusableCell(withIdentifier: "DishIngredientCell", for: indexPath) as! IngredientTableViewCell
        cell.delegate = self
        
        cell.ingredient.text = recipe!.ingredients[indexPath.row]
        cell.quantity.text = "\(recipe!.quantities[indexPath.row])"
        
        return cell
    }
}

// MARK: - Table View Delegate Methods (Edit Ingredients)

extension DishViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        askIngredient(row: indexPath.row)
    }
}

// MARK: - Text Field Delegate Methods

extension DishViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        do {
            try realm.write {
                recipe!.name = textField.text ?? ""
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

// MARK: - Swipe Table View Cell Delegate Methods (Delete Ingredients)

extension DishViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            do {
                try self.realm.write {
                    self.recipe!.ingredients.remove(at: indexPath.row)
                    self.recipe!.quantities.remove(at: indexPath.row)
                }
            } catch {
                print(error)
            }
        }

        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash.fill")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
