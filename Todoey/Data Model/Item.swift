//
//  Item.swift
//  Todoey
//
//  Created by Gayan Thilakarathna on 05/01/2018.
//  Copyright © 2018 Gayan Thilakarathna. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    // Define backward relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
