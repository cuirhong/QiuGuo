//
//  NetworkMonitor.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/20.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import Alamofire

//当前网络类型
enum CurrentNetworkType {
    case UnKown;
    case WIFI;
    case Wwan;//自带网络
    case NotReachable;//不可用
}


class NetworkMonitor: NSObject {
    //MARK:- Alamofire网络监控
    static var manager:NetworkReachabilityManager? = NetworkReachabilityManager(host: "www.qiu.com")
    //MARK:- 网络监控
    static var networkMonitor:NetworkMonitor?
    
    //MARK:- 当前网络类型
    var currentNetworkType:CurrentNetworkType = .UnKown

    //MARK:- 获取网络监控类
    class func sharedNetworkMonitor()-> NetworkMonitor? {
        
        if networkMonitor != nil {
            return networkMonitor
        }
        networkMonitor = NetworkMonitor()
        return networkMonitor
    }
    

    //MARK:- 开始监控
    func startMonitor(){

        NetworkMonitor.manager?.listener = {status in
            switch status {
            case .notReachable:
                printData(message: "网络不可用")
                NetworkMonitor.sharedNetworkMonitor()?.currentNetworkType = .NotReachable
            case .unknown:
                printData(message: "未知")
                NetworkMonitor.sharedNetworkMonitor()?.currentNetworkType = .UnKown
            case .reachable(.ethernetOrWiFi):
                printData(message: "WIFI")
                NetworkMonitor.sharedNetworkMonitor()?.currentNetworkType = .WIFI
            case .reachable(.wwan):
                printData(message: "手机自带网络")
                NetworkMonitor.sharedNetworkMonitor()?.currentNetworkType = .Wwan
            }
        }
       _ = NetworkMonitor.manager?.startListening()
     
    }
    
}










