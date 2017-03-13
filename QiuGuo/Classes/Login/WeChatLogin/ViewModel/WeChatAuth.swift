//
//  WeChatAuth.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/10.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit


class WeChatAuth: NSObject {
    
    //MARK:- 调用微信登录
    class func sendAuthRequest(controller:UIViewController){
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = weChatLoginState
        
        WXApi.sendAuthReq(req, viewController: controller, delegate: WeChatManager.sharedInstace)
       
    }
    
    //MARK:- 获取微信token
    class func getWeChatToken(code:String,successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock) {
        let urlString = String(format: "https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeChatManager.appId,WeChatManager.appSecret,code)

        NetworkTool.request(type: .GET, urlString: urlString, isQiuUrl: false, paramters: nil, finishedCallback: { (result) in
            
            if  result["errcode"].stringValue.isEmpty{
                WeChatManager.accessToken = result["access_token"].stringValue
                WeChatManager.openId = result["openid"].stringValue
                WeChatManager.refreshToken = result["refresh_token"].stringValue
                 successCallBack(result)
            }else{
             HUDTool.show(showType: .Failure, text: result["errcode"].stringValue)
            
            }
   
        }) { (error) in
             failureCallBack(error)
        }
        
    }

}
