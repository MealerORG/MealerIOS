//
//  PlannerViewController.swift
//  Mealer
//
//  Created by Nelson Gou on 7/13/22.
//

import UIKit
import RealmSwift

class PlannerViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var day = Day()
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath)
        
        var config = cell.defaultContentConfiguration()
        
        switch indexPath.section {
        case 0:
            config.text = day.breakfast?.name ?? "[NOT SET]"
        case 1:
            config.text = day.lunch?.name ?? "[NOT SET]"
        case 2:
            config.text = day.dinner?.name ?? "[NOT SET]"
        default:
            print("error: section not found")
        }
        
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "BREAKFAST"
        case 1:
            return "LUNCH"
        case 2:
            return "DINNER"
        default:
            return nil
        }
    }
}

// MARK: - Table View Delegate Methods

extension PlannerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
