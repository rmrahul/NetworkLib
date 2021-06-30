//
//  UserEndpoints.swift
//  NetworkLibByRx
//
//  Created by Rahul Mane on 19/02/18.
//  Copyright © 2018 developer. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

enum UserEndpoints {
    case register(user: SMUser)
}

extension UserEndpoints: TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL { return URL(string: "http://www.scrimmage.gq/")! }
    var path: String {
        switch self {
        case .register(let _):
            return "/api/user"
        }
    }
    var method: Moya.Method {
        switch self {
        case .register(let _):
            return .post
        }
        return .get
    }
    var parameters: [String: Any]? {
        switch self {
        case .register(let user):
            return Mapper().toJSON(user)
        }
    }
    var sampleData: Data {
        switch self {
        case .register(_):
            return "{{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}}}".data(using: .utf8)!
        }
    }
    var task: Task {
        switch self {
        case .register(let user):
            let data = Mapper().toJSON(user)
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: data,
                options: []) {
                let theJSONText = String(data: theJSONData,
                                         encoding: .ascii)
                print("JSON string = \(theJSONText!)")
                return .requestData(theJSONData)
            }
            
            return .requestPlain
        }
        
    }
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
}



