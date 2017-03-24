//
//  CGFloat-Extension.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/22.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
extension CGFloat{

    static func undLineHeight(height:CGFloat=1)->CGFloat{
        var newHeight = height * LayoutHeightScale
        if newHeight < (height / 2.0){
            newHeight = height / 2.0
        }
        return newHeight
    }




}



