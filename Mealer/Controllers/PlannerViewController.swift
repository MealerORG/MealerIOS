//
//  PlannerViewController.swift
//  Mealer
//
//  Created by Nelson Gou on 7/13/22.
//

import UIKit
import RealmSwift
import SwipeCellKit

class PlannerViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var day = Day()
    let nilRecipe = "[NOT SET]"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDay(date: Date())
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabBarVC = tabBarController as! TabBarViewController
        tabBarVC.setNavBarTitle(title: "Planner")
        tabBarVC.navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: - Get Day Object from Realm
    
    func getDayString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "y M d"
        return formatter.string(from: date)
    }
    
    func getDay(date: Date) {
        if let dayObject = realm.object(ofType: Day.self, forPrimaryKey: getDayString(date: date)) {
            day = dayObject
        } else {
            day = Day(date: date)
            
            do {
                try realm.write {
                    realm.add(day)
                }
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        getDay(date: sender.date)
        tableView.reloadData()
    }
}

// MARK: - Table View Data Source Methods

extension PlannerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func getRecipe(section: Int) -> Recipe? {
        switch section {
        case 0:
            return day.breakfast
        case 1:
            return day.lunch
        case 2:
            return day.dinner
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        var config = cell.defaultContentConfiguration()
        config.text = getRecipe(section: indexPath.section)?.name ?? nilRecipe
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let names = ["BREAKFAST", "LUNCH", "DINNER"]
        return names[section]
    }
}

// MARK: - Table View Delegate Methods

extension PlannerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if getRecipe(section: indexPath.section) != nil {
            performSegue(withIdentifier: "plannerToDish", sender: self)
        } else {
            // edit
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dishVC = segue.destination as! DishViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
            dishVC.recipe = getRecipe(section: indexPath.section)!
            dishVC.sender = self
        }
    }
}

// MARK: - Swipe Table View Cell Delegate

extension PlannerViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            // edit
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(systemName: "pencil")
        deleteAction.backgroundColor = UIColor(named: "DarkBlue")

        return [deleteAction]
    }
}
