//
//  MatchGuessSectionView.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/14.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit


class MatchGuessSectionView: BaseView {
    
    
    //MARK:- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    func setupUI(){}
    
    
    //MARK:- 背景阴影图片 
    private lazy var backMaskImageView:UIImageView = UIImageView.init(image: UIImage.getImage("tab_ shadow.png"))
    
    //MARK:- title文本框
    private lazy var titleLable:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 38), textColor: UIColor.init(hexString: "#7f7f7f"))
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    









}
