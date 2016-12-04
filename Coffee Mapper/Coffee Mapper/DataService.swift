//
//  DataService.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/13/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import Firebase
import Foundation

class DataService {
    
    // Static Properties
    static let dataService = DataService()
    static let venue = Venue()
    
    // Properties
    let FB_BASE_REF = Firebase(url: "\(baseURL)")
    let FB_USER_REF = Firebase(url: "\(baseURL)/users")
    var FB_REVIEW_REF = Firebase(url: "\(baseURL)/reviews")
    
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
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        USER_REF.childByAppendingPath(uid).setValue(user)
    }
    
    func createNewReview(review: Dictionary<String, AnyObject>) {
        let firebaseNewReview = REVIEW_REF.childByAutoId()
        firebaseNewReview.setValue(review)
    }
    
    func addReviewForCoffeeShop(shopId: String, review: AnyObject) {
        FB_REVIEW_REF.childByAppendingPath(shopId).childByAutoId().setValue(review)
    }
}
