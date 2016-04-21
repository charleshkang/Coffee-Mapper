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
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var _REVIEW_REF = Firebase(url: "\(BASE_URL)/reviews")
    private var _COFFEESHOPNAME_REF = Firebase(url: "\(BASE_URL)/reviews/shopName")
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var USER_REF: Firebase {
        return _USER_REF
    }
    
    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        return currentUser!
    }
    
    var REVIEW_REF: Firebase {
        return _REVIEW_REF
    }
    
    var COFFEESHOPNAME_REF: Firebase {
        return _COFFEESHOPNAME_REF
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        USER_REF.childByAppendingPath(uid).setValue(user)
    }
    
    func createNewReview(review: Dictionary<String, AnyObject>) {
        let firebaseNewReview = REVIEW_REF.childByAutoId()
        firebaseNewReview.setValue(review)
    }
    
    func nameOfCoffeeShop(shopName: Dictionary<String, AnyObject>) {
        let firebaseShopName = COFFEESHOPNAME_REF.childByAutoId()
        firebaseShopName.setValue(shopName)
    }
}

struct ReviewItem
{
    let name: String!
    let ref: Firebase?
    var completed: Bool!
    
    init(name: String, completed: Bool) {
        self.name = name
        self.completed = completed
        self.ref = nil
    }
    
    init(snapshot: FDataSnapshot) {
        name = snapshot.value["name"] as! String
        completed = snapshot.value["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "name" : name,
            "completed" : completed
        ]
    }
}

struct CoffeeShopItem
{
    let shopName: String!
    let ref: Firebase?
    var completed: Bool
    
    init(shopName: String, completed: Bool) {
        self.shopName = shopName
        self.completed = completed
        self.ref = nil
    }
    
    init(snapshot: FDataSnapshot) {
        shopName = snapshot.value["shopName"] as! String
        completed = snapshot.value["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "shopName": shopName,
            "completed": completed
        ]
    }
}

