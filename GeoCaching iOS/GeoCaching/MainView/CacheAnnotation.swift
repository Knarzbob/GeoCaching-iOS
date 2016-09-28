//
//  CacheAnnotation.swift
//  GeoCaching
//
//  Created by Daniel Kasper on 01.08.16.
//  Copyright © 2016 MS Projekt. All rights reserved.
//

import Foundation
import Mapbox

class CacheAnnotation: MGLAnnotationView, MGLAnnotation {
    
    var myCoordinate: CLLocationCoordinate2D!
    var myTitle: String?
    var mySubtitle: String?
    var cache: Cache!
    
    internal var coordinate: CLLocationCoordinate2D {
        get {
            return self.myCoordinate
        }
    }
    
    internal var title: String? {
        get {
            return self.myTitle
        }
    }
    
    internal var subtitle: String? {
        get {
            return self.mySubtitle
        }
    }
}
