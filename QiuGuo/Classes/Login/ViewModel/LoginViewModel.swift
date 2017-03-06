//
//  LoginViewModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/2.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class LoginViewModel: BaseViewModel {
    
    //MARK:- 获取验证码
    class func getCode(phoneNumber:Int,finishedCallback : @escaping (_ result: Any) -> ()){
        
        let urlString = AppRootUrl +  "/oauth/Captcha/loginCaptcha"
        NetworkTool.request(type: .POST, urlString: urlString, paramters: ["PhoneNumber":phoneNumber], finishedCallback: { (result) in
            finishedCallback(result)
        }) { (error) in
            
        }
      
        
    }
    
    
    //MARK:- 登录
    class func login(_ loginProfile:LoginProfile ,finishedCallback : @escaping (_ result: Any) -> ()){
     //http://api.qiu.com/oauth/Qauth/login
       
        if loginProfile.loginType == LoginProfileType.passwordLogin {
             let urlString = AppRootUrl +  "/oauth/Qauth/login"
            NetworkTool.request(type: .POST, urlString: urlString, paramters: ["PhoneNumber":loginProfile.phoneNumber!,"Password":String.md5String(loginProfile.password!)], finishedCallback: { (result) in
                 finishedCallback(result)
            }, failureCallback: { (error) in
                
            })
          
        }else if loginProfile.loginType == LoginProfileType.codeLogin{
        
            let urlString = AppRootUrl +  "/oauth/Qauth/CaptchaLogin"
            NetworkTool.request(type: .POST, urlString: urlString, paramters: ["PhoneNumber":loginProfile.phoneNumber!,"Captcha":loginProfile.codeNum!], finishedCallback: { (result) in
                
            }, failureCallback: { (error) in
                
            })
           
        }

    }
    
    
    
    
    //MARK:- 注册
    class func register(_ loginProfile:LoginProfile,finishedCallback : @escaping (_ result: Any) -> ()){
        let urlString = AppRootUrl +  "/oauth/Qauth/register"
        NetworkTool.request(type: .POST, urlString: urlString, paramters: ["PhoneNumber":loginProfile.phoneNumber!,"Password":String.md5String(loginProfile.password!),"Captcha":loginProfile.codeNum!], finishedCallback: { (result) in
             finishedCallback(result)
        }) { (error) in
            
        }
    }
    
    
    //MARK:- 上传图片
    class func upload(image:UIImage,finishedCallback : @escaping (_ result: Any) -> ()) {
        let urlString = AppRootUrl +  "/oauth/Qauth/imageUpload"
        //将image转成Data
        var imageData:Data? = UIImagePNGRepresentation(image)
        if imageData == nil {
            imageData = UIImageJPEGRepresentation(image, 0.5)
        }
//        let imageStr:String? = String(data: imageData!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        

        printData(message: UserInfo.loadAccount()?.UserToken)
        
        NetworkTool.request(type: .POST, urlString: urlString, paramters: ["UserID":UserInfo.loadAccount()?.UserID,"UserToken":UserInfo.account?.UserToken,"Headimg":imageData!], finishedCallback: { (result) in
             finishedCallback(result)
        }) { (error) in
            
        }
        
    }
    
    
    
    //MARK:- 完善个人信息
    /**
     完善个人信息
     
     - parameter user:             用户信息模型
     - parameter headimg:          文件流
     - parameter finishedCallback: 闭包
     */
    class func finshedUserInfo(user:UserInfo,headimg:String, finishedCallback : @escaping (_ result: Any) -> ()){
    
        let urlString = AppRootUrl + "/oauth/Qauth/update"
        NetworkTool.request(type: .POST, urlString: urlString, paramters: ["UserID":user.UserID,"UserToken":user.UserToken,"Nickname":user.Nickname,"Headimg":headimg,"Sex":user.Sex,"isReal":user.isReal], finishedCallback: { (result) in
            finishedCallback(result)
        }) { (error) in
            
        }
      }
    
    
    
    
     
}





