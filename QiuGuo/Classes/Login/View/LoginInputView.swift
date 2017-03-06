//
//  LoginInputView.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/28.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit


enum LoginInputType {
    case phoneInput;
    case passWordInput;
    case settingPassWordInput;
    case codeInput;
}


class LoginInputView: UIView {
    
    
  
   
    var inputType:LoginInputType?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    convenience init(imageName: String, placeHolder: String, inputType:LoginInputType)
    {
        self.init(frame: CGRect.zero)
      
        let image = UIImage(named: imageName)
        iconView.image = image
        textFiled.placeholder = placeHolder
       
        
        
        clearBtn.isHidden = true
        codeButton.isHidden = true
        
        
        
        if inputType == LoginInputType.phoneInput {
            textFiled.delegate = self
            
            textFiled.keyboardType = .numberPad
            
            clearBtn.snp.makeConstraints({ (make) in
                make.right.equalTo(clearBtn.superview!)
                make.centerY.equalTo(iconView)
                make.width.height.equalTo(88 * LayoutWidthScale )
                
            })
            
            textFiled.snp.makeConstraints({ (make) in
                make.right.equalTo(clearBtn.snp.left)
                make.bottom.equalTo(undLine.snp.top).offset(-45 * LayoutWidthScale)
                make.left.equalTo(iconView.snp.right).offset(38 * LayoutWidthScale)
                make.top.equalTo(iconView.snp.top).offset(5)
            })
 
        }
        
        
        if inputType == LoginInputType.passWordInput {
            textFiled.snp.makeConstraints({ (make) in
                make.right.equalTo(undLine)
                make.bottom.equalTo(undLine.snp.top).offset(-45 * LayoutWidthScale)
                make.left.equalTo(iconView.snp.right).offset(38 * LayoutWidthScale)
                make.top.equalTo(iconView.snp.top).offset(5)
            })
            //设置呈现密码输入形式
            
            textFiled.isSecureTextEntry = true
            

        }
        
        if inputType == LoginInputType.settingPassWordInput {
            
            clearBtn.snp.makeConstraints({ (make) in
                make.right.equalTo(clearBtn.superview!)
                make.centerY.equalTo(iconView)
                make.width.height.equalTo(88 * LayoutWidthScale )
                
            })
            
            textFiled.snp.makeConstraints({ (make) in
                make.right.equalTo(clearBtn.snp.left)
                make.bottom.equalTo(undLine.snp.top).offset(-45 * LayoutWidthScale)
                make.left.equalTo(iconView.snp.right).offset(38 * LayoutWidthScale)
                make.top.equalTo(iconView.snp.top).offset(5)
            })
            //设置呈现密码输入形式
            textFiled.isSecureTextEntry = true
            textFiled.placeholder = "设置登录密码"

        }
        
 
        if inputType == LoginInputType.codeInput {
            codeButton.isHidden = false
        
            codeButton.snp.makeConstraints({ (make) in
                make.centerY.equalTo(textFiled)
                make.right.equalTo(codeButton.superview!)
                make.width.equalTo(90)
                make.height.equalTo(77*LayoutHeightScale)
                
            })
            
            textFiled.snp.makeConstraints({ (make) in
                make.right.equalTo(codeButton.snp.left)
                make.bottom.equalTo(undLine.snp.top).offset(-45*LayoutWidthScale)
                make.left.equalTo(iconView.snp.right).offset(38 * LayoutWidthScale)
                make.top.equalTo(iconView.snp.top).offset(5)
            })

            
        }
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- 设置界面
    fileprivate func setup()
    {

        // 添加子控件
        
        addSubview(undLine)
        addSubview(iconView)
        addSubview(textFiled)
        addSubview(codeButton)
        addSubview(clearBtn)
 
        // 布局子控件
        iconView.snp.makeConstraints { (make) in
             make.top.left.equalTo(iconView.superview!)

            let width = 64 * LayoutWidthScale
            make.width.height.equalTo(width)
        }
        
        
        undLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(undLine.superview!)
            make.height.equalTo(0.5)
            make.left.equalTo(undLine.superview!).offset(10)
            make.right.equalTo(undLine.superview!)
        }
        
   
       
    }

    
    //MARK:-  底部的分割线
    open  lazy var undLine : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.black
        return label
    }()
    
    //MARK:- 图标
    fileprivate lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "safe"))
   //MARK:- 输入框
    public  lazy var textFiled : UITextField = {
        let textFiled = UITextField()
         textFiled.keyboardType = .default
        
        textFiled.placeholder = "(中国+86)输入手机号码"
        textFiled.font = UIFont.systemFont(ofSize: DEFAULTFONTSIZE)
        // 设置placeholder的颜色(一定要在placeholder设置后才会生效)
        textFiled.setValue(PLACEHOLDERCOLOR, forKeyPath: "_placeholderLabel.textColor")
        // 设置placeholder的字体
        textFiled.setValue(UIFont.systemFont(ofSize: DEFAULTFONTSIZE), forKeyPath: "_placeholderLabel.font")
        return textFiled
    }()
    
   //MARK:- 删除输入内容按钮
    fileprivate lazy var clearBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("x", for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: DEFAULTFONTSIZE)
        btn.setTitleColor(DEFAUlTFONTCOLOR, for: UIControlState())
        btn.addTarget(self, action: #selector(LoginInputView.clearContent), for: .touchUpInside)
        return btn
    }()
    
    //MARK:- 发送验证码提示按钮
    public lazy var codeButton : UIButton = {
        let btn:UIButton = UIButton(title: "获取验证码", imageName: nil, target: self, selector: nil, font: UIFont.systemFont(ofSize: 14), titleColor: UIColor.init(hexString: "#ffffff"))
        btn.backgroundColor = THEMECOLOR
    
 
        return btn
    }()
    
    // MARK: - 删除输入内容按钮被电击
    func clearContent() {
        printLog(message: #function)
        
        textFiled.text = ""
        clearBtn.isHidden = true
        
    }

    
       
    
    
}


// MARK: - 实现协议方法
extension LoginInputView:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        
        //删除
        if string.isEmpty && textFiled.text!.characters.count == 1 {
            
            if textFiled.text!.characters.count == 1 {
                 clearBtn.isHidden = true
            }else{
                
                clearBtn.isHidden = false
            }
            
        }else{
            //输入操作
            let text = textFiled.text! + string

            if (text.isEmpty) {
                clearBtn.isHidden = true
            }else{
                
                clearBtn.isHidden = false
            }
        
        }
        
    
        
        
        
        return true

        
    }
    


}









