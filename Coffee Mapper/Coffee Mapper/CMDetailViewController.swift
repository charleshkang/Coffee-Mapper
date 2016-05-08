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
    var venue: Venue!
    var items = [ReviewItem]()
    var user: User!
    let ref = Firebase(url: "https://coffee-mapper-charleshkang.firebaseio.com/reviews")
    var currentUsername = ""
    let starRatingView = HCSStarRatingView()
    var venues = Venue?.self

    @IBOutlet var reviewTextView: UITextView!
    @IBOutlet var userReviewsTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        navigationItem.title = venue.name

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
        print("rating: \(reviewRatings)")
        
        let reviewText = reviewTextView.text
        
        if reviewText != "" {
            let newReview: Dictionary<String, AnyObject> = [
                "reviewText": reviewText!,
                "reviewAuthor": currentUsername,
                "reviewRating": reviewRatings,
                "reviewShopName": venue.name
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
    }
    
    // MARK: Table View Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier")
        
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cellIdentifier")
        }
       
        return cell!
    }
}