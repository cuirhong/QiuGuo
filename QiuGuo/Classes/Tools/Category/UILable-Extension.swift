//
//  UILable-Extension.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/28.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

extension UILabel
{
    convenience init(text: String?,font: UIFont?, textColor: UIColor?,textAlignment:NSTextAlignment?) {
        self.init()
        
        self.text = text
        self.font = font
        self.textColor = textColor
        
        if let alignment = textAlignment {
             self.textAlignment = alignment
        }
       

    }
    
    
    /**
     计算label的宽度和高度
     
     :param: text       label的text的值
     :param: attributes label设置的字体
     
     :returns: 返回计算后label的CGRece
     */
    func labelSize(text:String,size:CGSize?, font:UIFont?) -> CGRect{
        var rect = CGRect();
         var newSize:CGSize = CGSize.init(width: 100000, height: 100000)
        if size != nil {
           newSize = size!
        }
        
 
    
        let attributes = [NSFontAttributeName: font]//计算label的字体
        rect = text.boundingRect(with: newSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes , context: nil);
        return rect
    }
    
    
    
    //MARK:- 创建下划线
    class func unline()->UILabel{
        let label = UILabel()
        label.backgroundColor = UIColor.init(hexString: "#cccccc")
        return label
    }
    
    
    
    
    
    
}
