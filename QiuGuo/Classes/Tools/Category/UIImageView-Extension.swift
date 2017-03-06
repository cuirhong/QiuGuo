//
//  UIImageView-Extension.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/3.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

extension UIImageView{



    func image(imageName:String) -> UIImageView {
        if let image = UIImage(contentsOfFile: String.localPath(imageName)){
        self.image = image

        }else{
        
            self.image = UIImage(named:imageName)
        }
        return self
   
    }

}





