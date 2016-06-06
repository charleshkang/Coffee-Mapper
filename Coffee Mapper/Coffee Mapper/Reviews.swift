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
    var reviewText: String!
    var reviewAuthor: String!
    var reviewRating: Float!
    
    init(dictionary: Dictionary<String, AnyObject>)
    {
        self.reviewRating = dictionary["reviewRating"] as! Float
        self.reviewText = dictionary["reviewText"] as! String
        self.reviewAuthor = dictionary["reviewAuthor"] as! String
    }
}