//
//  UITextField-Extension.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/23.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

extension UITextField{


    convenience init(placeholder:String?=nil,placeholderColor:UIColor?=nil,text:String?=nil,textColor:UIColor?=nil) {
        
        
        self.init()
        
        if placeholder != nil   {
          self.placeholder = placeholder
        }
        if placeholderColor != nil {
            self.attributedPlaceholder = NSAttributedString.init(string: placeholder!, attributes: [NSForegroundColorAttributeName:placeholderColor!])
            
         
        }

        if text != nil{
          self.text = text
        }
        
        if textColor != nil{
         self.textColor = textColor
        
        }
   
    }







}









