//
//  ThirdLoginView.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/28.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import SVProgressHUD

enum ThirdLoginType{
    case weChatLogin;
    case tencentLogin;
    case weiboLogin;
}




class ThirdLoginView: UIView {
    
    //MARK:- 第三方登录代理
    weak var delegate:LoginViewDelegate?
    
    
    //MARK:- 初始化
   override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    }
    
    
    
    //MARK:- 设置界面
   func setupUI(){
    addSubview(weChatBtn)
    addSubview(tencentBtn)
    addSubview(weiboBtn)
    
    
    //微信
    let width = 120*LayoutWidthScale
    weChatBtn.snp.makeConstraints { (make) in

        make.left.equalTo(218*LayoutWidthScale)
        make.top.bottom.equalTo(weChatBtn.superview!)
        make.width.equalTo(width)
        
        
    }
    
    //分隔符
    let separator1 = createSeparator()
    addSubview(separator1)
    separator1.snp.makeConstraints { (make) in
         make.left.equalTo(weChatBtn.snp.right).offset(56*LayoutWidthScale)
        make.centerY.equalTo(weChatBtn)
        make.width.height.equalTo(30*LayoutWidthScale)
    }


    //QQ
    tencentBtn.snp.makeConstraints { (make) in
        make.centerY.width.height.equalTo(weChatBtn)
      
        make.left.equalTo(separator1.snp.right).offset(56*LayoutWidthScale)
        
    }
    
    //分隔符
    let separator2 = createSeparator()
    addSubview(separator2)
    separator2.snp.makeConstraints { (make) in
        make.left.equalTo(tencentBtn.snp.right).offset(56*LayoutWidthScale)
       make.centerY.width.height.equalTo(separator1)
    }

    
    

    //微博
    weiboBtn.snp.makeConstraints { (make) in
        make.centerY.width.height.equalTo(weChatBtn)
        make.left.equalTo(separator2.snp.right).offset(56*LayoutWidthScale)
    
    
    }

    }
    
    
    
    //MARK:- 微信
    fileprivate lazy var weChatBtn:UIButton = UIButton(title: "", imageName: "icon_weixin.png", target: self, selector: #selector(weChatLogin), font: nil, titleColor: nil)
    
    //MARK:- QQ
    fileprivate lazy var tencentBtn:UIButton = UIButton(title: "", imageName: "icon_qq.png", target: self, selector: #selector(tencentLogin), font: nil, titleColor: nil)
    
    //MARK:- weibo
    fileprivate lazy var weiboBtn:UIButton = UIButton(title: "", imageName: "icon_weibo.png", target: self, selector: #selector(weiboLogin), font: nil, titleColor: nil)
    
    
    //MARK:- 微信登录
    func weChatLogin(){
       
      delegate?.loginView!(self, loginType:0)
    
    }
    
    
     //MARK:- 腾讯QQ登录
    func tencentLogin(){
        printLog(message:  #function)
          SVProgressHUD.showInfo(withStatus: "抱歉!暂未开通此功能")
        
    }
    
     //MARK:- 微博登录
    func weiboLogin(){
        printLog(message:  #function)
          SVProgressHUD.showInfo(withStatus: "抱歉!暂未开通此功能")
        
    }
    
    
    
    //MARK:- 创建第三方登录按钮分隔符
    func createSeparator() -> UIImageView {
        let imageView = UIImageView.init(image: UIImage(named:"line"))
    
        return imageView
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
    
    
    
     
}
