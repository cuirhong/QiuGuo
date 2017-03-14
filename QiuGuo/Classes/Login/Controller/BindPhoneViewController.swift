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
        loginHeadView = LoginHeadView(loginType: .passwordLogin)
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
         view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    
}





/// MARK: - 遵守LoginViewDelegate
extension BindPhoneViewController:LoginViewDelegate{
    func loginView(_ loginHeadView: LoginHeadView, clickCancelBtn: UIButton) {
        back()
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









