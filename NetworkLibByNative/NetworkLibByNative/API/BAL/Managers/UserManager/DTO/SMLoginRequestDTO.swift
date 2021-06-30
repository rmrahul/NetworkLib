//
//  SMLoginRequestDTO.swift
//  NetworkLibByNative
//
//  Created by Rahul Mane on 24/02/18.
//  Copyright © 2018 developer. All rights reserved.
//

import Foundation
struct SMLoginRequestDTO : Codable {
    var email : String?
    var password : String?
    var social_id: String?
    var device_token: String?
    var device_type: String?
    
    enum CodingKeys: String, CodingKey {
        case email  = "email"
        case  password = "password"
        case  social_id = "social_id"
        case  device_token = "device_token"
        case  device_type = "device_type"
    }
    
    init() {
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try! values.decodeIfPresent(String.self, forKey: .email)
        password = try! values.decodeIfPresent(String.self, forKey: .password)
        social_id = try! values.decodeIfPresent(String.self, forKey: .social_id)
        device_token = try! values.decodeIfPresent(String.self, forKey: .device_token)
        device_type = try! values.decodeIfPresent(String.self, forKey: .device_type)
    }
}

