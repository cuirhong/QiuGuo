//
//  NetworkTool.swift
//  XMTV
//
//  Created by Mac on 2017/1/4.
//  Copyright © 2017年 Mac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


enum MethodType {
    case GET
    case POST
}

class NetworkTool {
    class func request(type: MethodType, urlString: String,isQiuUrl:Bool=true, paramters: [String: Any]? = nil, finishedCallback: @escaping (_ result: JSON) -> (),failureCallback:FailureBlock? = nil) {
        
        
        
        
        printData(message: urlString)
        HUDTool.show(showType: .Load)
        // 获取类型
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        // 发送网络请求
         var parameter:[String:Any]? = [String:Any]()
        if isQiuUrl{           
            if paramters != nil, (paramters?.count)! > 0 {
                var parametersDict:[String:Any] = paramters!
                parametersDict["client"] = 2
                parametersDict["version"] = 100
                parameter = parametersDict
            }
        }else{
          parameter = paramters
        }
        
        
        
        Alamofire.request(urlString, method: method, parameters: parameter).responseJSON { (response) in
             HUDTool.dismiss()
            
        
            printData(message: response.result)
            
            if response.result.isSuccess{
                if let json = response.result.value{
                    let swiftJson = JSON(json)
                    printData(message: swiftJson)
                    // 回调
                    if UserInfo.loadAccount() != nil {
                        if let code = swiftJson["code"].int{
                            if code == 10{
                                //token失效
                                HUDTool.show(showType: .Info, text: "用户登录失效,请重新登录")
                                UserInfo.logout()
                            }
                        }
                    }
                 
                    finishedCallback(swiftJson)
                }else{
                    printData(message: response.result.error)                    
                }
            }else{
                 HUDTool.dismiss()
                 
                failureCallback!(response.result.error)
                printData(message: response.result.error)
             }
        }
    }
    
    
    //MARK:- 检测网络是否连接
    class  func requestUrl(urlString: String) -> Bool {
        let url: NSURL = NSURL(string: urlString)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        request.timeoutInterval = 5
        
        var response: URLResponse?
        
        do {
            try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("response:\(httpResponse.statusCode)")
                    return true
                }
            }
            return false
        }
        catch (let error) {
            print("error:\(error)")
            return false
        }
    }
    
    
    class func taskRequest(type: MethodType, urlString: String,paramters: [String: Any]? = nil, finishedCallback: @escaping (_ result: JSON) -> (),failureCallback:FailureBlock? = nil){
    
    
    
    }
    
   
    
    
    
    
    
    
    
}
