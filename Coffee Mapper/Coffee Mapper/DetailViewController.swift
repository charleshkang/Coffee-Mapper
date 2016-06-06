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

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate
    
{
    var reviews = [Reviews]()
    var venue: Venue!
    var user: User!
    var currentUsername = ""
    let starRatingView = HCSStarRatingView()
    
    @IBOutlet var reviewTextView: UITextView!
    @IBOutlet var userReviewsTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.reviewTextView.delegate = self
    
        self.hideKeyboardWhenTappedAround()
        self.updateReviewsOnFirebase()
        self.getCurrentUsersName()
        self.navigationItem.title = venue.name
        
        self.userReviewsTableView.registerNib(UINib(nibName: "CustomReviewCell", bundle: nil), forCellReuseIdentifier: "customReviewCellIdentifier")
        }
    
    @IBAction func submitReviewButton(sender: AnyObject)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let reviewRating = defaults.floatForKey("reviews")
        
        let reviewText = reviewTextView.text

        if reviewText != "" {
            let newReview: Dictionary<String, AnyObject> = [
                "reviewText": reviewText!,
                "reviewAuthor": currentUsername,
                "reviewRating": reviewRating,
                "reviewShopName": venue.name
            ]
            DataService.dataService.createNewReview(newReview)
            
            let reviewContent = ["reviewRating": reviewRating, "reviewText": reviewText]
            DataService.dataService.addReviewForCoffeeShop(venue.id, review: reviewContent)
        }
        else {
            emptyReviewField("Oops!", message: "Make sure to leave some text in your review.")
        }
        self.reviewTextView.text = ""
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

    // MARK: Get Username and Update Reviews

    func getCurrentUsersName()
    {
        DataService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            let currentUser = snapshot.value.objectForKey("username") as! String
            
            print("Username: \(currentUser)")
            self.currentUsername = currentUser
            }, withCancelBlock: { error in
                print(error.description)
        })
    }

    func updateReviewsOnFirebase()
    {
        DataService.dataService.REVIEW_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            self.reviews = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    
                    if let reviewsDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let review = Reviews(key: key, dictionary: reviewsDictionary)
                        self.reviews.insert(review, atIndex: 0)
                    }
                }
            }
            self.userReviewsTableView.reloadData()
        })
    }
    
    // MARK: Table View Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return reviews.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let review = reviews[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("customReviewCellIdentifier") as? CustomTableViewCell {
            cell.configureCell(review)
            
            return cell
        } else {
            return CustomTableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}