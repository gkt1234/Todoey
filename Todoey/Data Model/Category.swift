//
//  Category.swift
//  Todoey
//
//  Created by Gayan Thilakarathna on 05/01/2018.
//  Copyright © 2018 Gayan Thilakarathna. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    // Forward relationship
    let items = List<Item>()
}
