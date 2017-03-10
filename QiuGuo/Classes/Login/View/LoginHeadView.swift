//
//  LoginHeadView.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/28.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import SVProgressHUD

enum LoginProfileType {
    case passwordLogin;
    case codeLogin;
    case register
}



class LoginHeadView: UIView {
    
    weak var delegate:LoginViewDelegate?{
        didSet{
        
          thirdLoginView.delegate = delegate
        }
    
    
    }
    
    let left = 141 * LayoutWidthScale
    let right = 155 * LayoutWidthScale
    /// 验证码倒计时间
    var seconds = 60
    
    //MARK:- 登录类型判断
    var loginType:LoginProfileType = LoginProfileType.passwordLogin
        {
        didSet{

            for view in self.subviews{
                view.removeFromSuperview()
            }
           setupUI(loginType: loginType)
            link?.invalidate()
        }

    }
    
    //MARK:- 记录前一个登录的方式
    var preLoginType:LoginProfileType = LoginProfileType.passwordLogin
    
    
   

    
    //MARK:- 初始化
    convenience init(loginType:LoginProfileType){
        self.init(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        setupUI(loginType: loginType)
        //添加点击
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEdit)))
        
        phoneInput.textFiled.text = "15521377654"
    
    }
    
    
    
    //MARK:- 设置界面
    func setupUI(loginType:LoginProfileType) {
        setupUI()
        switch loginType {
        case LoginProfileType.passwordLogin:
            setupPasswordLogin()
        case LoginProfileType.codeLogin:
            setupCodeLogin()
        case LoginProfileType.register:
            setupRegisterLogin()   
        }
        
    }
    
    
    //MARK:- 设置界面
    func setupUI() {
        //取消按钮
        addSubview(cancelBtn)
        cancelBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(cancelBtn.superview!).offset(20)
            make.top.equalTo(cancelBtn.superview!).offset(20)
            make.width.height.equalTo(30)
        }
        
        //登录注册按钮
        addSubview(loginOrRegisterBtn)
        loginOrRegisterBtn.snp.remakeConstraints { (make) in
            make.right.equalTo(loginOrRegisterBtn.superview!).offset(-20)
            make.top.equalTo(cancelBtn)
        }
        
        //登录提示
        addSubview(loginTitleLabel)
        loginTitleLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(loginTitleLabel.superview!)
            make.top.equalTo(cancelBtn.snp.bottom).offset(160*LayoutHeightScale)
        }
        
        
        
        
        //同意协议提示框
        addSubview(agreeProtocalLabel)
        agreeProtocalLabel.snp.remakeConstraints { (make) in
            make.bottom.equalTo(agreeProtocalLabel.superview!).offset(-66*LayoutHeightScale)
            make.centerX.equalTo(agreeProtocalLabel.superview!)
        }
        
        //第三方登录
        addSubview(thirdLoginView)
        thirdLoginView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(thirdLoginView.superview!)
            make.bottom.equalTo(agreeProtocalLabel.snp.top).offset(-63*LayoutHeightScale)
            make.height.equalTo(120*LayoutHeightScale)
        }
    }
    

    
    
    //MARK:- 布局密码登录界面界面
    func setupPasswordLogin(){
        loginTitleLabel.text = "账号登录"
        doneBtn.setTitle("登录", for: .normal)
        
        
        //电话输入框
        addSubview(phoneInput)
        phoneInput.snp.remakeConstraints { (make) in
            make.left.equalTo(phoneInput.superview!).offset(left)
            make.right.equalTo(phoneInput.superview!).offset(-right)
            make.height.equalTo(100*LayoutHeightScale)
            make.top.equalTo(loginTitleLabel.snp.bottom).offset(270*LayoutHeightScale)
            
        }
        
        
        
        //密码登录框
        addSubview(passwordInput)
        passwordInput.snp.remakeConstraints { (make) in
            make.top.equalTo(phoneInput.snp.bottom).offset(50 * LayoutHeightScale)
            make.left.right.height.equalTo(phoneInput)
        }
        
        //验证码登录
        addSubview(changeLoginBtn)
        changeLoginBtn.snp.remakeConstraints { (make) in
             make.left.equalTo(phoneInput.undLine)
            make.top.equalTo(passwordInput.snp.bottom).offset(67*LayoutHeightScale)
        }
        
        //忘记密码
        addSubview(forgetPasswordBtn)
        forgetPasswordBtn.snp.remakeConstraints { (make) in
             make.right.equalTo(phoneInput)
            make.top.centerY.equalTo(changeLoginBtn)
        }
        
        //登录按钮
        addSubview(doneBtn)
        doneBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(changeLoginBtn.snp.bottom).offset(73*LayoutHeightScale)
            make.left.equalTo(156*LayoutHeightScale)
            make.right.equalTo(-154*LayoutHeightScale)
        }

        
    }
    
    //MARK:- 设置验证码登录界面
    func setupCodeLogin() {
        loginTitleLabel.text = "账号登录"
        doneBtn.setTitle("登录", for: .normal)

        
        //电话输入框
        addSubview(phoneInput)
        phoneInput.snp.remakeConstraints { (make) in
            make.left.equalTo(phoneInput.superview!).offset(left)
            make.right.equalTo(phoneInput.superview!).offset(-right)
            make.height.equalTo(100*LayoutHeightScale)
            make.top.equalTo(loginTitleLabel.snp.bottom).offset(270*LayoutHeightScale)
            
        }
        
        
        
        //验证码登录框
        addSubview(codeInput)
        codeInput.snp.remakeConstraints { (make) in
            make.top.equalTo(phoneInput.snp.bottom).offset(50 * LayoutHeightScale)
            make.left.right.height.equalTo(phoneInput)
        }
        
        //验证码登录
        addSubview(changeLoginBtn)
        changeLoginBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(phoneInput.undLine)
            make.top.equalTo(codeInput.snp.bottom).offset(67*LayoutHeightScale)
        }
        
        //忘记密码
        addSubview(forgetPasswordBtn)
        forgetPasswordBtn.snp.remakeConstraints { (make) in
            make.right.equalTo(phoneInput)
            make.top.centerY.equalTo(changeLoginBtn)
        }
        
        //登录按钮
        addSubview(doneBtn)
        doneBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(changeLoginBtn.snp.bottom).offset(73*LayoutHeightScale)
            make.left.equalTo(156*LayoutHeightScale)
            make.right.equalTo(-154*LayoutHeightScale)
        }

        codeInput.codeButton.addTarget(self, action: #selector(getCode), for: .touchUpInside)
    
      
        
    
    }

    
    
    //MARK:- 设置注册界面
    func setupRegisterLogin() {
        
        loginTitleLabel.text = "注册账号"
        doneBtn.setTitle("下一步", for: .normal)
        
        
        
        //电话输入框
        addSubview(phoneInput)
        phoneInput.snp.remakeConstraints { (make) in
            make.left.equalTo(phoneInput.superview!).offset(left)
            make.right.equalTo(phoneInput.superview!).offset(-right)
            make.height.equalTo(100*LayoutHeightScale)
            make.top.equalTo(loginTitleLabel.snp.bottom).offset(270*LayoutHeightScale)
            
        }
        
      
        
        addSubview(settingLoginPassword)
        settingLoginPassword.snp.remakeConstraints { (make) in
            make.top.equalTo(phoneInput.snp.bottom).offset(50*LayoutHeightScale)
            make.left.right.height.equalTo(phoneInput)
        }
        
        addSubview(codeInput)
        codeInput.snp.remakeConstraints { (make) in
            make.top.equalTo(settingLoginPassword.snp.bottom).offset(50*LayoutHeightScale)
            make.left.right.height.equalTo(settingLoginPassword)
        }
        codeInput.codeButton.addTarget(self, action: #selector(getCode), for: .touchUpInside)
        

        
        //登录按钮
        addSubview(doneBtn)
        doneBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(codeInput.snp.bottom).offset(120*LayoutHeightScale)
            make.left.equalTo(156*LayoutHeightScale)
            make.right.equalTo(-154*LayoutHeightScale)
        }

    }
    
    //MARK:- 创建取消按钮
    fileprivate lazy var cancelBtn:UIButton = UIButton(title: "", imageName: "icon_close.png", target: self, selector: #selector(LoginHeadView.cancel), font: nil, titleColor: nil)
    
    //MARK:- 创建登录／注册按钮
    fileprivate lazy var loginOrRegisterBtn:UIButton = UIButton(title: "注册", imageName: "", target: self, selector: #selector(LoginHeadView.clickLoginOrRegister), font: UIFont.systemFont(ofSize: DEFAULTFONTSIZE), titleColor: DEFAUlTFONTCOLOR)
    //MARK:- 创建登录提示title
    fileprivate lazy var loginTitleLabel:UILabel = UILabel(text: "账号登录", font: UIFont.systemFont(ofSize: 21), textColor: DEFAUlTFONTCOLOR, textAlignment: .center)
    //MARK:- 创建电话输入框
    fileprivate lazy var phoneInput:LoginInputView = LoginInputView(imageName: "icon_number.png", placeHolder: "(中国+86)输入手机号码", inputType:LoginInputType.phoneInput)
    //MARK:- 创建密码输入框
    fileprivate lazy var passwordInput:LoginInputView = LoginInputView(imageName: "icon_password.png", placeHolder: "请输入密码",  inputType:LoginInputType.passWordInput)
    //MARK:- 创建设置登录密码框
    fileprivate lazy var settingLoginPassword:LoginInputView = LoginInputView(imageName: "icon_password.png", placeHolder: "设置登录密码", inputType: LoginInputType.settingPassWordInput)
    //MARK:- 创建验证码输入框
    fileprivate lazy var codeInput:LoginInputView = LoginInputView(imageName: "icon_key.png", placeHolder: "请输入验证码",  inputType:LoginInputType.codeInput)
    //MARK:- 创建切换登录模式
    fileprivate lazy var changeLoginBtn:UIButton = UIButton(title: "验证码登录", imageName: nil, target: self, selector: #selector(changeLoginMode), font: UIFont.systemFont(ofSize: 14.5), titleColor: UIColor(hexString: "#666666"))
    //MARK:- 忘记密码
    fileprivate lazy var forgetPasswordBtn:UIButton = UIButton(title: "忘记密码", imageName: nil, target: self, selector: #selector(forgetPassword), font: UIFont.systemFont(ofSize: 14.5), titleColor: UIColor(hexString: "#666666"))
    //MARK:- 创建OK按钮
    fileprivate lazy var doneBtn:UIButton = UIButton(title: "登录",backImageName:"btn_login_n.png",  highlightedImageName:"btn_login_h.png", target: self, selector: #selector(done), font: UIFont.systemFont(ofSize: DEFAULTFONTSIZE), titleColor: DEFAUlTFONTCOLOR)
    
    //MARK:- 第三方登录试图.
    fileprivate lazy var thirdLoginView:ThirdLoginView = ThirdLoginView()
    
    //MARK:- 创建同意协议label
    fileprivate lazy var agreeProtocalLabel:UILabel = UILabel(text: "注册即代表同意球友科技服务条款和隐私条款", font: UIFont.systemFont(ofSize: 13), textColor: UIColor(hexString: "#b7b8bc")!, textAlignment: .center)
    //MARK:- 提示框
    fileprivate lazy var hintLabel:UILabel = UILabel(text: "", font: UIFont.systemFont(ofSize: 14.5), textColor: UIColor.init(hexString: "#2fc381"), textAlignment: .left)
   
    
  
    
    
    //MARK:- 点击右上角注册／登录按钮相应事件
    func clickLoginOrRegister() {
        printLog(message: #function)
        if loginType != LoginProfileType.register {
             loginOrRegisterBtn.setTitle("登录", for: .normal)
            preLoginType = loginType
            loginType = LoginProfileType.register
        }else{
            loginOrRegisterBtn.setTitle("注册", for: .normal)
            loginType = preLoginType
        }
    }
    
    //MARK:- 取消按钮响应事件
    func cancel() {
        printLog(message:  #function)
        
       link?.invalidate()
        delegate?.loginView!(self, clickCancelBtn: cancelBtn)
    }
    
    //MARK:- 切换登录模式
    func changeLoginMode(){
         printLog(message:  #function)
        
        if loginType == LoginProfileType.passwordLogin{
            loginType = LoginProfileType.codeLogin

            changeLoginBtn.setTitle("密码登录", for: .normal)
        }else{
            loginType = LoginProfileType.passwordLogin

            changeLoginBtn.setTitle("验证码登录", for: .normal)

        }

    }
    
    //MARK:- 忘记密码
    func forgetPassword() {
        printLog(message:  #function)
        
          SVProgressHUD.showInfo(withStatus: "抱歉!暂未开通此功能")
        
        
        
    }
    
    //MARK:- ok点击事件
    func done() {
         printLog(message:  #function)
  
        guard isPhoneNumber(number: phoneInput.textFiled.text!) else {
            return
        }
      
        
        let profile = LoginProfile()
        profile.loginType = loginType
        profile.phoneNumber = phoneInput.textFiled.text
        
        if loginType == LoginProfileType.register {
            
            if settingLoginPassword.textFiled.text?.characters.count == 0 {
                hint("请设置登录密码", isError: true)
                settingLoginPassword.textFiled.becomeFirstResponder()
                return
            }
            
            if codeInput.textFiled.text?.characters.count == 0 {
                hint("请填写验证码", isError: true)
                codeInput.textFiled.becomeFirstResponder()
                return
            }
             profile.password = settingLoginPassword.textFiled.text
             profile.codeNum = codeInput.textFiled.text

           delegate?.loginView!(self, clickNextRegister: doneBtn, loginProfile: profile)
        }else {
            
            if(loginType == LoginProfileType.passwordLogin){
                profile.password = passwordInput.textFiled.text
                if profile.password?.characters.count == 0 {
                    hint("密码不能为空", isError: true)
                    return
                }
            }else {
                 profile.codeNum = codeInput.textFiled.text
                if profile.codeNum?.characters.count == 0 {
                    hint("验证码不能为空", isError: true)
                    return
                }

            }
            delegate?.loginView!(self, loginProfile:profile)
           

        }
    }
    
    
    
    //MARK:- 结束编辑
    func endEdit(){
        self.endEditing(true)
    
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public var link : CADisplayLink?
    
    
    
    
    
    
    //MARK:- 发送验证码之后倒计时更新界面
    func update(){
        print("delink is start")
        
        if(seconds<=0){ //倒计时结束，关闭
            
            codeInput.codeButton.isUserInteractionEnabled = true
            codeInput.codeButton.backgroundColor = THEMECOLOR
            codeInput.codeButton.setTitleColor(UIColor.white, for: .normal)
            codeInput.codeButton.setTitle("获取验证码", for:UIControlState())
            
            link?.invalidate()
            seconds = 60
            
        }else{
            
            //设置界面的按钮显示 根据自己需求设置
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(1)
            codeInput.codeButton.setTitleColor(PLACEHOLDERCOLOR, for:UIControlState())
            codeInput.codeButton.setTitle("\(seconds)秒后重发", for:UIControlState())
            codeInput.codeButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
            UIView.commitAnimations()
            codeInput.codeButton.isUserInteractionEnabled = false
        }
        seconds -= 1
    }
    
    
    /// 点击"发送验证码"按钮
    func getCode() {
        
        if isPhoneNumber(number: phoneInput.textFiled.text!){
        
            codeInput.codeButton.isUserInteractionEnabled = false
            
            delegate?.loginView!(self, getCodeWithPhoneNumber: phoneInput.textFiled.text!)

            codeInput.codeButton.backgroundColor = UIColor.white
            link = CADisplayLink(target: self, selector: #selector(update))
            link?.frameInterval = 30
            link?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            link?.isPaused = true
            
         
            hint("", isError: false)

        
        }
     
        
    }
    
    
    //MARK:- 销毁定时器
    deinit {
       link?.invalidate()
    }

    
    
    //提示
    func hint(_ text:String,isError:Bool) {
        if hintLabel.superview == nil {
            addSubview(hintLabel)
            hintLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(loginTitleLabel.snp.bottom).offset(174*LayoutHeightScale)
                make.left.equalTo(158*LayoutHeightScale)
            })
        }
        
      
         hintLabel.text = text
        if isError {
             hintLabel.textColor = UIColor.red
        }else{
        
             hintLabel.textColor = UIColor.init(hexString: "#2fc381")
        }
   
    }
    
    //MARK:- 验证电话号码是否正确
    func isPhoneNumber(number:String) -> Bool {
        if LoginProfile.isPhoneNumber(number){
        
           return true
        }
        
        hint("请输入正确的手机号码", isError: true)
        return false
    }
   
}







