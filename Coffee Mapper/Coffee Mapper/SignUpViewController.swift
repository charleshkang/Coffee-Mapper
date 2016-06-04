//
//  CMSignUpViewController.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/13/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject)
    {
        signUp()
    }
    
    func signupErrorAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: Sign Up Logic
    func signUp()
    {
        guard
            let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text
            where !username.isEmpty && !email.isEmpty && !password.isEmpty
            else { return signupErrorAlert("Oops!", message: "Having some trouble creating your account. Try again.") }
        
        DataService.dataService.BASE_REF.createUser(email, password: password, withValueCompletionBlock: { error, result in
            if error != nil {
                print(error)
                self.signupErrorAlert("Oops!", message: "Don't forget to enter your email, password, and username.")
            } else {
                DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { err, authData in
                    let user = ["provider": authData.provider!, "email": email, "username": username]
                    DataService.dataService.createNewAccount(authData.uid, user: user)
                })
                NSUserDefaults.standardUserDefaults().setValue(result["uid"], forKey: "uid")
                
                let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("navControllerID")
                self.navigationController?.pushViewController(homeVC!, animated: true)
                self.showViewController(homeVC!, sender: self)

            }
        })
    }}