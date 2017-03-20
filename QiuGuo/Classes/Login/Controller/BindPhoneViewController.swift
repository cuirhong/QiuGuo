//
//  BindPhoneViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/13.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
/// 绑定手机号码
class BindPhoneViewController: BaseViewController {
    //MARK:-  绑定成功代理
      weak var delegate:LoginViewDelegate?
    
    //MARK:- 绑定手机号码viewModel
    fileprivate lazy var  bindPhoneViewModel:BindPhoneViewModel = BindPhoneViewModel()
    
    //MARK:- 登录headView
    fileprivate  var loginHeadView:LoginHeadView?
    
    
    //MARK:- 加载view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK:- loadData
    override func initData() {
        super.initData()
   
    }
    
    //MARK:- 设置界面
    override func setupView() {
        super.setupView()
        loginHeadView = LoginHeadView(loginType: .bindPhoneNumber)
        loginHeadView?.delegate = self
        view.addSubview(loginHeadView!)
        loginHeadView?.snp.makeConstraints { (make) in
            make.top.left.equalTo((loginHeadView?.superview!)!)
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight)
        }   
    }
    
    //MARK:- 返回
    override func back() {
         UserInfo.logout()   
         view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    
}





/// MARK: - 遵守LoginViewDelegate
extension BindPhoneViewController:LoginViewDelegate{
    //MARK:- 点击取消
    func loginView(_ loginHeadView: LoginHeadView, clickCancelBtn: UIButton) {
        back()
    }
    
    //MARK:- 获取验证码
    func loginView(_ loginHeadView: LoginHeadView, getCodeWithPhoneNumber: String, codeType: CodeType) {
        LoginViewModel.getCode(codeType:codeType, phoneNumber: Int(getCodeWithPhoneNumber)!, successCallBack: { (result) in
            let code = result["code"]
            if code == 1{
                loginHeadView.link?.isPaused = false
                loginHeadView.hint("验证码已发送至手机:"+getCodeWithPhoneNumber, isError: false)
            }else{
                loginHeadView.hint(result["msg"].stringValue, isError: true)
            }
        }) { (error ) in
            HUDTool.show(showType: .Failure, text: error.debugDescription)
        }
    }
    
    //MARK:- 绑定手机号码
    func loginView(_ loginHeadView: LoginHeadView, loginProfile: LoginProfile) {
        if let phoneNumber = loginProfile.phoneNumber,let code = loginProfile.codeNum{
           bindPhoneViewModel.PhoneNumber = phoneNumber
            bindPhoneViewModel.Captcha = code
        }
        
        bindPhoneViewModel.bindPhone(successCallBack: {[weak self] (result) in
            self?.back()
            self?.delegate?.loginView!(true)
        }) { (error) in            
            HUDTool.show(showType: .Failure, text: "绑定手机号失败")
        }
       
       
    }







}









