//
//  Coordinate.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 04.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import Foundation
import RealmSwift

class Coordinate: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    override static func primaryKey() -> String? {
         return "id"
     }
}
