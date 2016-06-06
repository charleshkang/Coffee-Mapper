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
    var reviewRef: Firebase!
    
    var reviewKey: String!
    var reviewText: String!
    var reviewAuthor: String!
    var reviewRating: Float!
    var reviewLocation: String!
    
    var key: String
    {
        return reviewKey
    }
    
    var text: String
    {
        return reviewText
    }
    
    var username: String
    {
        return reviewAuthor
    }
    
    var rating: Float
    {
        return reviewRating
    }
    
    var location: String
    {
        return reviewLocation
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>)
    {
        self.reviewKey = key
        
        if let rating = dictionary["reviewRating"] as? Float {
            self.reviewRating = rating
        }
        
        if let shopName = dictionary["reviewShopName"] as? String {
            self.reviewLocation = shopName
        }
        
        if let review = dictionary["reviewText"] as? String {
            self.reviewText = review
        }
        
        if let user = dictionary["reviewAuthor"] as? String {
            self.reviewAuthor = user
        } else {
            self.reviewAuthor = ""
        }
        
        self.reviewRef = DataService.dataService.REVIEW_REF.childByAppendingPath(self.key)
    }
}