//
//  Reviews.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/15/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import Foundation
import Firebase

class Reviews
{
    var _reviewRef: Firebase!
    
    private var _reviewKey: String!
    private var _reviewText: String!
    private var _username: String!
    private var _reviewRating: Float!
    private var _coffeeShopName: String!
    
    var reviewKey: String
    {
        return _reviewKey
    }
    
    var reviewText: String
    {
        return _reviewText
    }
    
    var username: String
    {
        return _username
    }
    
    var rating: Float
    {
        return _reviewRating
    }
    
    var coffeeShopName: String
    {
        return _coffeeShopName
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>)
    {
        self._reviewKey = key
        
        if let rating = dictionary["reviewRating"] as? Float {
            self._reviewRating = rating
        }
        
        if let shopName = dictionary["reviewShopName"] as? String {
            self._coffeeShopName = shopName
        }
        
        if let review = dictionary["reviewText"] as? String {
            self._reviewText = review
        }
        
        if let user = dictionary["reviewAuthor"] as? String {
            self._username = user
        } else {
            self._username = ""
        }
        
        self._reviewRef = DataService.dataService.REVIEW_REF.childByAppendingPath(self._reviewKey)
    }
}