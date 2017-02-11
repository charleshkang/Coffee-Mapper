//
//  User.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/15/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import Firebase
import Foundation

struct User {
    
    let uid: String
    let email: String
    let username: String
    
    init(authData: FIRAuth) {
        uid = (authData.currentUser?.uid)!
        email = (authData.currentUser?.providerData[0] as? String)!
        username = (authData.currentUser?.providerData[1] as? String)!
    }
}
