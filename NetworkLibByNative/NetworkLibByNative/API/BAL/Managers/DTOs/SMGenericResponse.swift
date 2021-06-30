//
//  SMGenericResponse.swift
//  NetworkLibByNative
//
//  Created by Rahul Mane on 24/02/18.
//  Copyright © 2018 developer. All rights reserved.
//

import Foundation
struct SMGenericResponse : Codable {
    let message : String?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}
