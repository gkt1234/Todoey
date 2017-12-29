//
//  Item.swift
//  Todoey
//
//  Created by Gayan Thilakarathna on 28/12/2017.
//  Copyright © 2017 Gayan Thilakarathna. All rights reserved.
//

import Foundation

// Codable replaces the Encodable, Decodable
class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
