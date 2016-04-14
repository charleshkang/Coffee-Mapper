//
//  CMHomeViewController.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/13/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit

class CMHomeViewController: UIViewController {

    @IBAction func logoutButtonTapped(sender: AnyObject) {
        DataService.dataService.CURRENT_USER_REF.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
    
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("loginIdentifier")
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
        presentViewController(loginViewController, animated: true, completion: nil)
        
    }
 
}
