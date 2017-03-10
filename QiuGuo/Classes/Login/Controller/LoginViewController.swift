//
//  LoginViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/27.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

/**
 *  登陆协议
 */
@objc
protocol LoginViewDelegate : NSObjectProtocol {
    
    
    //MARK:- 点击取消按钮
    @objc optional func loginView(_ loginHeadView:LoginHeadView,clickCancelBtn:UIButton)
    
    //MARK:- 获取验证码
    @objc optional func loginView(_ loginHeadView:LoginHeadView,getCodeWithPhoneNumber:String)

    

    //MARK:- 点击忘记密码按钮
    @objc optional func loginView(_ loginHeadView:LoginHeadView,clickReviewPassWordBtn:UIButton)
    
    //MARK:- 登录
    @objc optional func loginView(_ loginHeadView:LoginHeadView,loginProfile:LoginProfile)
    
    
    //MARK:- 点击注册下一步按钮
    @objc optional func loginView(_ loginHeadView:LoginHeadView,clickNextRegister:UIButton,loginProfile:LoginProfile )
    
    //MARK:- 注册成功
    @objc optional func loginView(_ loginIsSuccess:Bool)
    
    
  
}



class LoginViewController:  BaseViewController{
    //MARK:- 声明属性
    var bottomScrollView:UIScrollView?
    var loginHeadView:LoginHeadView?
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initData()
        setupUI()
   
    }
    
    
    //MARK:- 初始化
    override func initData() {
        super.initData()
   
        
    }
    
    //MARK:- 设置界面UI
    func setupUI() {
        view.backgroundColor = UIColor.white
        
        //底部滚动试图
        bottomScrollView = UIScrollView.init()
        
        self.view.addSubview(bottomScrollView!)
        bottomScrollView?.snp.makeConstraints({ (make) in
            make.top.right.bottom.left.equalTo((bottomScrollView?.superview)!)
        })
        
        //登录头试图
        loginHeadView = LoginHeadView(loginType: .passwordLogin)
        loginHeadView?.delegate = self
        bottomScrollView?.addSubview(loginHeadView!)
        loginHeadView?.snp.makeConstraints { (make) in
             make.top.left.equalTo((loginHeadView?.superview!)!)
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight)
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginHeadView?.link?.invalidate()
    }
    
    
    deinit {
        loginHeadView?.link?.invalidate()
    }
    

    
   
}



// MARK: - 实现协议方法
extension LoginViewController:LoginViewDelegate{

    //点击取消按钮回调事件
    func loginView(_ loginHeadView: LoginHeadView, clickCancelBtn: UIButton) {
        
        dismiss(animated: true, completion: nil)
       
    }
    
    //注册成功
    func loginView(_ loginIsSuccess: Bool) {
         dismiss(animated: true, completion: nil)
    }
    
    //点击下一步注册按钮
    func loginView(_ loginHeadView: LoginHeadView, clickNextRegister: UIButton, loginProfile: LoginProfile) {
//        let nextRegister = RegisterSecondViewController()
//        self.addChildViewController(nextRegister)
//        self.view.addSubview(nextRegister.view)
//        nextRegister.view.snp.remakeConstraints { (make) in
//            make.left.right.bottom.top.equalTo(nextRegister.view.superview!)
//        }
//        
//
//        return
        
        LoginViewModel.register(loginProfile) {[weak self] (result) in
            
            let json = result as? JSON
            let code = json?["code"]
            if code == 101{
                //手机号码已注册
                loginHeadView.clickLoginOrRegister()
                loginHeadView.hint("手机号码已注册，请登录", isError: true)
            }else if code == 1 {
                if  let data = json?["data"].dictionaryObject{
                    let userInfo = UserInfo.init(dict: data)
                    if userInfo.saveUserInfo(){
                        let nextRegister = RegisterSecondViewController()
                        nextRegister.delegate = self
                        self?.addChildViewController(nextRegister)
                        self?.view.addSubview(nextRegister.view)
                        nextRegister.view.snp.remakeConstraints { (make) in
                            make.left.right.bottom.top.equalTo(nextRegister.view.superview!)
                        }

                        SVProgressHUD.showSuccess(withStatus: "登录成功")
                        
                        
                        
                    }else{
                        printData(message: "登录信息归档失败")
                    }
                }
            }else {
                if let msg = json?["msg"].stringValue{
                    loginHeadView.hint(msg , isError: true)
                    
                }
                
            }
            
        }
    }
 
    
    
    //获取验证码
    func loginView(_ loginHeadView: LoginHeadView, getCodeWithPhoneNumber: String) {
     
        
        LoginViewModel.getCode(phoneNumber:Int(getCodeWithPhoneNumber)!) { (result) in
           
        
            let dict = result as? [String : Any]
            
            let code = dict?["code"] as? Int
            if code == 100{
                //手机号码未注册
              loginHeadView.clickLoginOrRegister()
                loginHeadView.hint("手机号码未注册", isError: true)
            }else{
                 loginHeadView.link?.isPaused = false
                 loginHeadView.hint("验证码已发送至手机:"+getCodeWithPhoneNumber, isError: false)
            }
            
        }
    }
    
    
    
    //登录
    func loginView(_ loginHeadView: LoginHeadView, loginProfile: LoginProfile) {
        
       LoginViewModel.login(loginProfile) {[weak self] (result) in
        let json = result as? JSON
        let code = json?["code"]
        if code == 100{
            //手机号码未注册
            loginHeadView.clickLoginOrRegister()
            loginHeadView.hint("手机号码未注册", isError: true)
        }else if code == 1 {
            if  let data = json?["data"].dictionaryObject{
                let userInfo = UserInfo.init(dict: data)
                if userInfo.saveUserInfo(){
                    SVProgressHUD.showSuccess(withStatus: "登录成功")
                    self?.dismiss(animated: true, completion: nil)
                }else{
                    printData(message: "登录信息归档失败")
                }
            }
        }else {
            if let msg = json?["msg"].stringValue{
            loginHeadView.hint(msg , isError: true)
            
            }
        }
        }        
    }
    
    
 
    
}




