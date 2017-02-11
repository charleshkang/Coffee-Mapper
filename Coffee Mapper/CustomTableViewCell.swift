//
//  CMCustomTableViewCell.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 5/11/16.
//  Copyright © 2016 Charles Kang. All rights reserved.

import Firebase
import UIKit

class CustomTableViewCell: UITableViewCell {
    
    // Properties
    @IBOutlet var reviewerNameLabel: UILabel!
    @IBOutlet var reviewRating: UILabel!
    @IBOutlet var reviewText: UILabel!
    
    var review: Reviews!
    static var reviewRef: Firebase!
    
    func configureCell(review: Reviews)
    {
        self.review = review
        
        self.reviewText.text = review.reviewText
        self.reviewRating.text = String("\(review.reviewRating) Beans")
        self.reviewerNameLabel.text = review.reviewAuthor
    }
}
