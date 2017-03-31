//
//  AlertBottomMaskView.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/23.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import Foundation


 enum AlertViewType{
    case UnKnow;
    case Custom;
    case Center;
    case Bottom;
    case Top;
}

struct AlertViewStyle {
    //MARK:- 类型
    var alertType:AlertViewType = .UnKnow
    
    var alertViewFrame:CGRect? = nil
    
    //MARK:- 是否点击触发消失
    var isTapDissmiss:Bool = true
    
    //MARK:- 底部视图颜色
    var bottomBackColor:UIColor? = nil
    
    
}


protocol AlertBottomViewDelegate:NSObjectProtocol {
    //MARK:- 已经消失
     func alertBottomView(_ alertBottomView:AlertBottomView,didDissmiss:Bool)
}

class AlertBottomView: BaseView {
    
    //MARK:- alert的自定义界面
    private var alertView:UIView?
    //MARK:- alertView的frame
    private var alertViewStyle:AlertViewStyle?
    //MARK:- 代理
    weak var delegate:AlertBottomViewDelegate?
    //MARK:- maskView
    private var bottomMaskView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hexString: "#000")
        view.alpha = 0.5
        return view
    
    }()
    
    
    //MARK:- 初始化
    init(alertView:UIView,alertViewStyle:AlertViewStyle) {
        super.init(frame:CGRect.zero)


        self.alertView = alertView
        self.alertViewStyle = alertViewStyle
        
        setupUI()
        if alertViewStyle.isTapDissmiss {
            self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(AlertBottomView.dismiss)))
        }
        
        if alertViewStyle.bottomBackColor != nil  {
          bottomMaskView.backgroundColor = alertViewStyle.bottomBackColor
        }
        
    }
    
    //MARK:- 设置界面
    private func setupUI(){
        addSubview(bottomMaskView)
        addSubview(alertView!)
    }
    
    //MARK:- 显示alert
    func show(){
    
        let keyWindow = UIApplication.shared.keyWindow
        self.frame = (keyWindow?.bounds)!
        bottomMaskView.frame = self.bounds
        keyWindow?.addSubview(self)

    }
    
    //MARK:- 点击mask移除alertView
     @objc private func dismiss(){
        delegate?.alertBottomView(self, didDissmiss: true)
        self.alertView = nil
        self.alertViewStyle = nil
        self.removeFromSuperview()
    }
    
    //MARK:- 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        if alertViewStyle?.alertType == .UnKnow,alertViewStyle?.alertViewFrame != nil {
        
         alertView?.frame = (alertViewStyle?.alertViewFrame)!
        }else if alertViewStyle?.alertType == .Top{
        
          alertView?.frame = CGRect(x: 0, y: 0, width: (alertView?.bounds.size.width)!, height: (alertView?.bounds.size.height)!)
        }else if alertViewStyle?.alertType == .Bottom{
            let height = alertView?.bounds.size.height ?? 0
            let Y = self.bounds.size.height - height
            alertView?.frame = CGRect(x: 0, y: Y, width: alertView?.bounds.size.width ?? 0, height: height)
        
        }else {
          alertView?.center = CGPoint(x: ScreenWidth/2.0, y: ScreenHeight/2.0)
        
        }
    
        
        
    }
    
    //MARK:- 初始化失败
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
}






