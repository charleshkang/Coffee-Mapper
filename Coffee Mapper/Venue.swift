//
//  Venue.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/14/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import MapKit
import RealmSwift

class Venue: Object {
    
    // Dynamic Properties
    dynamic var id = ""
    dynamic var name = ""
    dynamic var latitude: Float = 0
    dynamic var longitude: Float = 0
    dynamic var address: String = ""
    
    var coordinate: CLLocation {
        return CLLocation(latitude: Double(latitude), longitude:  Double(longitude))
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
