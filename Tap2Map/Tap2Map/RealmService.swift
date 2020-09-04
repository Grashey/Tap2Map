//
//  RealmService.swift
//  Tap2Map
//
//  Created by Aleksandr Fetisov on 03.09.2020.
//  Copyright © 2020 Aleksandr Fetisov. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMaps

class RealmService {
    
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    static func saveData<T: Object>(object: T,
        configuration: Realm.Configuration = deleteIfMigration,
        update: Realm.UpdatePolicy = .all) throws {
            let realm = try Realm(configuration: configuration)
            try realm.write {
                realm.deleteAll()
                realm.add(object, update: update)
            }
        print(configuration.fileURL ?? "")
    }
        
    static func getData<T: Object>(type: T.Type,
        configuration: Realm.Configuration = deleteIfMigration) throws -> Results<T> {
            let realm = try Realm(configuration: configuration)
            return realm.objects(type)
    }
}
