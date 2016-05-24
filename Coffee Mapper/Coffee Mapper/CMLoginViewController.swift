//
//  CMLoginViewController.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/13/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit

class CMLoginViewController: UIViewController
{
    @IBOutlet weak var signUpButtonTapped: UIButton!
    @IBOutlet weak var signInButtonTapped: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && DataService.dataService.CURRENT_USER_REF.authData != nil {
            
            let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("homeVCIdentifier") as! CMHomeViewController
            
            self.showViewController(homeVC, sender: self)
//            self.presentViewController(homeVC, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func signInButtonTapped(sender: AnyObject)
    {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            where !email.isEmpty && !password.isEmpty
            else { return loginErrorAlert("Oops!", message: "Don't forget to enter your email and password.") }
        
        DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in
            if error != nil {
                print(error)
                self.loginErrorAlert("Oops!", message: "Check your username and password.")
            } else {
                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                print("user logged in with uid:\(authData.uid)")
                let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("homeVCIdentifier") as! CMHomeViewController
                self.presentViewController(homeVC, animated: true, completion: nil)
            }
        })
    }
    func loginErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}

extension UIViewController
{
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}