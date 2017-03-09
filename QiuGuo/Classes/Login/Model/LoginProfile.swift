//
//  LoginProfile.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/28.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class LoginProfile: NSObject {
    
    /// 登录类型
    var loginType:LoginProfileType?
  
    /// 手机号
    var phoneNumber : String? = ""
    /// 验证码
    var codeNum : String? = ""
    /// 密码
    var password : String? = ""
    
    /// 判断是否是手机号
   class  func isPhoneNumber(_ num: String) -> Bool {
    
    let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
    let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
    let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
    let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
    let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
    let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
    let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
    let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
    if ((regextestmobile.evaluate(with: num) == true)
        || (regextestcm.evaluate(with: num)  == true)
        || (regextestct.evaluate(with: num) == true)
        || (regextestcu.evaluate(with: num) == true))
    {
        return true
    }
    else
    {
        return false
    }
    }
   
}

