//
//  WeChatManager.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/10.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//


import UIKit


@objc
protocol WeChatManagerDelegate:NSObjectProtocol {
    
    //MARK:- 授权登录回调
    @objc func weChatManager(_ manager:WeChatManager,resp:SendAuthResp)
    
    
    
    
}

struct WeChatInfoSaveKey {
    var openId = "weChat_key_openId"
    var accessToken = "weChat_key_accessToken"
    var refreshToken = "weChat_key_refreshToken"
    
}


class WeChatManager: NSObject {
    
    //MARK:- 微信代理
    weak var delegate:WeChatManagerDelegate?
    
    
    
    //MARK:- 微信基本信息保存
    fileprivate static let saveKey = WeChatInfoSaveKey()


    
    //MARK:- 微信开放平台，注册的应用程序id
     static var appId:String!
    
    //MARK:- 微信开放平台，注册的应用程序secret
    static var appSecret:String! = weChatSecret
    
    //MARK:- 微信授权之后的openId
    static var openId:String!{
        didSet{
            userDefault.set(self.openId, forKey: saveKey.openId)
            userDefault.synchronize()
        }
    }
    
    //MARK:- 微信授权之后的token
    static var accessToken:String!{
        didSet{
            userDefault.set(self.accessToken, forKey: saveKey.accessToken)
            userDefault.synchronize()
        }
    }
    
    //MARK:- refreshToken
    static var refreshToken:String!{
        didSet{
            userDefault.set(self.refreshToken, forKey: saveKey.refreshToken)
            userDefault.synchronize()
        }
    }
    
    
    
    //MARK:- 注册appId
   class func  registerWeChat(){
        WeChatManager.appId = weChatAppId
        WXApi.registerApp(WeChatManager.appId)
    }
    
    
    //MARK:- 单列
    public static let sharedInstace:WeChatManager = {
        let instace = WeChatManager()
        openId = userDefault.string(forKey: saveKey.openId)
        accessToken = userDefault.string(forKey: saveKey.accessToken)
        return instace
    }()
    
    
    
    //MARK:- 检测是否已经被安装微信了
    class  func isInstalledWeChat() -> Bool{
        return WXApi.isWXAppInstalled()
    }
   
}



// MARK: - 微信回掉WXApiDelegate
extension WeChatManager:WXApiDelegate{
    func onReq(_ req: BaseReq!) {
         
    }
    
    //MARK:-  微信回掉
    func onResp(_ resp: BaseResp!) {
        //如果是授权登录回掉
        if resp.isKind(of: SendAuthResp.self){
          delegate?.weChatManager(WeChatManager.sharedInstace, resp: resp as! SendAuthResp)        
        }
    }



}















