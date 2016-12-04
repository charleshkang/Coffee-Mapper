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
    
    init(authData: FAuthData) {
        uid = authData.uid
        email = authData.providerData["email"] as! String
        username = authData.providerData["username"] as! String
    }
    
//    init(uid: String, email: String, username: String)
//    {
//        self.uid = uid
//        self.email = email
//        self.username = username
//    }
}
