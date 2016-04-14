//
//  CMSignUpViewController.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/13/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit
import Firebase

class CMSignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject)
    {
        if self.usernameTextField.isFirstResponder() {
            self.usernameTextField.resignFirstResponder()
        }
        
        if self.passwordTextField.isFirstResponder() {
            self.passwordTextField.resignFirstResponder()
        }
        
        if self.emailTextField.isFirstResponder() {
            self.emailTextField.resignFirstResponder()
        }
        
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if username != "" && email != "" && password != "" {
            DataService.dataService.BASE_REF.createUser(email, password: password, withValueCompletionBlock: { error, result in
                if error != nil {
                    self.signupErrorAlert("Oops!", message: "Having some trouble creating your account. Please try again.")
                } else {
                    DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: {err, authData in
                        let user = ["provider": authData.provider!, "email": email!, "username": username!]
                        DataService.dataService.createNewAccount(authData.uid, user: user)
                    })
                    NSUserDefaults.standardUserDefaults().setValue(result ["uid"], forKey: "uid")
                    self.performSegueWithIdentifier("NewUserLoggedIn", sender: nil)
                }
            })
        } else {
            signupErrorAlert("Oops!", message: "Don't forget to enter your email, password, and a username.")
        }
    }
    func signupErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}

