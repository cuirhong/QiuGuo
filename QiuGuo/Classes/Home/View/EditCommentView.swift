//
//  EditCommentView.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/23.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

protocol EditCommentViewDelegate:NSObjectProtocol{
    func editCommentView(_ editCommentView:EditCommentView,sendCommentText:String)
}


class EditCommentView: BaseView {
    
    //MARK:- 编辑评论代理 
    weak var delegate:EditCommentViewDelegate?
    
    //MARK:- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(hexString: "#f2f2f2")
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyborldFrameDidChange), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
       
    }
    
   //MARK:- 布局
    private func setupUI(){
        
        addSubview(sendCommentBtn)
        sendCommentBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-50*LayoutWidthScale)
            make.bottom.equalTo(-50*LayoutHeightScale)
            make.height.equalTo(84*LayoutHeightScale)
            make.width.equalTo(154*LayoutWidthScale)
        }
        
        addSubview(editTextView)
        editTextView.snp.makeConstraints { (make) in
            make.top.equalTo(50*LayoutHeightScale)
            make.left.equalTo(50*LayoutWidthScale)
            make.bottom.equalTo(sendCommentBtn)
            make.right.equalTo(sendCommentBtn.snp.left).offset(-30*LayoutWidthScale)
        }
        
    
    }
    
    //MARK:- 发送评论
    @objc private func sendComment(){
        printData(message:  #function)
        guard editTextView.text.isEmpty || editTextView.text == "" else {
            delegate?.editCommentView(self, sendCommentText: editTextView.text)
            return
        }
       

    }
    
    //MARK:- 键盘的高度已经发生了变化
    @objc private func keyborldFrameDidChange(notification:Notification){

        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue{
       
            let frame = value.cgRectValue
            let frameY = frame.size.height
          
            if frame.origin.y < ScreenHeight {//键盘弹起
               self.transform = CGAffineTransform(translationX: 0, y: -frameY)
            }else{
              self.transform  = CGAffineTransform.identity
            }
          
        }
    
    
    }
    
    
    //MARK:- 创建评论输入框
    fileprivate lazy var editTextView:UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.init(hexString: "#b3b3b3")?.cgColor
        textView.clipsToBounds = true
        textView.delegate = self
        return textView
    
    }()

    
    
    //MARK:- 创建发送评论按钮
    fileprivate lazy var sendCommentBtn:UIButton = UIButton(title: "评论", backgroundColor: THEMECOLOR, target: self, selector: #selector(sendComment), font: UIFont.font(psFontSize: 40), titleColor: UIColor.init(hexString: "#ffffff"))
    
    
    //MARK:- 初始化失败
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    deinit {
         NotificationCenter.default.removeObserver(self )
    }
    
    
    
    
    
    
    
}


extension EditCommentView:UITextViewDelegate{

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true 
    }




}

