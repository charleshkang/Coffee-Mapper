
//  AppDelegate.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/13/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {   
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") == nil {
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("loginIdentifier")
            window?.rootViewController = loginVC
        } else if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && DataService.dataService.CURRENT_USER_REF.authData != nil {
            let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("homeIdentifier")
            let navigationController = UINavigationController(rootViewController: homeVC)
            window?.rootViewController = navigationController
        }
        
        let config = Realm.Configuration(
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                }
        })
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
        
        return true
    }
}