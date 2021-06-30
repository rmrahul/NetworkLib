//
//  Reachability.swift
//  NetworkReachability
//
//  Created by Perennial on 17/04/17.
//  Copyright © 2017 Perennial. All rights reserved.
//

import Foundation
import SystemConfiguration

let kReachabilityChangedNotification = "kNetworkReachabilityChangedNotification";

let kShouldPrintReachabilityFlags = 1

class Reachability : NSObject {
    
    var alwaysReturnLocalWiFiStatus : Bool = false
    var reachabilityRef : SCNetworkReachability?
    
    func PrintReachabilityFlags(flags: SCNetworkReachabilityFlags, comment: String) {
        
        #if kShouldPrintReachabilityFlags
        
            print("Reachability Flag Status:"
                   +     (flags.contains(.isWWAN)	     		? "W" : "-")
                   +     (flags.contains(.reachable)            ? "R" : "-")
                   +     " "
                   +     (flags.contains(.transientConnection)  ? "t" : "-")
                   +     (flags.contains(.connectionRequired)   ? "c" : "-")
                   +     (flags.contains(.connectionOnTraffic)  ? "C" : "-")
                   +     (flags.contains(.interventionRequired) ? "i" : "-")
                   +     (flags.contains(.connectionOnDemand)   ? "D" : "-")
                   +     (flags.contains(.isLocalAddress)       ? "l" : "-")
                   +     (flags.contains(.isDirect)             ? "d":  "-")
                   +     " "
                   +     comment
            )

            
        #endif
    }
    
    class func reachabilityWithHostName(hostName: String) -> Reachability? {
        
        var reachabilityObject : Reachability? = nil
        let reachability = SCNetworkReachabilityCreateWithName(nil, (hostName as NSString).utf8String!)
        if(reachability != nil) {
           
            reachabilityObject = Reachability()
            if(reachabilityObject != nil) {
                
                reachabilityObject?.reachabilityRef = reachability
                reachabilityObject?.alwaysReturnLocalWiFiStatus = false
            }
        }
        return reachabilityObject
    }
    
    class func reachabilityWithAddress(_ hostAddress: sockaddr_in) -> Reachability? {
        
        var reachabilityObject : Reachability? = nil
        var address = hostAddress
        guard let reachability = withUnsafePointer(to: &address, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                
                SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
            }
        }) else {
            return nil
        }
        reachabilityObject = Reachability()
        reachabilityObject?.reachabilityRef = reachability
        reachabilityObject?.alwaysReturnLocalWiFiStatus = false
        return reachabilityObject
    }
    
    class func reachabilityForInternetConnection() -> Reachability {
        
        var zeroAddress = sockaddr_in()
        bzero(&zeroAddress, MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_len = __uint8_t(UInt(MemoryLayout.size(ofValue: zeroAddress)))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let rechability = self.reachabilityWithAddress(zeroAddress)!
        return rechability
    }
    
    class func reachabilityForLocalWiFi() -> Reachability {
        
        var localWifiAddress = sockaddr_in()
        bzero(&localWifiAddress, MemoryLayout.size(ofValue: localWifiAddress))
        localWifiAddress.sin_len = __uint8_t(UInt(MemoryLayout.size(ofValue: localWifiAddress)))
        localWifiAddress.sin_family = sa_family_t(AF_INET)
        let reachabilityObject = self.reachabilityWithAddress(localWifiAddress)
        if(reachabilityObject != nil) {
            
            reachabilityObject?.alwaysReturnLocalWiFiStatus = true
        }
        return reachabilityObject!
    }
    
    //MARK:- Start and stop notifier

    func startNotifier() -> Bool {
     
        var returnValue = false
        var context = SCNetworkReachabilityContext(version: 0, info: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()), retain: nil, release: nil, copyDescription: nil)
        
        if(SCNetworkReachabilitySetCallback(reachabilityRef!, { (target, flags, info) in
            
            //# unused (target, flags)
            assert(info != nil, "info was NULL in ReachabilityCallback")
            let infoObject = Unmanaged<AnyObject>.fromOpaque(info!).takeUnretainedValue()
            assert((infoObject is Reachability), "info was wrong class in ReachabilityCallback")
            
            // Post a notification to notify the client that the network reachability changed.
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kReachabilityChangedNotification), object: infoObject)
            
            }, &context)) {
            
            guard SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef!, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue) == true else {
                return false
            }

                returnValue = true
            
        }
        
        return returnValue
    }
    
    func stopNotifier() {
        
        if(reachabilityRef != nil) {
            
            SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef!, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        }
    }
    
    deinit {
        
        self.stopNotifier()
        if(reachabilityRef != nil) {
            
            reachabilityRef = nil
        }
    }
 
    //MARK:- Network Flag Handling

    func localWiFiStatusForFlags(flags: SCNetworkReachabilityFlags) -> NetworkStatus {
        
        PrintReachabilityFlags(flags: flags, comment: "localWiFiStatusForFlags")
        var networkStatus: NetworkStatus = .NotReachable
        
        if ((flags.contains(.reachable)) && (flags.contains(.isDirect))) {
            
            networkStatus = .ReachableViaWiFi
        }
        return networkStatus
    }
    
    func networkStatusForFlags(flags: SCNetworkReachabilityFlags) -> NetworkStatus {
        
        PrintReachabilityFlags(flags: flags, comment: "networkStatusForFlags")
        if !(flags.contains(.reachable)) {
            
            return .NotReachable
        }
        var networkStatus = NetworkStatus.NotReachable
        
        if !(flags.contains(.connectionRequired)) {
            
            networkStatus = .ReachableViaWiFi
        }
        
        if((flags.contains(.connectionOnDemand)) || (flags.contains(.connectionOnTraffic))) && (flags.contains(.interventionRequired)) {

            networkStatus = .ReachableViaWiFi
        }
        if(flags.contains(.isWWAN)) {
            
            networkStatus = .ReachableViaWWAN
        }
        return networkStatus
    }
    
    func connectionRequired() -> Bool {
        
        assert(reachabilityRef != nil, "connectionRequired called with NULL reachabilityRef")
        var flags = SCNetworkReachabilityFlags()
        if(SCNetworkReachabilityGetFlags(reachabilityRef!, &flags)) {
            
            return flags.contains(.connectionRequired)
        }
        return false
    }
    
    func currentReachabilityStatus() -> NetworkStatus {
        
        assert(reachabilityRef != nil, "currentNetworkStatus called with NULL SCNetworkReachabilityRef")
        var networkStatus = NetworkStatus.NotReachable;
        var flags = SCNetworkReachabilityFlags()
        
        if(SCNetworkReachabilityGetFlags(reachabilityRef!, &flags)) {
            
            if(alwaysReturnLocalWiFiStatus) {
                
                networkStatus = self.localWiFiStatusForFlags(flags: flags)
            }
            else {
                
                networkStatus = self.networkStatusForFlags(flags: flags)
            }
        }
        return networkStatus
    }
    
}

