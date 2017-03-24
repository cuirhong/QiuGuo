//
//  DSAlert.swift
//  DSAlert-Swift
//
//  Created by zeroLu on 16/8/31.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


/*! 背景高斯模糊枚举 默认：1 */
enum DSAlertBlurEffectStyle : Int {
    /*! 较亮的白色模糊 */
    case dsAlertBlurEffectStyleExtraLight = 1
    /*! 一般亮的白色模糊 */
    case dsAlertBlurEffectStyleLight
    /*! 深色背景模糊 */
    case dsAlertBlurEffectStyleDark
    /*! 背景不处理 */
    case dsAlertBlurEffectStyleNone
}

/*! 进出场动画枚举 默认：1 */
enum DSAlertAnimatingStyle : Int {
    /*! 缩放显示动画 */
    case dsAlertAnimatingStyleScale = 1
    /*! 晃动动画 */
    case dsAlertAnimatingStyleShake
    /*! 天上掉下动画 / 上升动画 */
    case dsAlertAnimatingStyleFall
}

private struct Property {
    var subView :UIView?
    
    var title:String?
    
    var message:String?
    
    var image:UIImage?
    
    var buttonTitles : [String]? = {
        var _buttonTitles = [String]()
        return _buttonTitles
    }()
    
    var containerView:UIImageView?
    
    var scrollView:UIScrollView?
    
    var titleLabel:UILabel?
    
    var imageView:UIImageView?
    
    var messageLabel:UILabel?
    
    var buttons : [UIButton]? = {
        var _buttons = [UIButton]()
        return _buttons
    }()
    
    lazy var lines : [UIView]? = {
        var _lines = [UIView]()
        return _lines
    }()
    
    lazy var blurImageView : UIImageView = {
        var _blurImageView = UIImageView(frame: UIScreen.main.bounds)
        
        let autoresizing : UIViewAutoresizing = [.flexibleWidth, .flexibleHeight]
        _blurImageView.autoresizingMask = autoresizing
        _blurImageView.image = UIImage.screenShotImage()
        _blurImageView.contentMode = UIViewContentMode.scaleAspectFit
        _blurImageView.clipsToBounds = true
        _blurImageView.backgroundColor = UIColor.clear
        
        return _blurImageView
    }()
    
    var viewWidth : CGFloat {
        get {
            return UIScreen.main.bounds.width
        }
        set {
            self.viewWidth = newValue
        }
    }
    
    var viewHeight : CGFloat {
        get {
            return UIScreen.main.bounds.height
        }
        set {
            self.viewHeight = newValue
        }
    }
    
    var kDSAlertWidth : CGFloat {
        get {
            return self.viewWidth - 50.0
        }
    }
    
    var kDSAlertPaddingV : CGFloat {
        get {
            return 11.0
        }
    }
    
    var kDSAlertPaddingH : CGFloat {
        get {
            return 18.0
        }
    }
    
    var kDSAlertRadius : CGFloat {
        get {
            return 13.0
        }
    }
    
    var kDSAlertButtonHeight : CGFloat {
        get {
            return 40.0
        }
    }
    
    var _scrollBottom : CGFloat = 0.0
    
    var _buttonsHeight : CGFloat = 0.0
    
    var _maxContentWidth : CGFloat = 0.0
    
    var _maxAlertViewHeight : CGFloat = 0.0
    
    var DS_COLOR:(CGFloat, CGFloat, CGFloat, CGFloat) -> UIColor = {
        return UIColor(red: $0/255.0, green: $1/255.0, blue: $2/255.0, alpha: $3)
    }
    
    init () {
        
    }
}

class DSAlert: UIView {
    
    //MARK: - Property
    /*! 按钮字体颜色 默认：白色*/
    var buttonTitleColor:UIColor?
    
    /*! 是否开启边缘触摸隐藏 alert 默认：false */
    var isTouchEdgeHide : Bool = false
    
    var bgColor : UIColor? = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
    
    /*! 背景图片名字 默认：没有图片*/
    var bgImageName : String?  {
        willSet {
            if newValue == nil {
                property!.containerView?.backgroundColor = UIColor.white
                property!.scrollView!.backgroundColor = UIColor.white
                property!.containerView?.image = nil
            }else {
                property!.containerView?.backgroundColor = UIColor.clear
                property!.scrollView!.backgroundColor = UIColor.clear
                property!.containerView?.image = UIImage(named: newValue!)
                property!.containerView?.contentMode = .scaleAspectFill
            }
        }
    }
    
    /*! 是否开启进出场动画 默认：false，如果 true ，并且同步设置进出场动画枚举为默认值：1 */
    var showAnimate : Bool = false
    
    /*! 进出场动画枚举 默认：1 ，并且默认开启动画开关 */
    var animatingStyle : DSAlertAnimatingStyle? = .dsAlertAnimatingStyleScale
    
    /* 动画时间,默认为0.35秒 */
    var animationDuration : TimeInterval = 0.35
    
    /*!
     * 按钮点击事件回调
     */
    var buttonActionBlock : ((_ index : Int) -> ())?
    /* 是否在执行动画 */
    var animating : Bool = false
    
    /*! 背景高斯模糊枚举 默认：1 */
    var blurEffectStyle : DSAlertBlurEffectStyle? {
        
        //重写set方法
        didSet {
            
            if (self.blurEffectStyle != nil) {
                if blurEffectStyle == .dsAlertBlurEffectStyleLight
                {
                    property!.blurImageView.image = property!.blurImageView.image?.DSAlert_ApplyLightEffect()
                }
                else if blurEffectStyle == .dsAlertBlurEffectStyleExtraLight
                {
                    property!.blurImageView.image = property!.blurImageView.image?.DSAlert_ApplyExtraLightEffect()
                }
                else if blurEffectStyle == .dsAlertBlurEffectStyleDark
                {
                    property!.blurImageView.image = property!.blurImageView.image?.DSAlert_ApplyDarkEffect()
                }else if blurEffectStyle == .dsAlertBlurEffectStyleNone
                {
//                    property!.blurImageView.image = nil
                }
            }
            else
            {
                self.blurEffectStyle = .dsAlertBlurEffectStyleNone
            }
        }
    }
    
    //MARK: - ***** 初始化视图容器
    func loadUI() {
        property!.containerView = UIImageView()
        property!.containerView!.isUserInteractionEnabled       = true
        property!.containerView!.layer.cornerRadius           = property!.kDSAlertRadius
        property!.containerView!.layer.masksToBounds          = true
        property!.containerView!.backgroundColor              = UIColor.white
        
        property!.scrollView = UIScrollView()
        property!.scrollView!.backgroundColor = UIColor.white
        property!.containerView! .addSubview(property!.scrollView!)
        
        self.addSubview(property!.containerView!)
        self.setupCommonUI()
    }
    
    //MARK: - ***** 加载自定义View
    func setupUI() {
        frame                       = UIScreen.main.bounds
        backgroundColor             = self.bgColor
        
        property!.subView!.layer.shadowColor   = UIColor(white: 0.0, alpha: 0.5).cgColor
        property!.subView!.layer.shadowOffset  = CGSize.zero
        property!.subView!.layer.shadowOpacity = 1
        property!.subView!.layer.shadowRadius  = 10.0
        property!.subView!.layer.borderWidth   = 0.5
        property!.subView!.layer.borderColor   = property!.DS_COLOR(110, 115, 120, 1).cgColor
        
        self.addSubview(property!.subView!)
        self.setupCommonUI()
    }
    
    //MARK: - ***** 公共方法
    func setupCommonUI() {
        blurEffectStyle = .dsAlertBlurEffectStyleNone
        
        self.addGestureRecognizer(dismissTap!)
    }
    
    //MARK: - 1、高度封装一行即可完全配置alert，如不习惯，可使用第二种常用方法
    /*!
     *  创建一个完全自定义的 alertView
     *
     *  @param customView    自定义 View
     *  @param configuration 属性配置：如 bgColor、buttonTitleColor、isTouchEdgeHide...
     */
    static func ds_showCustomView(customView : UIView, configuration : (DSAlert) ->Void ) {
        let temp = DSAlert.initWithCustomView(customView)
        configuration(temp)
        temp.ds_showAlertView()
    }
    
    /*!
     *  创建一个类似于系统的alert
     *
     *  @param title         标题：可空
     *  @param message       消息内容：可空
     *  @param image         图片：可空
     *  @param buttonTitles  按钮标题：不可空
     *  @param configuration 属性配置：如 bgColor、buttonTitleColor、isTouchEdgeHide...
     *  @param action        按钮的点击事件处理
     */
    static func ds_showAlertWithTitle(title : String, message : String, image : UIImage?, buttonTitles : [String], configuration : (DSAlert) -> Void, action : @escaping (Int) -> Void) {
        
        let temp = DSAlert.ds_showTitle(title: title, message: message, image: image, buttonTitles: buttonTitles)
        
        configuration(temp)
        
        temp.ds_showAlertView()
        
        temp.buttonActionBlock = action;
    }
    
    //MARK: - 2、常用方法
    /*!
     *  初始化自定义动画视图
     *  @return instancetype
     */
    static func initWithCustomView(_ customView : UIView) -> DSAlert {
        let view = DSAlert()
        
        view.property!.subView = customView
        
        view.setupUI()
        
        return view
    }
    
    /*!
     *  创建一个类似系统的警告框
     *
     *  @param title        title
     *  @param message      message
     *  @param image        image
     *  @param buttonTitles 按钮的标题
     *
     *  @return 创建一个类似系统的警告框
     */
    static func ds_showTitle(title : String,message : String, image : UIImage?, buttonTitles : [String]?) -> DSAlert {
        
        let view = DSAlert()
        view.frame = CGRect(x: 0, y: 0, width: (view.property?.kDSAlertWidth)!, height: 0)
        view.property!.title = title
        view.property!.image = image
        view.property!.message = message
        view.property!.buttonTitles = buttonTitles
        
        NotificationCenter.default.addObserver(view, selector: #selector(view.changeFrames(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        view.loadUI()
        return view
    }
    
    //MARK: - **** 视图显示方法
    func ds_showAlertView()  {
        let keyWindow = UIApplication.shared.keyWindow
        if  blurEffectStyle != .dsAlertBlurEffectStyleNone {
            keyWindow?.addSubview(property!.blurImageView)
        }
        
        keyWindow?.addSubview(self)
        
        self.layoutMySubViews()
        
        if showAnimate {
            animatingStyle = .dsAlertAnimatingStyleScale
        }
        else if !showAnimate
        {
            showAnimate = true
        }
        else
        {
            print("您没有开启动画，也没有设置动画样式，默认为没有动画！")
        }
        
        if showAnimate {
            if property!.subView != nil {
                self.showAnimationWithView(property!.subView)
            }
            else if property!.containerView != nil
            {
                self.showAnimationWithView(property!.containerView!)
            }
        }
        else
        {
            if property!.subView != nil {
                property!.subView?.center = (window?.center)!
            }
            else if property!.containerView != nil
            {
                self.prepareForShow()
                property!.containerView?.center = (window?.center)!
            }
        }
    }
    
    
    
    //MARK: - **** 视图消失
    func ds_dismissAlertView() {
        if  showAnimate {
            if  property!.subView != nil {
                self.dismissAnimationView(property!.subView!)
            }
            else if property!.containerView != nil
            {
                self.dismissAnimationView(property!.containerView!)
            }
        }
        else
        {
            self.removeSelf()
            animating = false
        }
    }
    
    //MARK: - **** 进场动画
    func showAnimationWithView(_ animationView : UIView?) {
        animating = true
        if  animatingStyle == .dsAlertAnimatingStyleScale
        {
            animationView!.scaleAnimationShowFinishAnimation({ () in
                self.animating = false
            })
        }
        else if animatingStyle == .dsAlertAnimatingStyleShake
        {
            if animationDuration == 0 {
                animationDuration = 1.0
            }
            animationView?.layer.shakeAnimationWithDuration(duration: animationDuration,
                                                            radius: 16.0,
                                                            repeatCount: 1.0,
                                                            finish: { () in
                self.animating = false
            })
        }
        else if animatingStyle == .dsAlertAnimatingStyleFall
        {
            if animationDuration == 0 {
                animationDuration = 0.35
            }
            animationView?.layer.fallAnimationWithDuration(duration: animationDuration,
                                                           finish: { () in
                self.animating = false
            })
        }
    }
    
    //MARK: - **** 出场动画
    func dismissAnimationView(_ animationView : UIView?) {
        animating = true
        if  animatingStyle == .dsAlertAnimatingStyleScale
        {
            animationView!.scaleAnimationDismissFinishAnimation({ () in
                self.removeSelf()
                self.animating = false
            })
        }
        else if animatingStyle == .dsAlertAnimatingStyleShake
        {
            if animationDuration == 0 {
                animationDuration = 1.0
            }
            animationView?.layer.floatAnimationWithDuration(duration: animationDuration,
                                                            finish: { () in
                self.removeSelf()
                self.animating = false
            })
        }
        else if animatingStyle == .dsAlertAnimatingStyleFall
        {
            if animationDuration == 0 {
                animationDuration = 0.35
            }
            animationView?.layer.floatAnimationWithDuration(duration: animationDuration, finish: { () in
                self.removeSelf()
                self.animating = false
            })
        }
        else
        {
            print("您没有选择出场动画样式：animatingStyle，默认为没有动画样式！")
            self.removeSelf()
            animating = false
        }
    }
    
    //MAKR: - ***** 设置UI
    func prepareForShow() {
        self.resetViews()
        property!._scrollBottom = 0.0
    
        let insetY : CGFloat = property!.kDSAlertPaddingV
        property!._maxContentWidth = property!.kDSAlertWidth - 2 * property!.kDSAlertPaddingH
        property!._maxAlertViewHeight = property!.viewHeight - 50
        
        self.loadTitle()
        self.loadImage()
        self.loadMessage()
        
        property!._buttonsHeight = property!.kDSAlertButtonHeight * CGFloat( ((property!.buttonTitles?.count)! > 2 || property!.buttonTitles?.count == 0) ? (property!.buttonTitles?.count)! : 1)
        
        frame = (window?.bounds)!
        backgroundColor = bgColor
        
        let containViewHeight : CGFloat = min(max(property!._scrollBottom + 2 * insetY + property!._buttonsHeight, 2 * property!.kDSAlertRadius + property!.kDSAlertPaddingV), property!._maxAlertViewHeight)
        property!.containerView?.frame = CGRect(x: 0.0, y: 0.0, width: property!.kDSAlertWidth, height: containViewHeight)
        
        let scrollView = min(property!._scrollBottom, property!.containerView!.frame.height - 2 * insetY - property!._buttonsHeight)
        property!.scrollView!.frame = CGRect(x: 0.0, y: insetY, width: property!.containerView!.frame.width, height: scrollView)
        property!.scrollView!.contentSize = CGSize(width: property!._maxContentWidth, height: property!._scrollBottom)
        
        self.loadButtons()
        
    }
    
    //MARK: - **** 重置subviews
    func resetViews() {
        if (property!.titleLabel != nil) {
            property!.titleLabel! .removeFromSuperview()
            property!.titleLabel = nil
        }
        
        if (property!.imageView != nil) {
            property!.imageView! .removeFromSuperview()
            property!.imageView = nil
        }
        
        if (property!.messageLabel != nil) {
            property!.messageLabel! .removeFromSuperview()
            property!.messageLabel = nil
        }
        
        if ( property!.buttons?.count > 0 ) {
            for subview in property!.buttons! {
                subview.removeFromSuperview()
            }
            property!.buttons!.removeAll()
        }
        
        if (property!.lines != nil) {
            for subview in property!.lines! {
                subview.removeFromSuperview()
            }
            property!.lines!.removeAll()
        }
    }
    
    //MARK: - 初始化标题
    func loadTitle() {
        if property!.title == nil {
            return
        }
        if property!.titleLabel == nil {
            let titleLabel = UILabel()
            titleLabel.textColor = UIColor.black
            titleLabel.font = UIFont(name: "FontNameAmericanTypewriterBold", size: 20.0)
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            
            property!.titleLabel = titleLabel
        }
        property!.titleLabel?.text = property!.title
        self.addLabel(property!.titleLabel!, maxHeight: 100)
        self.addLine(CGRect(x: property!.kDSAlertPaddingH, y: property!._scrollBottom, width: property!._maxContentWidth, height: 0.5), view: property!.scrollView!)
        
        property!._scrollBottom += property!.kDSAlertPaddingV
    }
    
    //MARK: - 初始化图片
    func loadImage() {
        if property!.image == nil {
            return
        }
        if property!.imageView == nil {
            
            property!.imageView = UIImageView()
        }
        property!.imageView?.image = property!.image
        
        var size : CGSize = (property!.image?.size)!
        
        if size.width > property!._maxContentWidth {
            size = CGSize(width: property!._maxContentWidth, height: size.height/size.width * property!._maxContentWidth)
        }
        
        property!.imageView?.frame = CGRect(x: property!.kDSAlertPaddingH + property!._maxContentWidth / 2 - size.width / 2, y: property!._scrollBottom, width: size.width, height: size.height)
        property!.scrollView!.addSubview(property!.imageView!)
        
        property!._scrollBottom = property!.imageView!.frame.maxY + property!.kDSAlertPaddingV
    }
    
    //MARK: - 初始化内容标签
    func loadMessage() {
        if ( property!.message == nil )
        {
            return
        }
        if ( property!.messageLabel == nil )
        {
            let _messageLabel : UILabel = UILabel()
            _messageLabel.textColor     = UIColor.black
            _messageLabel.font          = UIFont.systemFont(ofSize: 14.0)
            _messageLabel.textAlignment = .center
            _messageLabel.numberOfLines = 0
            
            property!.messageLabel = _messageLabel
        }
        property!.messageLabel?.text = property!.message!
        
        self.addLabel(property!.messageLabel!, maxHeight: 100000.0)
    }
    
    //MARK: - 初始化按钮
    func loadButtons() {
        
        if (property!.buttonTitles == nil || (property!.buttonTitles?.isEmpty)! )
        {
            return
        }
        let buttonHeight : CGFloat = property!.kDSAlertButtonHeight
        let buttonWidth : CGFloat  = property!.kDSAlertWidth
        var top : CGFloat          = property!.containerView!.frame.height-property!._buttonsHeight
        
        self.addLine(CGRect(x: 0.0, y: top - 0.5, width: buttonWidth, height:0.5), view: property!.containerView!)
        
        if ( 1 == property!.buttonTitles!.count )
        {
            self.addButton(CGRect(x: 0.0, y: top, width: buttonWidth, height: buttonHeight), title: (property!.buttonTitles?.first)!, tag: 0)
        }
        else if (2 == property!.buttonTitles!.count)
        {
            
            self.addButton(CGRect(x: 0.0, y: top, width: buttonWidth/2, height: buttonHeight), title: (property!.buttonTitles?.first)!, tag: 0)
            self.addButton(CGRect(x: 0 + buttonWidth / 2, y: top, width: buttonWidth/2, height: buttonHeight), title: (property!.buttonTitles?.last)!, tag: 1)
            self.addLine(CGRect(x: 0 + buttonWidth / 2 - 0.5, y: top, width: 0.5, height: buttonHeight), view: property!.containerView!)
            
        }
        else
        {
            for i in 0...property!.buttonTitles!.count {
                self.addButton(CGRect(x: 0.0, y: top, width: buttonWidth, height: buttonHeight), title: property!.buttonTitles![i], tag: i)
                
                top += buttonHeight
                
                if (property!.buttonTitles?.count)! - 1 != i {
                    self.addLine(CGRect(x: 0.0, y: top, width: buttonWidth, height: 05), view: property!.containerView!)
                }
            }
            
            for view in property!.lines! {
                property!.containerView?.bringSubview(toFront: view)
            }
        }
    }
    
    //MARK: - 添加按钮方法
    func addButton(_ frame : CGRect, title : String, tag : Int) {
        
        if (property!.buttons == nil) {
            property!.buttons = [UIButton]()
        }
        
        let button : UIButton       = UIButton()
        button.frame = frame
        button.setTitle(title, for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        button.tag = tag
        
        if ( buttonTitleColor != nil )
        {
            button.setTitleColor(buttonTitleColor!, for: UIControlState())
        }
        else
        {
            button.setTitleColor(UIColor.blue, for: UIControlState())
        }
        
        if ( bgImageName != nil )
        {
            button.setBackgroundImage(UIImage.DSAlert_ImageWithColor(UIColor.clear), for: UIControlState())
            button.setBackgroundImage(UIImage.DSAlert_ImageWithColor(property!.DS_COLOR(135, 140, 145, 0.45)), for: .highlighted)
        
        }
        else
        {
            button.setBackgroundImage(UIImage.DSAlert_ImageWithColor(UIColor.white), for: UIControlState())
            button.setBackgroundImage(UIImage.DSAlert_ImageWithColor(property!.DS_COLOR(135, 140, 145, 0.45)), for: .highlighted)
        }
        button.addTarget(self, action: (#selector(self.buttonClicked(_:))), for: .touchUpInside)
        property!.containerView?.addSubview(button)
        property!.buttons?.append(button)
        
    }
    
    //MARK: - 添加标签方法
    func addLabel(_ label : UILabel, maxHeight : CGFloat) {
        let size : CGSize = label.sizeThatFits(CGSize(width: property!._maxContentWidth, height: maxHeight))
        label.frame   = CGRect(x: property!.kDSAlertPaddingH, y: property!._scrollBottom, width: property!._maxContentWidth, height: size.height)
        property!.scrollView!.addSubview(label)
        
        property!._scrollBottom = label.frame.maxY + property!.kDSAlertPaddingV
    }
    
    //MARK: - 添加底部横线方法
    func addLine(_ frame : CGRect, view : UIView) {
        let line : UIView = UIView(frame:frame)
        line.backgroundColor   = property!.DS_COLOR(160, 170, 160, 1)
        view.addSubview(line)
        property!.lines?.append(line)
    }
    
    //MARK: - **** 清除所有视图
    func removeSelf() {
        print("【 \(self.classForCoder) 】已经释放！");
        self.resetViews()
        
        if property!.subView == nil {
            for view in (property!.containerView?.subviews)! {
                view.removeFromSuperview()
            }
        }else {
            for view in (property!.subView?.subviews)! {
                view.removeFromSuperview()
            }
            property!.subView?.removeFromSuperview()
        }
        
        for view in subviews {
            view.removeFromSuperview()
        }
        self.removeFromSuperview()
        property!.blurImageView.removeFromSuperview()
        property = nil
        bgColor = nil
        animatingStyle = nil
        buttonActionBlock = nil
        blurEffectStyle = nil
        dismissTap = nil
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - **** 更新frame
    func layoutMySubViews() {
        
        if (property!.subView != nil) {
            frame = CGRect(x: 0.0, y: 0.0, width: property!.viewWidth, height: property!.viewHeight)
            
           
            
        }
        else
        {
            self.prepareForShow()
            property!.containerView?.center = CGPoint(x: property!.viewWidth / 2, y: property!.viewHeight / 2)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !animating {
            self.layoutMySubViews()
        }
    }
    
    //MARK: - **** 手势消失方法
    func dismissTapAction(_ gesture : UITapGestureRecognizer) {
        print("触摸了边缘隐藏View！")
        
        if isTouchEdgeHide
        {
            self.ds_dismissAlertView()
        }
        else
        {
            print("触摸了View边缘，但您未开启触摸边缘隐藏方法，请设置 isTouchEdgeHide 属性为 true 后再使用！")
        }
    }
    
    //MARK: - **** 按钮事件
    func buttonClicked(_ button : UIButton)
    {
        self.ds_dismissAlertView()
        
        if (buttonActionBlock != nil)
        {
            buttonActionBlock!(button.tag)
        }
    }
    
    //MARK: - **** 转屏通知处理
    func changeFrames(_ notification : Notification) {
        
        property!.containerView?.layer.removeAllAnimations()
        animating = false
        self.layoutMySubViews()
    }
    
    //MARK: - **** lazy
    lazy var dismissTap : UITapGestureRecognizer? = {
        var _dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissTapAction(_:)))
        return _dismissTap
    }()
    
    lazy fileprivate var property : Property? = {
        var _property = Property()
        return _property
    }()
}
