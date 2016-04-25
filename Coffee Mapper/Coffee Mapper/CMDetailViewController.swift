//
//  CMDetailViewController.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/15/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit
import Firebase
import HCSStarRatingView

class CMDetailViewController: UIViewController
{
    var items = [ReviewItem]()
    var user: User!
    let ref = Firebase(url: "https://coffee-mapper-charleshkang.firebaseio.com/reviews")
    var currentUsername = ""
    let starRatingView = HCSStarRatingView()
    
    
    @IBOutlet var reviewTextView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        DataService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            let currentUser = snapshot.value.objectForKey("username") as! String
            self.currentUsername = currentUser
            }, withCancelBlock: { error in
                print(error.description)
        })
    }

    @IBAction func submitReviewButton(sender: AnyObject)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let reviewRatings = defaults.floatForKey("reviews")
        print("saved rating: \(reviewRatings)")

        let reviewText = reviewTextView.text
        let reviewRating = sender.starRatingView.value
        print("Rating: \(reviewRating)")
        
        if reviewText != "" {
            let newReview: Dictionary<String, AnyObject> = [
                "reviewText": reviewText!,
                "author": currentUsername,
                "reviewRating": reviewRating
            ]
            DataService.dataService.createNewReview(newReview)
        }
        else {
            emptyReviewField("Oops!", message: "Make sure to leave some text in your review.")
        }
    }
    
    func emptyReviewField(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(alertAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func didChangeValue(sender: HCSStarRatingView)
    {
        let rating = sender.value
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setFloat(Float(rating), forKey: "reviews")
            print("rating: \(rating)")
        // save the sender.value, either write to Realm or send to firebase as another entry
        
    }
    
}