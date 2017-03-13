//
//  BindPhoneViewModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/13.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class BindPhoneViewModel: BaseViewModel {
    //MARK:- 手机号码
    var PhoneNumber:String = ""
    //MARK:- 绑定验证码
    var Captcha:String = ""
    //MARK:- 昵称是否重复
    var isRepeat:Int = 0
    
    
    //MARK:- 第三方绑定手机号码
    func bindPhone(successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock){
        let urlString = AppRootUrl + "/oauth/Qauth/bindPhoneNumber"
        let paratemers = ["UserID":String(describing: UserInfo.loadAccount()?.UserID),"UserToken":String(describing: UserInfo.loadAccount()?.UserToken),"PhoneNumber":self.PhoneNumber,"Captcha":self.Captcha,"isRepeat":String(describing: self.isRepeat)]
        NetworkTool.request(type: .POST, urlString: urlString,paramters: paratemers, finishedCallback: { (result) in
            UserInfo.loadAccount()?.UserID = result["data"]["UserID"].intValue
            UserInfo.loadAccount()?.UserToken = result["data"]["UserToken"].stringValue
             UserInfo.loadAccount()?.isReal = result["data"]["isReal"].intValue
            UserInfo.loadAccount()?.isPhone = 1
            successCallBack(result)
        }) { (error) in
            failureCallBack(error)
        }
    
    
    
    
    
    
    }
    
    
    
    
    
    
    
    
    



}
