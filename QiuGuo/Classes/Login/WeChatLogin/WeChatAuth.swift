//
//  WeChatAuth.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/10.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import Foundation


class WeChatAuth: NSObject {
    
    //MARK:- 调用微信登录
    class func sendAuthRequest(controller:UIViewController){
    
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "weChat_state"
        

        WXApi.sendAuthReq(req, viewController: controller, delegate: WeChatManager.sharedInstace)
    
    
    
    }
    
    







}
