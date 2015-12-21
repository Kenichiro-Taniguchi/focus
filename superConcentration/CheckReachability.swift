//
//  CheckReachability.swift
//  superConcentration
//
//  Created by 谷口健一郎 on 2015/12/07.
//  Copyright © 2015年 谷口健一郎. All rights reserved.
//

import Foundation
import SystemConfiguration

func CheckReachability(host_name:String)->Bool{
    
    let reachability = SCNetworkReachabilityCreateWithName(nil, host_name)!
    var flags = SCNetworkReachabilityFlags.ConnectionAutomatic
    if !SCNetworkReachabilityGetFlags(reachability, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
}

