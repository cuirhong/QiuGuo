//
//  MenuToolView.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/14.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

/// 比赛详情页的menu工具
class MenuToolView: PageMenuView {
    //MARK:- 初始化
    convenience init(titles:[String]){
        self.init(frame:CGRect.zero)
       
        menuTitles = titles
        setupMenuButton()

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:-设置约束
    override func setupMenuButton(index:Int=0) {
        
        for view in self.subviews{
            view.removeFromSuperview()
        }

        for newIndex in 0..<menuTitles.count {
            let btn:UIButton = createMenuButton(title: menuTitles[newIndex],tag:newIndex)
              addSubview(btn)
            switch newIndex {
            case 0:
                btn.snp.remakeConstraints({ (make) in
                    make.left.centerY.equalTo(btn.superview!)
                    
                })
                
            case 1:
                btn.snp.remakeConstraints({ (make) in
                    make.centerX.centerY.equalTo(btn.superview!)
                    
                })
            case 2:
                btn.snp.remakeConstraints({ (make) in
                    make.right.centerY.equalTo(btn.superview!)
                    
                })
                
            default:
                 break
            }
            
            if index == newIndex{
                btn.isSelected = true
                btn.titleLabel?.font = UIFont.font(psFontSize: 60)
                addSubview(undline)
                undline.snp.remakeConstraints({ (make) in
                    make.top.equalTo(btn.snp.bottom)
                    make.centerX.equalTo(btn)
                    make.width.equalTo(57*LayoutWidthScale)
                    make.height.equalTo(4*LayoutHeightScale)
                   
                })
            }
        }
    }
    

    
    
    
    
}
