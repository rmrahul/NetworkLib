//
//  WebServiceConstant.swift
//  SwiftStructure
//
//  Created by Pravin on 10/10/16.
//  Copyright © 2016 com.perennial. All rights reserved.
//

import Foundation
import Alamofire

struct WebConstants {
    private init(){}
    
    static let S3_URL = "https://vcard-assets.s3.amazonaws.com/sg/assets/multi-card-sg/img/"
    
    static let END_POINT_BASE_URL           = "https://wallet.mmvpay.com/"

    struct login
    {
        static let path = "auth";
        static let method = HTTPMethod.post
       
        static let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
                let device  = UIDevice.current.model
                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                    
                    let osName: String = {
                        #if os(iOS)
                            return "iOS"
                        #elseif os(watchOS)
                            return "watchOS"
                        #elseif os(tvOS)
                            return "tvOS"
                        #elseif os(macOS)
                            return "OS X"
                        #elseif os(Linux)
                            return "Linux"
                        #else
                            return "Unknown"
                        #endif
                    }()
                    
                    return "\(osName) \(versionString)"
                }()
                
                return "\(executable)/\(appVersion) (\(device); \(osNameVersion))"
            }
            
            return ""
        }()
        

        static let headers : HTTPHeaders  =   [
            //"Authorization": Environment().configuration(PlistKey.header),
            "Content-Type" : "application/x-www-form-urlencoded",
            "User-Agent" : "\(userAgent)"
        ]
    }
    
    struct logout
    {
        static let path = "users/logout";
        static let method = HTTPMethod.post
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct signup
    {
        static let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
                let device  = UIDevice.current.model
                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                    
                    let osName: String = {
                        #if os(iOS)
                            return "iOS"
                        #elseif os(watchOS)
                            return "watchOS"
                        #elseif os(tvOS)
                            return "tvOS"
                        #elseif os(macOS)
                            return "OS X"
                        #elseif os(Linux)
                            return "Linux"
                        #else
                            return "Unknown"
                        #endif
                    }()
                    
                    return "\(osName) \(versionString)"
                }()
                return "\(executable)/\(appVersion) (\(device); \(osNameVersion))"
            }
            
            return ""
        }()
        
        static let path = "/api/user";
        static let method = HTTPMethod.post
        static let headers : HTTPHeaders  =   [
            //"Authorization": Environment().configuration(PlistKey.header),
            "User-Agent" : "\(userAgent)"
        ]
        
        struct requestParams{
            static let email                 = "email"
            static let password              = "password"
            static let firstName             = "first_name"
            static let middleName             = "middle_name"
            static let lastName              = "last_name"
            static let preferredName         = "preferred_name"
            static let mobileCountryCode     = "mobile_country_code"
            static let mobile                = "mobile"
            static let origin                = "origin"
            static let phoneOnly             = "phone_only"
            static let deviceSignature       = "device_signature"
            static let grandType             = "grant_type"
        }
        struct responseParams{
            static let id                    = "id"
            static let email                 = "email"
            static let name                  = "name"
            static let first                 = "first"
            static let middle                = "middle"
            static let last                  = "last"
            static let preferred             = "preferred"
            static let mobile                = "mobile"
            static let countryCode           = "country_code"
            static let number                = "number"
            static let status                = "status"
            static let isActive              = "is_active"
            static let text                  = "text"
            static let date                  = "date"
            static let registration          = "registration"
            static let clientId              = "client_id"
            static let origin                = "origin"
            static let accessToken           = "access_token"
            static let expiresIn             = "expires_in"
            static let tokenType             = "token_type"
            static let scope                 = "scope"
        }
    }
    
    struct recoverPassord
    {
        static let path = "users/recover/password";
        static let method = HTTPMethod.post
        static let headers : HTTPHeaders  =   [:]
        struct requestParams{
            static let mobileCountryCode     = "mobile_country_code"
            static let mobile                = "mobile"
        }
        struct responseParams{
            static let status     = "status"
            static let token     = "token"
        }
    }
    
    struct changePassord
    {
        static let path = "users/recover/password";
        static let method = HTTPMethod.put
        static let headers : HTTPHeaders  =   [:]
        struct requestParams{
            static let token                = "token"
            static let otp                  = "otp"
            static let key                  = "key"
        }
        struct responseParams{
             static let status     = "status"
        }
    }
    
    struct getEnumeration{
        static let path = "users/enumerations";
        static let method = HTTPMethod.get
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct USERMANAGEMENT {
        struct Login
        {
            static let path = "/api/login";
            static let method = HTTPMethod.post
            static let headers : HTTPHeaders  =   [:]
        }
    }
    
    
    struct getUser{
        static let path = "/users";
        static let method = HTTPMethod.get
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct getWallet{
        static let path = "users/wallets";
        static let method = HTTPMethod.get
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct transactionHistory{
        static let path = "users/wallets/transactions";
        static let method = HTTPMethod.get
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct loadCard{
        static let path = "users/wallets/cards";
        static let funds = "funds"
        static let method = HTTPMethod.post
        static let headers : HTTPHeaders  =   [:]
    }

    struct UnloadCard{
        static let path = "users/wallets/cards";
        static let funds = "funds"
        static let method = HTTPMethod.delete
        static let headers : HTTPHeaders  =   [:]
    }

    struct GetCardDetails{
        static let path = "users/wallets/cards";
        static let method = HTTPMethod.get
        static let headers : HTTPHeaders  =   [:]
    }
    struct GetUserAddress{
        static let path = "users/addresses";
        static let residential = "residential";
        static let billing = "billing";
        static let method = HTTPMethod.get
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct UpdateUserAddress{
        static let path = "users/addresses";
        static let residential = "residential";
        static let billing = "billing";
        static let method = HTTPMethod.put
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct UpdateMobileNumber{
        static let path = "users";
        static let method = HTTPMethod.put
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct postPasswordChangeRequest{
        static let path = "users/authentications/password";
        static let method = HTTPMethod.post
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct putPasswordChangeRequest{
        static let path = "users/authentications/password";
        static let method = HTTPMethod.put
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct putUpdateUserRequest{
        static let path = "users";
        static let method = HTTPMethod.put
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct uploadProfilePic{
        static let path = "users/profile/image";
        static let method = HTTPMethod.post
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct GenerateCVC {
        static let path = "users/wallets/cards";
        static let tokens = "securities/tokens";
        static let method = HTTPMethod.get
        static let headers : HTTPHeaders  =   [:]
    }

    struct GenerateATMPin {
        static let path = "users/wallets/cards";
        static let reset = "pins/reset";
        static let method = HTTPMethod.get
        static let headers : HTTPHeaders  =   [:]
    }

    struct EditCardName {
        static let path = "users/wallets/cards";
        static let method = HTTPMethod.put
        static let headers : HTTPHeaders  =   [:]
        
        struct requestParams {
            static let id          = "id"
            static let name        = "name"
        }
    }
    
    struct GetMobileCountryCodes {
        
        static let path = "/users/enumerations/mobile_country_codes";
        static let method = HTTPMethod.get
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct cardTransactionHistory {
        
        static let path = "users/wallets/cards";
        static let transactions = "transactions";
        static let method = HTTPMethod.get
        static let headers : HTTPHeaders  =   [:]
    }

    struct VerifyOTP{
        static let path = "users/authentications/phone"
        static let method = HTTPMethod.put
    }

    struct sendOTP {
        
        static let path = "/users/authentications/phone";
        static let method = HTTPMethod.post
        static let headers : HTTPHeaders  =   [:]
    }

    struct verifyOTPForActivateCard {
        
        static let path = "/users/wallets/cards";
        static let method = HTTPMethod.put
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct GetCountryDetails{
        
        static let path = "https://restcountries.eu/rest/v2/all?fields=name;alpha2Code;alpha3Code;flag;callingCodes";
        static let method = HTTPMethod.get
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct NotificationAPI {
        
        struct GetNotifications{
            static let path = "/users/notifications";
            static let method = HTTPMethod.get
            static let headers : HTTPHeaders  =   [:]
        }
        
        struct MarkNotificationsReadUnread{
            static let path = "/users/notifications";
            static let method = HTTPMethod.put
            static let headers : HTTPHeaders  =   [:]
        }
        
        struct DeleteNotification{
            
            static let path = "/users/notifications";
            static let method = HTTPMethod.delete
            static let headers : HTTPHeaders  =   [:]
        }
    }
    
    struct suspendCard {
        
        static let path = "users/wallets/cards";
        static let method = HTTPMethod.delete
        static let headers : HTTPHeaders  =   [:]
    }
    
    struct KYCDocumentUpload{
        struct GETKYCDocumentUpload{
            static let path = "users/authentications/documents";
            static let method = HTTPMethod.get
            static let headers : HTTPHeaders  =   [:]
        }
        
        struct POSTKYCDocumentUpload{
            static let path = "users/authentications/documents";
            static let method = HTTPMethod.post
            static let headers : HTTPHeaders  =   [:]
        }
        
        struct PUTKYCDocumentUpload{
            static let path = "users/authentications/documents";
            static let method = HTTPMethod.put
            static let headers : HTTPHeaders  =   [:]
        }
    }
    
    struct GetACard{
        struct GETCardTypes{
            static let path = "users/wallets/cards/types";
            static let method = HTTPMethod.get
            static let headers : HTTPHeaders  =   [:]
        }
        
        struct POSTCardType {
            static let path = "users/wallets/cards";
            static let method = HTTPMethod.post
            static let headers : HTTPHeaders  =   [:]

        }
        
        struct getVirtualcard{
            static let path = "users/wallets/cards";
            static let method = HTTPMethod.post
            static let headers : HTTPHeaders  =   [:]
        }
        
        struct purchagesCard{
            static let path = "users/wallets/cards/orders";
            static let method = HTTPMethod.post
            static let headers : HTTPHeaders  =   [:]
        }
        
        struct getPurchagesCardReceipt {
            static let path = "users/wallets/cards/orders";
            static let method = HTTPMethod.put
            static let headers : HTTPHeaders  =   [:]
        }
        
        struct activateCard {
            static let path = "users/wallets/cards/";
            static let method = HTTPMethod.post
            static let headers : HTTPHeaders  =   [:]
        }
        
        
        struct activatePendingCard {
            static let path = "users/wallets/cards";
            static let method = HTTPMethod.post
            static let headers : HTTPHeaders  =   [:]
        }
    }
    
    struct Transfer {
        struct Send {
            struct send{

                static let path = "users/wallets/direct/transfer";
                static let method = HTTPMethod.post
                static let headers : HTTPHeaders  =   [:]
            }
            
            struct sendDeatils{
                static let path = "users/wallets/direct/transfer";
                static let method = HTTPMethod.get
                static let headers : HTTPHeaders  =   [:]
            }
        }
        struct Favourite{
            
            struct getFavourite{
                static let path = "transaction/favorites";
                static let method = HTTPMethod.get
                static let headers : HTTPHeaders  =   [:]
            }
            
            struct addFavourite{
                static let path = "transaction/favorites";
                static let method = HTTPMethod.post
                static let headers : HTTPHeaders  =   [:]
            }
            
            struct deleteFavourite{
                static let path = "transaction/favorites";
                static let method = HTTPMethod.delete
                static let headers : HTTPHeaders  =   [:]
            }
        }
    }

    struct TopUp{
        struct providerList {
            static let path = "users/wallets/funds/providers";
            static let method = HTTPMethod.get
            static let headers : HTTPHeaders  =   [:]
        }
        
        struct paymentInfo {
            static let path = "users/wallets/funds/providers";
            static let method = HTTPMethod.post
            static let headers : HTTPHeaders  =   [:]
        }

        struct paymentStatus {
            static let path = "payment/status";
            static let method = HTTPMethod.get
            static let headers : HTTPHeaders  =   [:]
        }
        
        struct topupDetails{
            static let path = "users/wallets/direct/transfer";
            static let method = HTTPMethod.get
            static let headers : HTTPHeaders  =   [:]
        }
    }
    
    struct getLoyaltyPoints{
        static let path = "loyalty";
        static let method = HTTPMethod.get
        static let headers : HTTPHeaders  =   [:]
    }
    

}

//MARK: Error status code

struct WebServiceErrorCode {
    private init(){}
    let WS_ERROR_CODE_TIMEOUT                  =        -1001
    let WS_ERROR_CODE_CANNOT_CONNECT_TO_HOST   =        -1004
    let WS_ERROR_CODE_NETWORK_CONNECTION_LOST  =        -1005
    let WS_ERROR_CODE_INTERNET_CONNECTION      =        -1009
    let WS_NO_HOST_FOUND                       =        -1003
    let WS_ERROR_CODE_SESSION_EXPIRED          =         1013
    let WS_ERROR_CODE_PHONE_NUMBER_EXIST       =         1012
}

//STATUS CODE

let API_SUCCESS_CODE                        = 200
let API_JSON_EMPTY_CODE                     = 901

//ERROR DOMAIN
let JSON_EMPTY_DOMAIN                       = "JSON EMPTY"
let API_FAILURE_DOMAIN                      = "API Failure"

//MARK: Webservice Keys
let WS_STATUS                           =  "status"
let WS_SUCCESS                          =  true
let WS_FAILURE                          =  false
let WS_DATA                             =  "data"
let WS_ERROR                            =  "error"

