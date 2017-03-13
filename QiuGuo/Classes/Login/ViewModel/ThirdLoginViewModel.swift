//
//  ThirdLoginViewModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/13.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit




class ThirdLoginViewModel: BaseViewModel {
    
    //MARK:- 授权之后的access_token
    var access_token:String!
    //MARK:- 授权之后的openid
    var openid:String!
    //MARK:- 微博授权之后的uid
    var uid:String!
    //MARK:- 第三方登录类型
    var thrirdLoginType:ThirdLoginType = .weChatLogin
    
    
    
    //MARK:- 第三方登录
     func thirdLogin(successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock){
         var urlString = ""
        switch self.thrirdLoginType {
        case .weChatLogin:
             urlString =  AppRootUrl + "/oauth/Wx/wxLogin"
        case .weiboLogin:
            urlString =  AppRootUrl + "/oauth/Qauth/WeiboLogin"
        case .tencentLogin:
             urlString =  AppRootUrl + "/oauth/Qauth/QqLogin"
        }
       
        
        var paramters = ["access_token":self.access_token]
        if self.thrirdLoginType == .weiboLogin{
            paramters["uid"] = self.uid
        }else{
            paramters["openid"] = self.openid
        }
        
        NetworkTool.request(type: .POST, urlString: urlString,paramters: paramters, finishedCallback: { (result) in
            if  let data = result["data"].dictionaryObject{
                let userInfo = UserInfo.init(dict: data)
                if userInfo.saveUserInfo(){
                   successCallBack(result)
                }else{
                    HUDTool.show(showType: .Failure, text: "登录信息保存失败")
                }
            }
        }) { (error) in
            failureCallBack(error)
        }
    
    }
}
