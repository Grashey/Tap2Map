//
//  User.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 08.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""
    
    override static func primaryKey() -> String? {
         return "login"
     }
}
