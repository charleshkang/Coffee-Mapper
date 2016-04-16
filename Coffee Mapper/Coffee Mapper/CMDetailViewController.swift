//
//  CMDetailViewController.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/15/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit
import Firebase

class CMDetailViewController: UIViewController
{
    var items = [ReviewItem]()
    var user: User!
    let ref = Firebase(url: "https://coffee-mapper-charleshkang.firebaseio.com/reviews")
    var currentUsername = ""
    
    @IBOutlet weak var reviewTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        DataService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            let currentUser = snapshot.value.objectForKey("username") as! String
            
            print("Username: \(currentUser)")
            self.currentUsername = currentUser
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    
    @IBAction func submitReviewButtonTapped(sender: AnyObject)
    {
        let alert = UIAlertController(title: "Review",
                                      message: "Submit your review!",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default) { (action: UIAlertAction!) -> Void in
                                        
                                        let textField = alert.textFields![0]
                                        let reviewItem = ReviewItem(name: textField.text!, completed: false)
                                        let reviewItemRef = self.ref.childByAppendingPath(textField.text!.lowercaseString)
                                        
                                        reviewItemRef.setValue(reviewItem.toAnyObject())
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }
    @IBAction func submitReviewButton(sender: AnyObject) {
        let reviewText = reviewTextField.text
        
        if reviewText != "" {
            let newReview: Dictionary<String, AnyObject> = [
                "reviewText": reviewText!,
                "author": currentUsername
            ]
            DataService.dataService.createNewReview(newReview)
        }
    }
}