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

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
    
{
    var reviews = [Reviews]()
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
        
        userReviewsTableView.registerNib(UINib(nibName: "CustomReviewCell", bundle: nil), forCellReuseIdentifier: "customReviewCellIdentifier")
        
        self.hideKeyboardWhenTappedAround()
        
        navigationItem.title = venue.name
        
        getCurrentUsersName()
        updateReviewsOnFirebase()
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
            let newCoffeeShop: Dictionary<String, AnyObject> = [
                "coffeeShopName": venue.name,
                "coffeeShopRating": reviewRatings,
                "coffeeShopReview": reviewText,
                "coffeeShopReviewerName": currentUsername
            ]
            DataService.dataService.createNewReview(newReview)
            DataService.dataService.addNewCoffeeShop(newCoffeeShop)
            
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
    /* loop over the reviews array, get the uid of all the reviews, and do something */
    
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