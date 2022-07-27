//
//  Day.swift
//  Mealer
//
//  Created by Nelson Gou on 7/26/22.
//

import Foundation
import RealmSwift

class Day: Object {
    @objc dynamic var date: String = ""
    @objc dynamic var breakfast: Recipe?
    @objc dynamic var lunch: Recipe?
    @objc dynamic var dinner: Recipe?
    
    convenience init(date dateObj: Date) {
        self.init()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "y M d"
        date = formatter.string(from: dateObj)
    }
    
    override static func primaryKey() -> String? {
        return "date"
    }
}
