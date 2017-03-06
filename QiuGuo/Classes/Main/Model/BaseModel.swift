//
//  BaseModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/27.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//
import UIKit

class BaseModel: NSObject {
    
    
        init(dict : [String : Any]) {
            super.init()
            setValuesForKeys(dict)
        }
    
        override func setValue(_ value: Any?, forUndefinedKey key: String) {
            if key.isEmpty{
                super.setValue(value, forUndefinedKey: key)
            }
        }
    
    

    

}
