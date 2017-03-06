//
//  HUDTool.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/6.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import SVProgressHUD

class HUDTool: NSObject {
    
    class func show(text:String?="",detialText:String?="",imageName:String?="",viewController:UIViewController?=nil){
        DispatchQueue.main.async {
            SVProgressHUD.show()
 
        }
        
    
    }
    
    class func dismiss(){
    
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            
            
        }
    
    }
    
    
    






}
