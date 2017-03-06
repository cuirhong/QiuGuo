//
//  RegisterSecondViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/2.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import SwiftyJSON


class RegisterSecondViewController: BaseViewController {
    
    weak var delegate:LoginViewDelegate?

    var heightScale = ScreenHeight / 1920
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupUI()
        
        
    }
    
    //MARK:- 初始化数据
    override func  initData() {
        super.initData()    
        nickTextField = createTextField(text: "", placeHolder: "请输入昵称", textColr: DEFAUlTFONTCOLOR, placeHolderColor: DEFAUlTFONTCOLOR, fontSize: 14.5)
        sexTextField = createTextField(text: "", placeHolder: "请选择性别", textColr: DEFAUlTFONTCOLOR, placeHolderColor: DEFAUlTFONTCOLOR, fontSize: 14.5)
        sexTextField?.delegate = self
        nickUndline = createUndline()
        sexUndline = createUndline()
        
    }
    
    
    //MARK:- 设置界面
    func setupUI() {
        
        
        view.addSubview(backBtn)
        view.addSubview(titleHintLabel)
         view.addSubview(headImageView)
         view.addSubview(uploadHeadHintLabel)
        
         view.addSubview(hintLabel)
        view.addSubview(nickTextField!)
        view.addSubview(nickUndline!)
         view.addSubview(sexTextField!)
        view.addSubview(sexUndline!)
         view.addSubview(hintSexNoReviewLabel)
         view.addSubview(doneBtn)
         view.addSubview(agreeProtocalLabel)
        
        
        
        backBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(27)
            make.left.equalTo(38*heightScale)
            make.width.height.equalTo(88*LayoutWidthScale)
            
        }
        
 
        titleHintLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(48)
            make.centerX.equalTo(titleHintLabel.superview!)
  
                       
        }
        headImageView.snp.remakeConstraints { (make) in
            make.top.equalTo(titleHintLabel.snp.bottom).offset(122*heightScale)
            make.width.height.equalTo(180*heightScale)
            make.centerX.equalTo(headImageView.superview!)
            
        }
        
        uploadHeadHintLabel.snp.remakeConstraints { (make) in
             make.centerX.equalTo(headImageView.superview!)
            make.top.equalTo(headImageView.snp.bottom).offset(26*heightScale)
   
        }
        hintLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(uploadHeadHintLabel.snp.bottom).offset(48*heightScale)
            make.centerX.equalTo(hintLabel.superview!)
            make.height.equalTo(uploadHeadHintLabel)
            
        }
        nickTextField?.snp.remakeConstraints { (make) in
            make.top.equalTo(hintLabel.snp.bottom).offset(41*heightScale)
            make.left.equalTo((nickTextField?.superview!)!).offset(158*heightScale)
             make.right.equalTo((nickTextField?.superview!)!).offset(-158*heightScale)
            
        }
        nickUndline?.snp.remakeConstraints { (make) in
           make.left.right.equalTo(nickTextField!)
            make.top.equalTo((nickTextField?.snp.bottom)!).offset(42*heightScale)
            make.height.equalTo(0.5)
            
        }
        sexTextField?.snp.remakeConstraints { (make) in
            make.top.equalTo((nickUndline?.snp.bottom)!).offset(58*heightScale)
            make.left.right.height.equalTo(nickTextField!)
         
        }
        sexUndline?.snp.remakeConstraints { (make) in
            make.top.equalTo((sexTextField?.snp.bottom)!).offset(42*heightScale)
            make.left.right.height.equalTo(nickUndline!)
            
        }
        hintSexNoReviewLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(hintSexNoReviewLabel.superview!)
            make.top.equalTo((sexUndline?.snp.bottom)!).offset(48*heightScale)
            
            
        }
        doneBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(hintSexNoReviewLabel.snp.bottom).offset(92*heightScale)
            make.left.right.equalTo(sexUndline!)
            
        }
      
        agreeProtocalLabel.snp.remakeConstraints { (make) in
            make.bottom.equalTo(agreeProtocalLabel.superview!).offset(-66*heightScale)
            make.centerX.equalTo(agreeProtocalLabel.superview!)
        }
        
        
        
       
   
    }
    
    
    
    //MARK:- 返回按钮
    fileprivate lazy var backBtn:UIButton = UIButton(title: "", imageName: "test", target: self, selector: #selector(back), font: nil, titleColor: nil)
    //MARK:- 标题提示框
    fileprivate lazy var titleHintLabel:UILabel = UILabel(text: "填写个人信息", font: UIFont.systemFont(ofSize: DEFAULTFONTSIZE), textColor: DEFAUlTFONTCOLOR, textAlignment: .center)
    //MARK:- 头像
    fileprivate lazy var headImageView:UIImageView = {
        let imageView:UIImageView = UIImageView(image: UIImage(contentsOfFile: String.localPath("test.png")))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(chooseHeadImage)))
        return imageView
    }()
    //MARK:- 上传头像提示框
    fileprivate lazy var uploadHeadHintLabel = UILabel(text: "上传头像", font: UIFont.systemFont(ofSize: 14.5), textColor: PLACEHOLDERCOLOR, textAlignment: .center)
    //MARK:- 错误提示框
    fileprivate lazy var hintLabel = UILabel(text: "", font: UIFont.systemFont(ofSize: 14.5), textColor: UIColor.init(hexString: "#ff0000"), textAlignment: .center)
    //MARK:- 注册成功之后不能修改性别提示框
    fileprivate lazy var hintSexNoReviewLabel = UILabel(text: "注册成功后性别不可修改", font: UIFont.systemFont(ofSize: 14.5), textColor: PLACEHOLDERCOLOR, textAlignment: .center)
    //MARK:- 昵称输入框
     var nickTextField:UITextField?
    //MARK:- 昵称下划线
    var nickUndline:UILabel?
    
    //MARK:- 性别输入框
    var sexTextField:UITextField?
    //MARK:- 性别下划线
    var sexUndline:UILabel?
    
    
      //MARK:- 创建OK按钮
    public lazy var doneBtn:UIButton = UIButton(title: "完成", imageName: nil, target: self, selector: #selector(done), font: UIFont.systemFont(ofSize: DEFAULTFONTSIZE), titleColor: DEFAUlTFONTCOLOR)
    //MARK:- 创建同意协议label
    fileprivate lazy var agreeProtocalLabel:UILabel = UILabel(text: "注册即代表同意球友科技服务条款和隐私条款", font: UIFont.systemFont(ofSize: 13), textColor: UIColor(hexString: "#b7b8bc")!, textAlignment: .center)
    
    
    //MARK:- 创建TextField
    func createTextField(text:String,placeHolder:String,textColr:UIColor,placeHolderColor:UIColor,fontSize:CGFloat) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeHolder
        let font = UIFont.systemFont(ofSize: fontSize)
        textField.font = font
        textField.textColor = textColr
        textField.textAlignment = .center
        
        // 设置placeholder的颜色(一定要在placeholder设置后才会生效)
        textField.setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")
        // 设置placeholder的字体
        textField.setValue(font, forKeyPath: "_placeholderLabel.font")
        return textField
        
    }
    
    //MARK:- 创建下划线
    func createUndline() -> UILabel {
        let label = UILabel()
        label.backgroundColor = UIColor.black
        return label
    };

    
   
    
    //MARK:- 完成点击事件
    func done() {
        printLog(message:  #function)
        
        if nickTextField?.text?.characters.count == 0 {
             hint(hintInfo: "请输入昵称", isError: true)
            nickTextField?.becomeFirstResponder()
            return
        }
        
        if sexTextField?.text?.characters.count == 0 {
            hint(hintInfo: "请选择性别", isError: true)
            view.endEditing(true)
            sexTextField?.becomeFirstResponder()
            return
            
        }
        
        
        UserInfo.loadAccount()?.Nickname = (nickTextField?.text)!
        UserInfo.loadAccount()?.Sex = 1
         
            
        LoginViewModel.finshedUserInfo(user: UserInfo.loadAccount()!, headimg: "") {[weak self] (result) in
            let json = result as? JSON
            let code = json?["code"]
            if code == 1{
              
                if  let data = json?["data"].dictionaryObject{
                    let userInfo = UserInfo.init(dict: data)
                    if userInfo.saveUserInfo(){
                      
                        self?.delegate?.loginView!(true)
                       self?.back()
                        
                    }else{
                        printData(message: "登录信息归档失败")
                    }
                }
                
            }else{
            
                if let msg = json?["msg"].stringValue{
                self?.hint(hintInfo: msg, isError: true)
                }
            
            }
        }
   
    }
    
    //MARK:- 选择头像
    func chooseHeadImage() {
        printLog(message:  #function)
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            printData(message: "读取相册错误")
        }
        
    }
    
    //MARK:- 选择性别
    func chooseSex() {
         printLog(message:  #function)

        let man = UIAlertAction(title: "男", style: .default) { [weak self] (void)->() in
            if let stongSelf = self{
             stongSelf.sexTextField?.text = "男"
            }
            
        }
        
        let women = UIAlertAction(title: "女", style: .default) {[weak self] (void)->()  in
            if let stongSelf = self{
                stongSelf.sexTextField?.text = "女"
            }
        }
        
        let unKonwn =  UIAlertAction(title: "不好说", style: .default) { [weak self] (void)->()  in
            if let stongSelf = self{
                stongSelf.sexTextField?.text = "不好说"
            }
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: nil , message:nil , preferredStyle: .actionSheet)
        alert.addAction(man)
        alert.addAction(women)
        alert.addAction(unKonwn)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
   
    }
    
    
    
    //MARK:- 交互提示
    func  hint(hintInfo:String,isError:Bool) {
        hintLabel.text = hintInfo
        if isError {
            hintLabel.textColor = UIColor.init(hexString: "#ff0000")
        }else{
            
            hintLabel.textColor = UIColor.init(hexString: "#2fc381")
        }
        

        
    }
    
    //MARK:- 返回按钮
    override func back(){
        view.removeFromSuperview()
        self.removeFromParentViewController()
    
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         view.endEditing(true)
    }
    
    
    
    
}



// MARK: - 代理方法
extension RegisterSecondViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField .isEqual(sexTextField){
           chooseSex()
        }
        return false
    }
    
    
    
    //选择图片成功后代理
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
        //显示的图片
        let image:UIImage?
        if let newImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = newImage
            
        }else{
            //获取选择的原图
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        }
        
      
        guard image == nil else {
             LoginViewModel.upload(image: image!, finishedCallback: { (result) in
                 printData(message: "上传头像成功")
             })
            return
        }
     
   
       
    }


}







