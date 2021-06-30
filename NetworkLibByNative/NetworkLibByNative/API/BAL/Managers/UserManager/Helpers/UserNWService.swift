//
//  UserNWService.swift
//  MyWallet
//
//  Created by Developer on 02/11/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AVFoundation

//TODO : Remove Object Mapper and Add Cadable

class UserNWService: NSObject {
    
    func performSignUp(loginRequestDTO : SMUser,completion:@escaping SignUpCompletionHandler){
        let apiHandler = BaseAPIHandler.sharedInstance()
        let params = self.getJSONObject(obj: loginRequestDTO)

        apiHandler.requestForApi(urlString: WebConstants.signup.path, method: .post, parameters:params, headers: nil, completion:{ (result) in
            switch result {
            case .success(let data):
                guard let jsonData = data else{
                    completion(.failure(error: UserManagerErrors.emptyResponse))
                    return
                }
                do{
                    let jsonDecoder = JSONDecoder()
                    let user = try jsonDecoder.decode(SMGenericResponse.self, from: jsonData)
                    completion(.success(result:user))
                }
                catch{
                    completion(.failure(error: UserManagerErrors.jsonParsingError))
                }
            case .failure(let error, let errorData):
                let error = self.parseError(error: error, errorData: errorData)
                completion(.failure(error: error))
            }
        })
    }
    
    func performLogin(loginRequestDTO : SMLoginRequestDTO,completion:@escaping SignInCompletionHandler){
        let apiHandler = BaseAPIHandler.sharedInstance()
        let params = self.getJSONObject(obj: loginRequestDTO)

        apiHandler.requestForApi(urlString: WebConstants.USERMANAGEMENT.Login.path, method:  WebConstants.USERMANAGEMENT.Login.method, parameters:params, headers: nil, completion:{ (result) in
            switch result {
            case .success(let data):
                guard let jsonData = data else{
                    completion(.failure(error: UserManagerErrors.emptyResponse))
                    return
                }
                do{
                    let jsonDecoder = JSONDecoder()
                    let user = try jsonDecoder.decode(SMUser.self, from: jsonData)
                    completion(.success(result:user))
                }
                catch{
                    completion(.failure(error: UserManagerErrors.jsonParsingError))
                }
            case .failure(let error, let errorData):
                let error = self.parseError(error: error, errorData: errorData)
                completion(.failure(error: error))
            }
        })
    }
    
    //MARK: Error parsing
    func decodeToJSON(data : Data?) -> (Any?,UserManagerErrors){
        guard let jsonData = data else{
            return (nil, UserManagerErrors.emptyResponse)
        }
        do{
            let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)
            return (json,UserManagerErrors.unknown)
        }
        catch{
            return (nil, UserManagerErrors.jsonParsingError)
        }
    }
    
    fileprivate func parseError(error : APIErrors, errorData : Data?)-> UserManagerErrors{
        guard let data = errorData else{
            return UserManagerErrors.unknown
        }
        
        if let responseString = String(data: data, encoding: String.Encoding.utf8){
            print("❌ Error in API : ",responseString)
        }
        switch(error){
        case APIErrors.NoInternetConnection:
            return UserManagerErrors.NoInternetConnection
        case APIErrors.badRequest:
            return UserManagerErrors.paramterMistmatch
        case APIErrors.forbiddenAccess:
            guard let responseString = String(data: data, encoding: String.Encoding.utf8) else{
                return UserManagerErrors.forbiddenAccess;
            }
            
            /*
            if let _ = responseString.range(of: "Residential address is not defined"){
                return UserManagerErrors.residentialAddressIsNotDefined
            }
            else if let _ = responseString.range(of:"user_blocked_risk_threshold_exceeded"){
                return UserManagerErrors.user_blocked_risk_threshold_exceeded
            }
            else if let _ = responseString.range(of:"risk_threshold_limit_reached"){
                return UserManagerErrors.risk_threshold_limit_reached
            }
            else {
                return UserManagerErrors.forbiddenAccess
            }
 */
        case APIErrors.unauthorized:fallthrough
        case APIErrors.invalidData:
            guard let responseString = String(data: data, encoding: String.Encoding.utf8) else{
                return UserManagerErrors.unknown;
            }
            do{
                let jsonDecoder = JSONDecoder()
                let model = try jsonDecoder.decode(SMErrorResponse.self, from: data)
                return UserManagerErrors.validationFailed(error: model)
            }
            catch{
                return UserManagerErrors.validationFailed(error: nil)
            }

            
            
            /*
            if let _ = responseString.range(of: "userEmailAlreadyInUse"){
                return UserManagerErrors.userEmailAlreadyInUse
            }
            if let _ = responseString.range(of:"invalidAccessToken"){
                return UserManagerErrors.unauthorized
            }
            if let _ = responseString.range(of:"unauthorized"){
                return UserManagerErrors.unauthorized
            }
            if let _ = responseString.range(of: "Password must be atleast 8 characters and maximum 32 characters"){
                return UserManagerErrors.password_must_not_exceed
            }
            else if let _ = responseString.range(of: "New password must not be the same with"){
                return UserManagerErrors.newpassword_must_not_be_same
            }
            else if let _ = responseString.range(of:"invalidClientCredentials"){
                return UserManagerErrors.invalidCredentials
            }
            else   if let _ = responseString.range(of:"userPhoneAlreadyInUse"){
                return UserManagerErrors.userPhoneAlreadyInUse
            }else   if let _ = responseString.range(of:"mobileNumberAlreadyInUsed"){
                return UserManagerErrors.mobileNumberAlreadyInUsed
            }
            else if let _ = responseString.range(of:"userPasswordFailed"){
                return UserManagerErrors.invalidCredentials
            }
            else if let _ = responseString.range(of:"resource_user_password_rule"){
                return UserManagerErrors.unauthorize
            }
            else if let _ = responseString.range(of:"validationFailed"){
                return UserManagerErrors.unauthorize
            }
            else if let _ = responseString.range(of:"userAuthenticationValidationFailed"){
                return UserManagerErrors.userAuthenticationValidationFailed
            }
            else if let _ = responseString.range(of:"userAuthenticationValidationTokenExpired"){
                return UserManagerErrors.userAuthenticationValidationTokenExpired
            }
            else if let _ = responseString.range(of:"unauthorized"){
                return UserManagerErrors.unauthorize
            }
            else if let _ = responseString.range(of:"userNotFound"){
                return UserManagerErrors.invalidCredentials
            }
            else if let _ = responseString.range(of:"validationFailed"){
                return UserManagerErrors.validationFailed
            }
            else if let _ = responseString.range(of: "change_password_using_current_password"){
                return UserManagerErrors.change_password_using_current_password
            }else if let _ = responseString.range(of: "New password must not be the same with the current password"){
                return UserManagerErrors.change_password_using_current_password
            }
            else if let _ = responseString.range(of: "resource_id_type_unique "){
                return UserManagerErrors.resource_id_type_unique
            }
            else if let _ = responseString.range(of: "id_type must be alphanumeric "){
                return UserManagerErrors.id_type_must_be_alphanumeric
            }
            else if let _ = responseString.range(of: "id_number must not exceed 20 characters"){
                return UserManagerErrors.id_number_must_not_exceed_20_characters
            }
            else if let _ = responseString.range(of: "user_blocked_risk_threshold_exceeded"){
                return UserManagerErrors.user_blocked_risk_threshold_exceeded
            }
            else if let _ = responseString.range(of: "users_address_postcode_numeric"){
                return UserManagerErrors.users_address_postcode_numeric
            }
            else if let _ = responseString.range(of: "zipcode should contain only numeric digits"){
                return UserManagerErrors.zipcode_should_be_only_numeric
            }
            else if let _ = responseString.range(of: "Residential address is not defined"){
                return UserManagerErrors.residentialAddressIsNotDefined
            }
            else if let _ = responseString.range(of: "`first_name` must not be empty"){
                return UserManagerErrors.mustNotEmpty
            }
            else if let _ = responseString.range(of: "`last_name` must not be empty"){
                return UserManagerErrors.mustNotEmpty
            }
            else if let _ = responseString.range(of: "`email` domain is not valid"){
                return UserManagerErrors.invalidEmailDomain
            }
            else if let _ = responseString.range(of: "`mobile` is already registered"){
                return UserManagerErrors.userPhoneAlreadyInUse
            }
            else {
                return UserManagerErrors.unknown
            }*/
            
        case APIErrors.pageNotfound:
            return UserManagerErrors.urlNotFound
        case APIErrors.internalServerError:
            return UserManagerErrors.internalServerError
        case APIErrors.unknown:
            guard let responseString = String(data: data, encoding: String.Encoding.utf8) else{
                return UserManagerErrors.unknown;
            }
            
            if let _ = responseString.range(of: "413 Request Entity Too Large"){
                return UserManagerErrors.unknown
            }
            return UserManagerErrors.unknown
        }
        return UserManagerErrors.unknown
    }
    
    func getJSONObject<T : Encodable>(obj : T)->[String : String]?{
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do{
            let jsonData = try jsonEncoder.encode(obj)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)
            return json as! [String : String]
        }
        catch{
        }
        return nil
    }
}

