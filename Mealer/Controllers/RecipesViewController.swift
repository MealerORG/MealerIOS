//
//  RecipesViewController.swift
//  Mealer
//
//  Created by Nelson Gou on 7/24/22.
//

import UIKit
import RealmSwift

class RecipesViewController: UITableViewController {
    let realm = try! Realm()
    var recipes: Results<Recipe>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRecipes()
        
        searchBar.barTintColor = UIColor(named: "DarkBlue")
        searchBar.searchTextField.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabBarVC = tabBarController as! TabBarViewController
        tabBarVC.setNavBarTitle(title: "Recipes")
        tabBarVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecipe))
    }
    
    // MARK: - Load Recipes
    
    func loadRecipes() {
        recipes = realm.objects(Recipe.self).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    // MARK: - Add Recipes
    
    @objc func addRecipe() {
        
    }
    
    // MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        
        // set cell name
        var config = cell.defaultContentConfiguration()
        config.text = recipes?[indexPath.row].name ?? ""
        cell.contentConfiguration = config
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "recipesToDish", sender: self)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DishViewController
    
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
            destinationVC.recipe = recipes?[indexPath.row]
        }
    }
}

// MARK: - SearchBar Delegate Methods

extension RecipesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        recipes = recipes?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadRecipes()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
