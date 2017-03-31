//
//  InformationCell.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/6.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class ArticleNormalCell: BaseCollectionViewCell {
    
    //MARK:- 咨询模型
    var articleModel:ArticleListModel?{
    
        didSet{
            if let urlStr = articleModel?.Covers?[0]{
                imageView.isHidden = false
             imageView.kf_setImage(imageUrlStr: urlStr)
            
            }
            
            textLabel.text = articleModel?.Title
            
            if articleModel?.IsProfundity == 1{
                resourceLabel.text = "深度"
                resourceLabel.textColor = UIColor.init(hexString: "#808080")
            }else{
                if articleModel?.Tag != ""{
                    resourceLabel.text = articleModel?.Tag
                    if let color = articleModel?.TagColor{
                        resourceLabel.textColor = UIColor.init(hexString: color)
                    }
                    
                }
                
            }

            if let model = articleModel{
             settingComment(articleModel: model)
            }
  
        }
    }
    
    //MARK:- 设置评论
     func settingComment(articleModel:ArticleListModel){
        commentButton.setTitle((articleModel.Comments.description) + " " + "评论", for: .normal)
        let width = (commentButton.titleLabel?.labelSize(text: (commentButton.titleLabel?.text)!, font: commentButton.titleLabel?.font).width)! + 3*2
        commentButton.snp.remakeConstraints { (make) in
            make.bottom.equalTo(-25*LayoutHeightScale)
            make.right.equalTo(-30*LayoutWidthScale)
            make.width.equalTo(width)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    private func setupUI(){
        imageView.isHidden = true
        contentView.addSubview(imageView)
        imageView.snp.remakeConstraints { (make) in
            make.left.equalTo(30*LayoutWidthScale)
            make.top.equalTo(25*LayoutHeightScale)
            make.width.equalTo(288*LayoutWidthScale)
            make.height.equalTo(216*LayoutHeightScale)
        }
        
        
        
        contentView.addSubview(textLabel)
        textLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(40*LayoutWidthScale)
            make.top.equalTo(22*LayoutHeightScale)
            make.right.equalTo(-30*LayoutWidthScale)
            
        }
        
        
        contentView.addSubview(resourceLabel)
        resourceLabel.snp.remakeConstraints { (make) in
            make.bottom.equalTo(-27*LayoutHeightScale)
            make.left.equalTo(textLabel)
        }
        
        contentView.addSubview(commentButton)
        commentButton.snp.remakeConstraints { (make) in
            make.bottom.equalTo(-25*LayoutHeightScale)
            make.right.equalTo(-30*LayoutWidthScale)
        }
        
        
        var height = 1 * LayoutHeightScale
        if height < 0.5{
           height = 0.5
        }
        contentView.addSubview(undlineLabel)
        undlineLabel.snp.remakeConstraints { (make) in
            make.bottom.left.right.equalTo(undlineLabel.superview!)
            make.height.equalTo(height)
            
        }
    
        
    
    }
    


    //MARK:- 图片
    fileprivate lazy var imageView:UIImageView = UIImageView()
    //MARK:- 咨询信息
     lazy var textLabel:UILabel = {
        let label = UILabel(text: "", font: UIFont.font(psFontSize: 46), textColor: DEFAUlTFONTCOLOR, textAlignment: .left)
        label.numberOfLines = 2
        label.sizeToFit()
        return label
    }()
    //MARK:- 来源
     lazy var resourceLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 32), textColor: UIColor.init(hexString: "#808080"), textAlignment: .left)
    //MARK:- 评论
     lazy var commentButton:UIButton = UIButton(title: "898 评论", backImageName: "comment_bg.png", font: UIFont.font(psFontSize: 34), titleColor: UIColor.init(hexString: "4d4d4d"))
    //MARK:- 分割线
    fileprivate lazy var undlineLabel:UILabel = UILabel.unline()
    

    
    
}




