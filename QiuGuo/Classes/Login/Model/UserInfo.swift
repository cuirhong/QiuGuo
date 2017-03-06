//
//  UserInfo.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/3.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class UserInfo: NSObject,NSCoding {
    
    
    //MARK:- 用户ID
   dynamic var UserID : Int = -1
    
    //MARK:- 用户token
   dynamic var UserToken : String = ""
    
    //MARK:- 是否完善资料
   dynamic var isReal : Int = -1
    
    //MARK:- 昵称
   dynamic var Nickname:String = ""
    
    //MARK:- 性别
   dynamic var Sex:Int = -1
    
    //MARK:- 头像地址
    dynamic var Headimgurl:String = ""
    
    //MARK:- 个性签名
    dynamic var Signature:String = ""
    
    
    
    init(dict:[String:Any]){
       super.init()
       setValuesForKeys(dict)

    }
    
    
    
    func saveUserInfo()->Bool {
        let filePath = KuserLoginPath
        UserInfo.account = self

       return NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key.isEmpty{
         super.setValue(value, forUndefinedKey: key)
        }
       
    }
    
    
     static var account:UserInfo?
    //读取数据模型，返回值类型一定是可选类型
    class func loadAccount()-> UserInfo? {
        //1.判断是否授权过
        if account != nil {
            return account
        }
        //2.加载授权模型
        account = NSKeyedUnarchiver.unarchiveObject(withFile: KuserLoginPath) as? UserInfo

        return account
    }
    
    
    //判断用户是否登陆过
    class func userLogin()->Bool {
       let isLogin = UserInfo.loadAccount()
        if isLogin == nil{
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: LoginNotificationName), object: nil)
        }
        return UserInfo.loadAccount() != nil
    }

    //退出登录
    class func logout(){
        if UserInfo.userLogin(){
            try! FileManager.default.removeItem(atPath: KuserLoginPath)
            account = nil
        }        
    }
    
    
    
    
    // 归档
    func encode(with aCoder: NSCoder) {
        var count: UInt32 = 0
        guard let ivars = class_copyIvarList(self.classForCoder, &count) else {
            return
        }
        for i in 0 ..< count {
            let ivar = ivars[Int(i)]
            let name = ivar_getName(ivar)
            
            let key = NSString.init(utf8String: name!) as! String
            
            if let value = self.value(forKey: key) {
                aCoder.encode(value, forKey: key)
            }
        }
        // 释放ivars
        free(ivars)
    }
    
    // 反归档
    required init?(coder aDecoder: NSCoder) {
        super.init()
        var count: UInt32 = 0
        guard let ivars = class_copyIvarList(self.classForCoder, &count) else {
            return
        }
        for i in 0 ..< count {
            let ivar = ivars[Int(i)]
            let name = ivar_getName(ivar)
            let key = NSString.init(utf8String: name!) as! String
            if let value = aDecoder.decodeObject(forKey: key) {
                self.setValue(value, forKey: key)
            }
        }
        // 释放ivars
        free(ivars)
    }






}
