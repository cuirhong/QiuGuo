//
//  MeHeadView.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/3.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit


/// 个人页面的头试图
class MeHeadView:BaseView{
    
    

    //MARK:- 头像底部view
    fileprivate lazy var headBottomView:UIView = UIView()
    //MARK:- 头像
     fileprivate lazy var headImageView:UIImageView = UIImageView(image: UIImage.getImage("avatar_male.png"))
    //MARK:- 头像背景图片
    fileprivate lazy var headBackImageView:UIImageView = UIImageView(image: UIImage.getImage("background.png"))
    //MARK:- 性别
    fileprivate lazy var sexImageView:UIImageView = UIImageView(image: UIImage.getImage("male.png"))
    //MARK:- 昵称
    fileprivate lazy var nickLabel:UILabel = UILabel(text: "登录/注册", font: UIFont.font(psFontSize: 45), textColor: UIColor.init(hexString: "#ffffff"), textAlignment: .left)
    //MARK:- 个人签名
    fileprivate lazy var personalSginLabel:UILabel = UILabel(text: "这个家伙很懒,什么都懒得留", font: UIFont.font(psFontSize: 36), textColor: UIColor.init(hexString: "#ffffff"), textAlignment: .left)
    //MARK:- 右边可以点击进入指示符号
    fileprivate lazy var arrowImageView:UIImageView = UIImageView(image: UIImage.getImage("arrow_r"))
    
    
    //MARK:- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        backgroundColor = THEMECOLOR

    }
    
    
    
    //MARK:- 布局
    func setupUI(){
        
        
        setupHeadView()

        //如果登录过
        if UserInfo.userLogin() {
            addSubview(arrowImageView)
            arrowImageView.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(headBottomView)
                 make.width.height.equalTo(88*LayoutWidthScale)
                make.right.equalTo(-44*LayoutWidthScale)
            })
            addSubview(nickLabel)
            nickLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(137*LayoutHeightScale)
                make.left.equalTo(headBottomView.snp.right).offset(36*LayoutWidthScale)
            })


            if  UserInfo.loadAccount()?.Nickname.characters.count != 0{
             nickLabel.text = UserInfo.loadAccount()?.Nickname
            }else{
             nickLabel.text = "____"
            }
           

            addSubview(personalSginLabel)
            personalSginLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(nickLabel.snp.bottom).offset(24*LayoutHeightScale)
                make.left.equalTo(nickLabel)
            })
            if  UserInfo.loadAccount()?.Signature.characters.count != 0{
            
             personalSginLabel.text = UserInfo.loadAccount()?.Signature
            }else{
                personalSginLabel.text = "这个家伙很懒,什么都懒得留"
            }
            
            
      
            
            
        }else{
            addSubview(nickLabel)
            nickLabel.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(headBottomView)
                make.left.equalTo(headBottomView.snp.right).offset(36*LayoutWidthScale)
                
            })
            nickLabel.text = "登录/注册"
            
        }

    
    }
    
    
    //MARK:- 布局头像试图
    func  setupHeadView() {
    
        addSubview(headBottomView)
        var width:CGFloat = 212*LayoutWidthScale
        headBottomView.snp.remakeConstraints { (make) in
             make.left.equalTo(headBottomView.superview!).offset(68*LayoutWidthScale)
            make.top.equalTo(headBottomView.superview!).offset(80*LayoutHeightScale)
            make.width.height.equalTo(width)
        }
        
        headBottomView.addSubview(headBackImageView)
        headBottomView.addSubview(headImageView)
        headBottomView.addSubview(sexImageView)
        
        
        headBackImageView.layer.cornerRadius = width / 2
        headBackImageView.snp.remakeConstraints { (make) in
            make.top.right.bottom.left.equalTo(headBackImageView.superview!)
        }
        
        let margin:CGFloat = 6
        width -= margin
        
        headImageView.layer.cornerRadius = width / 2
        headImageView.snp.remakeConstraints { (make) in
            make.top.left.equalTo(headImageView.superview!).offset(margin/2)
            make.width.height.equalTo(width)
        }
        
        
        sexImageView.snp.remakeConstraints { (make) in
             make.right.bottom.equalTo(sexImageView.superview!)
            make.width.height.equalTo(66*LayoutWidthScale)
            
        }
  
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}










