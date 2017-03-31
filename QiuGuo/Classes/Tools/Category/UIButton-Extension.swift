//
//  UIButton-Extension.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/28.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

extension UIButton
{
    convenience init(title: String?="",backgroundColor:UIColor?=nil, imageName: String?=nil,backImageName:String?=nil, highlightedImageName:String?=nil,selBackImageName:String?=nil, target: Any?=nil ,selector: Selector?=nil, font: UIFont?=nil, titleColor: UIColor?=nil,selTitleColor:UIColor?=nil) {
        self.init()
        if let imageN = imageName {
            setImage(UIImage(named:imageN), for: UIControlState())
        }
        if let backColor = backgroundColor{
           self.backgroundColor = backColor
        
        }
        if let newBackImageName = backImageName{
            setBackgroundImage(UIImage(named:newBackImageName), for: .normal)
        
        }
        if let hImage = highlightedImageName{
      
            let image = UIImage(contentsOfFile: String.localPath(hImage))
            setImage(image, for: .highlighted)
        
        }
        if let selImage = selBackImageName{
          
             setBackgroundImage(UIImage(named:selImage), for: .selected)
        }
        if let newFont = font {
         titleLabel?.font = newFont
        
        }
        if let newColor = titleColor {
            
            setTitleColor(newColor, for: .normal)
        }
       
        if let newTitle = title {
            setTitle(newTitle, for: UIControlState()) 
        }
       
       
        if let sel = selector {
            addTarget(target, action: sel, for: .touchUpInside)
        }
        
        if let selColor = selTitleColor{
            
           setTitleColor(selColor, for: .selected)
        }
        
    }
    
    
    //MARK:- 设置按钮的图片和文字的位置
     func positionLabelRespectToImage( position: UIViewContentMode,
                                       spacing: CGFloat,state:UIControlState) {

        let imageView = UIImageView(image: self.image(for: state))
        let  imageSize = imageView.bounds.size
        let titleFont = self.titleLabel?.font!
        var title = ""
        if let text = self.titleLabel?.text{
          title = text
        }
        let titleSize = title.size(attributes: [NSFontAttributeName: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}
