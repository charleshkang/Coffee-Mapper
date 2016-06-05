//
//  DataService.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/13/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import Foundation
import Firebase

class DataService
{
    static let dataService = DataService()
    var venue = Venue()
    
    var FB_BASE_REF = Firebase(url: "\(BASE_URL)")
    var FB_USER_REF = Firebase(url: "\(BASE_URL)/users")
    var FB_REVIEW_REF = Firebase(url: "\(BASE_URL)/reviews")
    //    var FB_FOURSQUAREID_REF = Firebase(url: "\(BASE_URL)/reviews")
    
    //    private var _COFFEESHOP_REF = Firebase(url: "\(BASE_URL)/coffee-shops")
    
    var BASE_REF: Firebase {
        return FB_BASE_REF
    }
    
    var USER_REF: Firebase {
        return FB_USER_REF
    }
    
    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        return currentUser
    }
    
    var REVIEW_REF: Firebase {
        return FB_REVIEW_REF
    }
    
    
    //    var COFFEESHOP_REF: Firebase {
    //        return _COFFEESHOP_REF
    //    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>)
    {
        USER_REF.childByAppendingPath(uid).setValue(user)
    }
    
    func createNewReview(review: Dictionary<String, AnyObject>)
    {
        let firebaseNewReview = REVIEW_REF.childByAutoId()
        firebaseNewReview.setValue(review)
    }
    
    func addNewCoffeeShopID(review: AnyObject)
    {
        let coffeeKey = review.allKeys.first
        // make a function to search if current coffeeshop exist in FB
        let newCoffeeShop = FB_REVIEW_REF
        isCoffeeShopExist("\(coffeeKey)") { (doesExist) in
            
            if doesExist {
                newCoffeeShop.childByAppendingPath("\(coffeeKey)").childByAutoId()
                let reviewContent = review.objectForKey("\(coffeeKey)")
                newCoffeeShop.setValue(reviewContent)
            } else {
                newCoffeeShop.setValue(review)
            }
        }
    }
    
    func isCoffeeShopExist(shopID: String, completion: (doesExist: Bool) -> ()) {
        let queryCS = FB_REVIEW_REF
        queryCS.childByAppendingPath("\(shopID)")
        queryCS.observeEventType(FEventType.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                completion(doesExist: false)
            } else {
                completion(doesExist: true)
            }
        })
    }
    
    //    func addNewCoffeeShop(coffeeShop: Dictionary<String, AnyObject>) {
    //        let firebaseNewCoffeeShop = COFFEESHOP_REF.childByAutoId()
    //        firebaseNewCoffeeShop.setValue(coffeeShop)
    //    }
}

//struct ReviewItem
//{
//    let name: String!
//    let ref: Firebase?
//    var completed: Bool!
//
//    init(name: String, completed: Bool) {
//        self.name = name
//        self.completed = completed
//        self.ref = nil
//    }
//
//    init(snapshot: FDataSnapshot) {
//        name = snapshot.value["name"] as! String
//        completed = snapshot.value["completed"] as! Bool
//        ref = snapshot.ref
//    }
//
//    func toAnyObject() -> AnyObject {
//        return [
//            "name" : name,
//            "completed" : completed
//        ]
//    }
//}