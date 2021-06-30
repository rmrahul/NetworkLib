//
//  UserModel.swift
//  NetworkLibByRx
//
//  Created by Rahul Mane on 19/02/18.
//  Copyright © 2018 developer. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: Initializer and Properties
struct SMUser: Mappable {
    
    var first_name: String?
    var last_name: String?
    var email: String?
    var gender: String?
    var password: String?
    var confirm_password: String?
    var device_type: String?
    var device_token: String?
    
    // MARK: JSON
    init() {}
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email <- map["email"]
        
        gender <- map["gender"]
        password <- map["password"]
        confirm_password <- map["confirm_password"]
        device_type <- map["device_type"]
        device_token <- map["device_token"]
    }
    
}


