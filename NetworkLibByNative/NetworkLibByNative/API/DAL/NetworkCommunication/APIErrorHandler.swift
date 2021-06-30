//
//  APIErrorHandler.swift
//  MyWallet
//
//  Created by Pravin on 18/11/17.
//  Copyright © 2017 com.perennial. All rights reserved.
//

import Foundation


class APIErrorHandler : NSObject{
    
    class func checkForError(statusCode : Int, data : Data?){
        
        guard let responseData = data, let responseString = String(data: responseData, encoding: String.Encoding.utf8) else{
            return;
        }
        if(statusCode != 200){
            //log.error("API response error \(responseString)")
        }
        switch(statusCode){
        case 200:
            return;
        case 400:
            //TO DO - add In every network class
            if(responseString.contains("invalidAccessToken")){
                //NotificationCenter.default.post(name: UNAUTORIZE_NOTIFICATION, object: nil)
            }
        case 401:
            //TO DO - add In every network class
            if(responseString.contains("unauthorized")){
                //NotificationCenter.default.post(name: UNAUTORIZE_NOTIFICATION, object: nil)
            }
        default:
            break
        }
    }
}
