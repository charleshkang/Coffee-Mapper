//
//  CMFoursquareAPI.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/14/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import Foundation
import QuadratTouch
import RealmSwift
import MapKit

// 4bf58dd8d48988d1e0931735 is the id for coffee shops

struct API
{
    struct notifications {
        static let venuesUpdated = "Venues Updated"
    }
}

class FoursquareAPI
{
    static let sharedInstance = FoursquareAPI()
    var session:Session?
    
    init()
    {
        let client = Client(clientID: "GZF0DUGNJD2E5MOK2ISNLWHNOX1KDFNCMQYQ32KE0OB1TZSM", clientSecret: "NWECKYIBJGUGQOS5ZLUMCJ1DPTC43YF3UGMIFPLREG20WY0C", redirectURL: "")
        let config = Configuration(client: client)
        Session.setupSharedSessionWithConfiguration(config)
        
        self.session = Session.sharedSession()
        
    }
    
    func getCoffeeShopsWithLocation(location:CLLocation)
    {
        if let session = self.session
        {
            var parameters = location.parameters()
            parameters += [Parameter.categoryId: "4bf58dd8d48988d1e0931735"]
            parameters += [Parameter.radius: "2000"]
            parameters += [Parameter.limit: "50"]
            parameters += [Parameter.venuePhotos: "2"]
            
            let searchTask = session.venues.search(parameters)
            {
                (result) -> Void in
                
                if let response = result.response
                {
                    if let venues = response["venues"] as? [[String: AnyObject]]
                    {
                        autoreleasepool
                            {
                                let realm = try! Realm()
                                realm.beginWrite()
                                
                                for venue:[String:AnyObject] in venues
                                {
                                    let venueObject:Venue = Venue()
                                    if let id = venue["id"] as? String
                                    {
                                        venueObject.id = id
                                    }
                                    if let name = venue["name"] as? String
                                    {
                                        venueObject.name = name
                                    }
                                    if let location = venue["location"] as? [String: AnyObject]
                                    {
                                        if let longitude = location["lng"] as? Float
                                        {
                                            venueObject.longitude = longitude
                                        }
                                        if let latitude = location["lat"] as? Float
                                        {
                                            venueObject.latitude = latitude
                                        }
                                        if let formattedAddress = location["formattedAddress"] as? [String]
                                        {
                                            venueObject.address = formattedAddress.joinWithSeparator(" ")
                                        }
                                    }
                                    realm.add(venueObject, update: true)
                                }
                                do {
                                    try realm.commitWrite()
                                    print("Committing write...")
                                }
                                catch (let error)
                                {
                                    print("Realm isn't working \(error)")
                                }
                        }
                        NSNotificationCenter.defaultCenter().postNotificationName(API.notifications.venuesUpdated, object: nil, userInfo: nil)
                    }
//                    print(response)
                }
            }
            searchTask.start()
        }
    }
}

extension CLLocation
{
    func parameters() -> Parameters
    {
        let ll = "\(self.coordinate.latitude), \(self.coordinate.longitude)"
        let llAcc = "\(self.horizontalAccuracy)"
        let alt = "\(self.altitude)"
        let altAcc = "\(self.verticalAccuracy)"
        
        let parameters = [
            Parameter.ll:ll,
            Parameter.llAcc:llAcc,
            Parameter.alt:alt,
            Parameter.altAcc:altAcc
        ]
        return parameters
    }
}