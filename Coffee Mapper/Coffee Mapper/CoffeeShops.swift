//
//  CoffeeShops.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 5/25/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import Foundation
import Firebase

class CoffeeShop {
    private var _coffeeShopRef: Firebase?
    
    private var _coffeeShopKey: String!
    private var _coffeeShopName: String!
    private var _coffeeShopReview: String!
    private var _coffeeShopReviewerName: String!
    private var _coffeeShopRating: String!
    
    var coffeeShopKey: String {
        return _coffeeShopKey
    }
    
    var coffeeShopName: String {
        return _coffeeShopName
    }
    
    var coffeeShopReview: String {
        return _coffeeShopReview
    }
    
    var coffeeShopReviewerName: String {
        return _coffeeShopReviewerName
    }
    
    var coffeeShopRating: String {
        return _coffeeShopRating
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._coffeeShopKey = key
        
        if let coffeeShop = dictionary["coffeeShopName"] as? String {
            self._coffeeShopName = coffeeShop
        }
        
        if let review = dictionary["coffeeShopReview"] as? String {
            self._coffeeShopReview = review
        }
        
        if let reviewerName = dictionary["coffeeShopReviewerName"] as? String {
            self._coffeeShopReviewerName = reviewerName
        } else {
            self._coffeeShopReviewerName = ""
        }
        
        if let rating = dictionary["coffeeShopRating"] as? String {
            self._coffeeShopRating = rating
        }
        
        self._coffeeShopRef = DataService.dataService.COFFEESHOP_REF.childByAppendingPath(self._coffeeShopKey)
    }
}
