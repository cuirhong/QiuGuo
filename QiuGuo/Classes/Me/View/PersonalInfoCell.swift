//
//  PersonalInfoCell.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/3.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class PersonalInfoCell: BaseTableViewCell {
    
    
    var array:[String]?{
        didSet{
            if array?.count == 3{
                 iconImageView.image = UIImage.getImage((array?[0])!)
                userInfoLineLabel.text = array?[1]
                countLabel.text = array?[2]
            }
        }
    }
    
    
    fileprivate lazy var iconImageView:UIImageView = UIImageView()
    
    public lazy var userInfoLineLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 45), textColor: DEFAUlTFONTCOLOR, textAlignment: .left)
    
    public lazy var countLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 36), textColor: UIColor(hexString: "#777777")!, textAlignment: .right)

    
    fileprivate lazy var arrowImageView:UIImageView = UIImageView(image: UIImage.getImage("arrow_r"))
    
    fileprivate lazy var undlineLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(hexString: "#e6e6e6")
        return label
    }()
    
    public lazy var buttonSwitch:UISwitch=UISwitch()
    
    
    init(style:UITableViewCellStyle = .default,reuseIdentifier:String?,isNeedIcon:Bool=true,isNeedCount:Bool=false,isNeedSwitch:Bool=false,switchIsOn:Bool=false,isNeedArrow:Bool=true){
    
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       
        contentView.addSubview(userInfoLineLabel)
        
        contentView.addSubview(undlineLabel)
       
        if isNeedIcon{
           contentView.addSubview(iconImageView)
            iconImageView.snp.remakeConstraints { (make) in
                make.left.equalTo(iconImageView.superview!).offset(68*LayoutWidthScale)
                make.centerY.equalTo(iconImageView.superview!)
                make.width.height.equalTo(88*LayoutWidthScale)
            }
            userInfoLineLabel.snp.remakeConstraints { (make) in                make.left.equalTo(iconImageView.snp.right).offset(44*LayoutWidthScale)
                make.centerY.equalTo(iconImageView)
            }
        }else{
        
            userInfoLineLabel.snp.remakeConstraints { (make) in                make.left.equalTo(userInfoLineLabel.superview!).offset(50*LayoutWidthScale)
                make.centerY.equalTo(userInfoLineLabel.superview!)
            }
        
        
        }
        
       
        
        
        if isNeedArrow{
            contentView.addSubview(arrowImageView)
            arrowImageView.snp.remakeConstraints { (make) in
                make.right.equalTo(arrowImageView.superview!).offset(-44*LayoutWidthScale)
                make.width.height.equalTo(88*LayoutWidthScale)
                make.centerY.equalTo(userInfoLineLabel)
            }
        }
        
        
        
        if isNeedCount {
            contentView.addSubview(countLabel)
            countLabel.snp.remakeConstraints({ (make) in
            make.right.equalTo(arrowImageView.snp.left).offset(10*LayoutWidthScale)
                make.centerY.equalTo(arrowImageView)
            })
            
        }
        
        undlineLabel.snp.remakeConstraints { (make) in
            make.right.bottom.equalTo(undlineLabel.superview!)
          make.height.equalTo(1)
           make.left.equalTo(userInfoLineLabel)
        }
        
        
        if isNeedSwitch{
            contentView.addSubview(buttonSwitch)
            buttonSwitch.isOn = switchIsOn
            buttonSwitch.snp.remakeConstraints({ (make) in
                make.right.equalTo(-50*LayoutWidthScale)
                make.centerY.equalTo(buttonSwitch.superview!)
            })
        }
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
















