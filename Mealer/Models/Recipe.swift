//
//  Recipe.swift
//  Mealer
//
//  Created by Nelson Gou on 7/24/22.
//

import Foundation
import RealmSwift

class Recipe: Object {
    @objc dynamic var name: String = ""
    var ingredients = List<String>()
    var quantities = List<Int>()
    
    convenience init(name: String) {
        self.init()
        
        self.name = name
    }
}
