//
//  UserManager.swift
//  NetworkLibByRx
//
//  Created by Rahul Mane on 19/02/18.
//  Copyright © 2018 developer. All rights reserved.
//

import Foundation
import RxOptional
import RxSwift
import ObjectMapper
import RxAlamofire
import Alamofire

struct UserManager {
    
    func register(user : SMUser) -> Observable<SMUser>{
        return RxAlamofire.request(.post, "http://www.scrimmage.gq/api/user", parameters: Mapper().toJSON(user), encoding: JSONEncoding.default, headers: nil).responseJSON().map({ (response) -> SMUser in
            
            let user = SMUser()
            return user
        }).asObservable()
//        return RxAlamofire.request(.post, URL(string :"")!)
//            .debug().asObservable()
        
    }
    
    
    
}

