//
//  UIImageView-Extension.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/3.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import Kingfisher
extension UIImageView{



    func image(imageName:String) -> UIImageView {
        if let image = UIImage(contentsOfFile: String.localPath(imageName)){
        self.image = image

        }else{
        
            self.image = UIImage(named:imageName)
        }
        return self
   
    }
    
    
    
    
    func kf_setImage(imageUrlStr:String?,placeholder:String?=nil){
        guard imageUrlStr != nil else {
             return
        }
        
        let onlyWIFILoadImage:Bool = userDefault.value(forKey: KonlyWIFILoadImage) as? Bool ?? false
        
        let placeholderImage = UIImage(named:placeholder ?? "placeholder.png")
        if onlyWIFILoadImage == true {
            if NetworkMonitor.sharedNetworkMonitor()?.currentNetworkType != .WIFI{
                self.image = placeholderImage
                return
            }
        }
        let resource = ImageResource(downloadURL:NSURL.init(string:imageUrlStr!) as! URL, cacheKey: imageUrlStr)
        self.kf.setImage(with: resource, placeholder:placeholderImage , options: nil, progressBlock: nil, completionHandler: nil)

    }
    
    
    

}





