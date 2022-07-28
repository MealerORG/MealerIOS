//
//  ListViewController.swift
//  Mealer
//
//  Created by Nelson Gou on 7/24/22.
//

import UIKit
import RealmSwift

class ListViewController: UITableViewController {
    // let categories = ["Bread", "Dairy", "Dried Goods", "Meat & Fish", "Snacks", "Vegetables & Fruit", "Uncategorized"]
    
    let realm = try! Realm()
    var ingredients = [Dictionary<String, Int>.Element]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "IngredientTableViewCell", bundle: nil), forCellReuseIdentifier: "IngredientCell")
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabBarVC = tabBarController as! TabBarViewController
        tabBarVC.setNavBarTitle(title: "Shopping List")
        tabBarVC.navigationItem.rightBarButtonItem = nil
        
        queryIngredients()
        tableView.reloadData()
    }
    
    // MARK: - Realm Day Query
    
    func getDayString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "y M d"
        return formatter.string(from: date)
    }
    
    func queryIngredients() {
        var days = [Day]()
        var date = Date()
        
        // query Days
        for _ in 1...7 {
            if let dayObject = realm.object(ofType: Day.self, forPrimaryKey: getDayString(date: date)) {
                days.append(dayObject)
            }
            
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        
        // query Recipes
        var recipes = [Recipe]()
        
        for day in days {
            if (day.breakfast != nil) {
                recipes.append(day.breakfast!)
            }
            
            if (day.lunch != nil) {
                recipes.append(day.lunch!)
            }
            
            if (day.dinner != nil) {
                recipes.append(day.dinner!)
            }
        }
        
        // query ingredients and quantities
        var ingDict: [String: Int] = [:]
        
        for recipe in recipes {
            for i in 0..<recipe.ingredients.count {
                ingDict.updateValue((ingDict[recipe.ingredients[i]] ?? 0) + recipe.quantities[i], forKey: recipe.ingredients[i])
            }
        }
        
        ingredients = Array(ingDict)
    }
    
    // MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
        
        cell.ingredient.text = ingredients[indexPath.row].key
        cell.quantity.text = "\(ingredients[indexPath.row].value)"
        
        return cell
    }
}
