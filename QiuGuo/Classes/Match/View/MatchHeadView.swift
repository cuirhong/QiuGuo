//
//  MatchHeadView.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/7.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit



class MatchHeadView: UICollectionReusableView {
    
    //MARK:- 比赛列表模型
    var matchListModel:MatchListModel?{
    
        didSet{
          dateLabel.text = matchListModel?.StartTime
        
        
        }
    
    }
    
    //MARK:- 初始化
    override init(frame: CGRect) {
         super.init(frame: frame)
        
        
        backgroundColor = UIColor.init(hexString: "#f2f2f2")
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(dateLabel.superview!)
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- 时间label
    private lazy var dateLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 36), textColor: UIColor.init(hexString: "#4d4d4d"), textAlignment: .left)
    
    
    
    
    
    
}
























