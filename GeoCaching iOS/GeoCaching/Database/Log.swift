//
//  Log.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import Foundation
import RealmSwift

class Log: Object {
    dynamic var id = 0
    dynamic var date: Date? = nil
    dynamic var type = ""
    dynamic var finder = ""
    dynamic var finderId = 0
    dynamic var textIsEncoded = false
    dynamic var text = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
