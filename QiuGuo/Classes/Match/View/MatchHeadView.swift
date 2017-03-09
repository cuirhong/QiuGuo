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
             dateLabel.text = "----"
            guard (matchListModel?.StartTime?.isEmpty)! else {
                let date = String.getDateFromString(dateStr: matchListModel?.StartTime)
                var weak = "今天"
                let com = date?.getDateComponents()
                if date?.comparedDateWithCurrentDate() != .Today{
                    if let week = com?.weekday{
                    weak = "星期" + String.weekStringFromInt(date: week)
                    }
                }
                if let year = com?.year, let month = com?.month{
                    
                    let dateStr = String(format: "%d年%d月%d日 %@",year, month,(com?.day)!,weak)

                    dateLabel.text = dateStr
                }
                return
            }
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
























