//
//  DataService.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/13/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import Foundation
import Firebase


class DataService {
    
    // Static Properties
    static let dataService = DataService()
    static let venue = Venue()
    
    // Properties
    let FB_BASE_REF = FIRDatabase.database().referenceFromURL("\(baseURL)")
    let FB_USER_REF = FIRDatabase.database().referenceFromURL("\(baseURL)/users")
    var FB_REVIEW_REF = FIRDatabase.database().referenceFromURL("\(baseURL)/reviews")
    
    var BASE_REF: FIRDatabaseReference {
        return FB_BASE_REF
    }
    
    var USER_REF: FIRDatabaseReference {
        return FB_USER_REF
    }
    
    var CURRENT_USER_REF: FIRDatabaseReference {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
        let currentUser = FIRDatabase.database().referenceFromURL("\(BASE_REF)").child("users").child(userID!)
        return currentUser
    }
    
    var REVIEW_REF: FIRDatabaseReference {
        return FB_REVIEW_REF
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        USER_REF.child(uid).setValue(user)
    }
    
    func createNewReview(review: Dictionary<String, AnyObject>) {
        let firebaseNewReview = REVIEW_REF.childByAutoId()
        firebaseNewReview.setValue(review)
    }
    
    func addReviewForCoffeeShop(shopId: String, review: AnyObject) {
        FB_REVIEW_REF.child(shopId).childByAutoId().setValue(review)
    }
}
