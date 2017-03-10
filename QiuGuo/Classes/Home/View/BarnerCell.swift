//
//  BarnerCell.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/6.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class BarnerCell: BaseCollectionViewCell {
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(shuffingFigureView)
        shuffingFigureView.snp.remakeConstraints { (make) in
            make.top.left.right.bottom.equalTo(shuffingFigureView.superview!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    //MARK:- barner数据模型
     var barnerArr:[BarnerModel]=[]{
        
        didSet{
            
            //重用
            var imageUrls:[String] = []
            var titles:[String] = []
            for model in (self.barnerArr) {
                imageUrls.append(model.Cover!)
                titles.append(model.Title!)
            }
            shuffingFigureView.imageUrlArr = imageUrls
            shuffingFigureView.titleArr = titles
            shuffingFigureView.refreshUI()
            
        }

    }


    //MARK:- 轮播图,barner
     lazy var shuffingFigureView:ShufflingFigureView = ShufflingFigureView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 528*LayoutHeightScale))
}

















