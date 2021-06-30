//
//  NetworkService.swift
//  NetworkReachability
//
//  Created by Perennial on 17/04/17.
//  Copyright © 2017 Perennial. All rights reserved.
//

import Foundation

enum NETWORK_STATUS {
    
    case NETWORK_STATUS_AVAILABLE
    case NETWORK_STATUS_AVAILABLE_SERVER_DEAD
    case NETWORK_STATUS_NOT_AVAILABLE
}

enum NetworkStatus : Int {
    
    case NotReachable = 0
    case ReachableViaWiFi
    case ReachableViaWWAN
}

protocol NetworkServiceDelegate {
    
    func internetAvailabilityChanged(status : NETWORK_STATUS)
}

class NetworkService : NSObject {
    
    private var currentNetworkStatus : NETWORK_STATUS?
    private var hostReach            : Reachability?
    var delegate                     : NetworkServiceDelegate?
    override init() {
        
        super.init()
        currentNetworkStatus = self.isInternetAvailable()
    }
    
    func networkStatus() -> NETWORK_STATUS {
        
        return currentNetworkStatus!
    }

    func isInternetAvailable() -> NETWORK_STATUS {
        
        self.hostReach = Reachability.reachabilityForInternetConnection()
        _ = self.hostReach?.startNotifier()
        
        let remoteHostStatus = self.hostReach?.currentReachabilityStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(internetAvailabilityChanged), name: NSNotification.Name(rawValue: kReachabilityChangedNotification), object: nil)
        if (remoteHostStatus == NetworkStatus.NotReachable) {
            
            return .NETWORK_STATUS_NOT_AVAILABLE
        } else {
            return .NETWORK_STATUS_AVAILABLE
        }
    }
    
    @objc func internetAvailabilityChanged(notification: Notification) {
        
        let reachability = notification.object as! Reachability
        let isNetAvailable = reachability.currentReachabilityStatus() != .NotReachable
        if isNetAvailable {
            
            currentNetworkStatus = .NETWORK_STATUS_AVAILABLE
        }
        else {
            
            currentNetworkStatus = .NETWORK_STATUS_NOT_AVAILABLE
        }
        delegate?.internetAvailabilityChanged(status: currentNetworkStatus!)
    }
}
