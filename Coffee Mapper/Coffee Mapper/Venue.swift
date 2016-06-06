//
//  Venue.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/14/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import RealmSwift
import MapKit

class Venue: Object
{
    dynamic var id: String = ""
    dynamic var name: String = ""
    
    dynamic var latitude: Float = 0
    dynamic var longitude: Float = 0
    
    dynamic var address: String = ""
    
    var coordinate: CLLocation
    {
        return CLLocation(latitude: Double(latitude), longitude:  Double(longitude))
    }
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
}