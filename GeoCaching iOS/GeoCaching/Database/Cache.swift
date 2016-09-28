//
//  Cache.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import Foundation
import RealmSwift
import Mapbox

class Cache: Object {
    //Position des Caches
    dynamic var latitude: CLLocationDegrees = 0
    dynamic var longitude: CLLocationDegrees = 0
    
    //Platzierdatum des Caches
    dynamic var time: Date? = nil
    
    //Cache-Code
    dynamic var name = ""
    
    //langer Cache-Name
    dynamic var desc = ""
    
    //kurzer Cache-Name
    dynamic var urlname = ""
    dynamic var groundspeakName = ""
    
    //Cache-ID
    dynamic var id = 0
    
    dynamic var available = false
    
    //Platzierer
    dynamic var placedBy = ""
    dynamic var owner = ""
    dynamic var ownerId = 0
    
    //Cache-Attribute wie "Recommended at night, takes less than an hour"...
    let attributes = List<CacheAttribute>()
    
    //Cache-Type wie z.B. Multi
    dynamic var cacheTypeRaw = ""
    var cacheType: CacheType {
        get {
            if let a = CacheType(rawValue: cacheTypeRaw) {
                return a
            }
            return .UnknownCache
        }
    }
    
    //Schwierigkeitsstufe
    dynamic var difficulty = 0.0
    dynamic var terrain = 0.0
    dynamic var containerRaw = ""
    var container: Container {
        get {
            if let a = Container(rawValue: containerRaw) {
                return a
            }
            return .NotChosen
        }
    }
    
    dynamic var country = ""
    dynamic var state = ""
    
    //Beschreibungen des Caches vom Platzierer
    dynamic var shortDesc = ""
    dynamic var shortDescIsHtml = false
    dynamic var longDesc = ""
    dynamic var longDescIsHtml = false
    dynamic var encodedHints = ""
    
    let logs = List<Log>()
    
    dynamic var isActivated = false
    dynamic var isFound = false
    dynamic var foundDate: Date? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

enum CacheType: String {
    case MultiCache = "Multi-cache"
    case UnknownCache = "Unknown Cache"
    case TraditionalCache = "Traditional Cache"
    case EarthCache = "Earthcache"
    case EventCache = "Event Cache"
}

enum Container: String {
    case Micro = "Micro"
    case Small = "Small"
    case Regular = "Regular"
    case Large = "Large"
    case Other = "Other"
    case NotChosen = "Not chosen"
}
