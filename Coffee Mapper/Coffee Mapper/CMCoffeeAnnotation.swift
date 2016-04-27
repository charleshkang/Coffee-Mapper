//
//  CMCoffeeAnnotation.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/14/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import Foundation
import MapKit

class CoffeeAnnotation: NSObject, MKAnnotation
{
    let title:String?
//    let subtitle:String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, coordinate: CLLocationCoordinate2D)
    {
        self.title = title
//        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
}