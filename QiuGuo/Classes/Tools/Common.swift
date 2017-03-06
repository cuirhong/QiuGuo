//
//  Common.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/27.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import Kingfisher

typealias SucceedBlock = (_ result: JSON) -> ()
typealias FailureBlock = (_ error: Any?) -> ()

//http://api-test.qiu.com
let AppRootUrl:String = "http://api.qiu.com"

/**
 *  项目主题颜色
 */
let THEMECOLOR:UIColor = UIColor.init(hexString: "#2fce81")!

/**
 *  项目整体背景颜色
 */
let BGCOLOR:UIColor = UIColor.init(hexString: "#fafafa")!
/**
 *  项目默认字体颜色
 */
let DEFAUlTFONTCOLOR:UIColor = UIColor.init(hexString: "#000000")!
/**
 *  placeholder字体的颜色
 */
let PLACEHOLDERCOLOR:UIColor = UIColor.init(hexString: "#b7b8bc")!





/**
 *  项目默认字体大小
 */
let DEFAULTFONTSIZE:CGFloat = 17


/**
 *  布局宽的比例
 */
let LayoutWidthScale = UIScreen.main.bounds.size.width / 1080

/**
 *  布局高的比例
 */
let LayoutHeightScale = UIScreen.main.bounds.size.height / 1920
/**
 *  屏幕的宽
 */
let ScreenWidth = UIScreen.main.bounds.width
/**
 *  屏幕的高
 */
let ScreenHeight = UIScreen.main.bounds.height






/**
 *  用户登录信息持久化路径
 */
let KuserLoginPath = "userLoginInfo.plist".docStr()

/**
 *  设置消息推送
 */
let KonlyWIFILoadImage = "onlyWIFILoadImage"















