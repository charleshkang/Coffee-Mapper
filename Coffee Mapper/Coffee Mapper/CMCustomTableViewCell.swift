//
//  CMCustomTableViewCell.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 5/11/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit
import Firebase

class CMCustomTableViewCell: UITableViewCell {
    
    @IBOutlet var reviewerNameLabel: UILabel!
    @IBOutlet var reviewRating: UILabel!
    @IBOutlet var reviewText: UILabel!
    
    var review: Reviews!
    var reviewRef: Firebase!
    
    func configureCell(review: Reviews) {
        self.review = review
        
        self.reviewText.text = review.reviewText
        self.reviewRating.text = "\(review.rating)"
        self.reviewerNameLabel.text = review.username
    }
}