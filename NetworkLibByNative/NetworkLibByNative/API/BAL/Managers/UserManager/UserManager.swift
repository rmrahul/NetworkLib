//
//  UserManager.swift
//  MyWallet
//
//  Created by Developer on 02/11/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import Foundation
import ObjectMapper
//TODO : Remove Object Mapper and Add Cadable

//TODO: We can move these all errors to parent enums
enum UserManagerErrors:Error {
    case validationFailed(error : SMErrorResponse?)
    case invalidCredentials
    case unauthorize
    case emptyResponse
    case jsonParsingError
    case unexpectedType
    case paramterMistmatch
    case invalidEmailDomain
    case urlNotFound
    case forbiddenAccess
    case internalServerError
    case unauthorized
    case NoInternetConnection
    case unknown
}

enum UserManagerResult<T>{
    case success(result: T)
    case failure(error:UserManagerErrors)
}

typealias SignUpCompletionHandler = (_ result: UserManagerResult<SMGenericResponse>) -> Void
typealias SignInCompletionHandler = (_ result: UserManagerResult<SMUser>) -> Void

class UserManager: NSObject {
    fileprivate static var mInstance:UserManager = UserManager()
    fileprivate let userNWService = UserNWService()
    fileprivate let userDBService = UserDBService()
   
    fileprivate override init() {
        super.init()
    }
    
    class func shared()->UserManager{
        return mInstance
    }

    func performSignUp(loginRequestDTO : SMUser, completion:@escaping SignUpCompletionHandler) -> Void {
        userNWService.performSignUp(loginRequestDTO: loginRequestDTO,completion:{ (result) in
            switch result {
            case .success(let loginresponse):
                break
            case .failure(let error):
                completion(.failure(error: error))
                break
            }
        })
    }
    
    func performLogin(loginRequestDTO : SMLoginRequestDTO,completion:@escaping SignInCompletionHandler){
        userNWService.performLogin(loginRequestDTO: loginRequestDTO, completion: completion)
    }
}

