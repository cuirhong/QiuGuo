//
//  SingleCommentView.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/27.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import Foundation
import SnapKit
//创建评论view的类型
enum CommentViewType {
    case BasicComment;//原评论
    case replyComment;//回复的评论
    case displyAllComment;//显示所有的评论
}

//MARK:- 评论布局结构体
struct CommentLayout {
    var commentViewType:CommentViewType = .BasicComment
    var clickBtnTop:CGFloat = 0
    var clickBtnRight:CGFloat = 0
    var nickNameLeft:CGFloat = 0
    var commentTextWidth:CGFloat = 0
}


class SingleCommentView: BaseView {
    
    //MARK:- 代理
    weak var delegate:CommentCellDelegate?
    
    //MARK:-  cell
    fileprivate var commentCell:CommentCell?
    
 
    //MARK:- 布局结构体
    fileprivate var commentLayout:CommentLayout = CommentLayout(commentViewType: .BasicComment, clickBtnTop: 0, clickBtnRight: 0, nickNameLeft: 0, commentTextWidth: 0)
    

    //MARK:- 评论模型
    var commentModel:CommentModel?{
        didSet{
            
            if commentModel?.UserName.characters.count != 0{
              nickLabel.text = commentModel?.UserName
            }else{
                nickLabel.text = "无昵称"
            }
            
            if commentModel?.displyType != 2{
               timeLabel.text = commentModel?.Time
            
            }
            
           
            
            clickLikeBtn.setTitle(String.getString(intData: commentModel?.LikeNum) , for: .normal)
            clickLikeBtn.positionLabelRespectToImage(position: .left, spacing: 18*LayoutWidthScale, state: .normal)
            

            commentLabel.numberOfLines = (commentModel?.displyLines)!
            commentLabel.text = commentModel?.Content
            
            commentLabel.snp.updateConstraints { (make) in
                make.height.equalTo((commentModel?.contentDisplyHeight)!)
            }
            
         
            if Int((commentModel?.contentMaxHeight)!) > Int((commentModel?.contentNormalHeight)!) && commentModel?.fiexildAllContent == 0 {

                 fiexibleBtn.isHidden = false
                fiexibleBtn.snp.remakeConstraints { (make) in
                    make.top.equalTo(commentLabel.snp.bottom).offset(68*LayoutHeightScale)
                     make.left.equalTo(nickLabel)
                }
            
            }else{
                fiexibleBtn.isHidden = true
                
                fiexibleBtn.snp.remakeConstraints({ (make) in
                    make.top.equalTo(commentLabel.snp.bottom).offset(0)
                     make.left.equalTo(nickLabel)
                })
            }
            
            
            
         
       
            if commentModel?.commentLayout.commentViewType == CommentViewType.BasicComment{
              headImageView.kf_setImage(imageUrlStr: commentModel?.UserHeadimgurl, placeholder: "avatar_male")
            }else{
                floorBtn.setTitle(String.getString(intData: commentModel?.floorCount), for: .normal)
            }
            
            setNeedsLayout()
        }
    }
    

    
    //MARK:- 初始化
    convenience init(commentLayout:CommentLayout,delegate:CommentCellDelegate?,commentCell:CommentCell) {
        self.init(frame:CGRect.zero)
        self.commentLayout = commentLayout
        self.delegate = delegate
        self.commentCell = commentCell
        
        switch commentLayout.commentViewType {
        case .BasicComment:
            setupUI()
            setupBasicCommentUI()
        case .replyComment:
            setupUI()
            setupReplyCommentUI()
        case .displyAllComment:
            setupDisplayAllComment()
            
        }
        
    }
    
    //MARK:- 设置公共界面
    private func setupUI(){
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.right.bottom.equalTo(-5)
           
        }
        
        addSubview(clickLikeBtn)
        clickLikeBtn.snp.makeConstraints { (make) in
            
            make.top.equalTo(commentLayout.clickBtnTop)
            make.right.equalTo(-commentLayout.clickBtnRight)
            
        }
        
        addSubview(nickLabel)
        nickLabel.snp.makeConstraints { (make) in
            make.left.equalTo(commentLayout.nickNameLeft)
            make.centerY.equalTo(clickLikeBtn)
            make.right.lessThanOrEqualTo(clickLikeBtn.snp.left)
        }
        
        
    }
    
    
    
    
    //MARK:- 设置基本评论界面
    private func setupBasicCommentUI(){
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nickLabel)
            make.top.equalTo(nickLabel.snp.bottom).offset(26*LayoutHeightScale)
        }

        
        addSubview(headImageView)
        headImageView.snp.makeConstraints { (make) in
            make.left.equalTo(50*LayoutWidthScale)
            make.width.height.equalTo(70*LayoutWidthScale)
            make.centerY.equalTo(nickLabel)
        }
        
        addSubview(replyCommentBottomView)
        replyCommentBottomView.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(26*LayoutHeightScale)
            make.left.equalTo(nickLabel)
            make.width.equalTo(commentLayout.commentTextWidth)
            make.height.equalTo(0.5)//占位，无特殊意义 
        }
     
        
        addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(replyCommentBottomView.snp.bottom).offset(60*LayoutHeightScale)
            make.left.equalTo(replyCommentBottomView)
            make.width.equalTo(commentLayout.commentTextWidth)
            make.height.equalTo(60)
        }
        
        addSubview(fiexibleBtn)
        fiexibleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(commentLabel.snp.bottom).offset(68*LayoutHeightScale)
            make.left.equalTo(nickLabel)
        }
        
        let undline = UILabel.unline()
        addSubview(undline)
        undline.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.right.equalTo(undline.superview!)
            make.height.equalTo(CGFloat.undLineHeight())
        }
        
    
        
 
    }
    
    //MARK:- 布局回复评论界面
    private func setupReplyCommentUI(){
        addSubview(floorBtn)
        floorBtn.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.centerY.equalTo(nickLabel)
            make.width.equalTo(80*LayoutWidthScale)
            make.height.equalTo(44*LayoutHeightScale)
        }
        
    
        
        addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nickLabel.snp.bottom).offset(58*LayoutHeightScale)
            make.left.equalTo(nickLabel)
            make.width.equalTo(commentLayout.commentTextWidth)
            make.height.equalTo(60)
        }
        
        addSubview(fiexibleBtn)
        fiexibleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(commentLabel.snp.bottom).offset(68*LayoutHeightScale)
            make.left.equalTo(nickLabel)
        }
    }
    
    //MARK:- 设置显示所有的评论
    private func setupDisplayAllComment(){
        
        let btn = UIButton(title: "显示隐藏楼评论", imageName: "pull-down-arrow",  target: self, selector: #selector(displayAllComment), font: UIFont.font(psFontSize: 45), titleColor: UIColor.init(hexString: "#b3b3b3"))
        addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(btn.superview!)
        }
        
    }
    
    //MARK:- 刷新布局
    func refreshLayout(layout:CommentLayout){

        self.commentLayout = layout
        clickLikeBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(layout.clickBtnTop)
            make.centerY.equalTo(nickLabel)
            make.right.equalTo(-commentLayout.clickBtnRight)
            
        }
      
    
        
        setNeedsLayout()
    }
    
    
    
    //MARK:- 评论常用字体颜色
    fileprivate let commentDefaultFontColor:UIColor = UIColor.init(hexString: "#808080")!
    
    //MARK:- 头像
    fileprivate lazy var headImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35*LayoutWidthScale
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK:- 创建昵称label
    fileprivate lazy var nickLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 45), textColor:self.commentDefaultFontColor)
    
    
    //MARK:- 创建时间label
    fileprivate lazy var timeLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 30), textColor: self.commentDefaultFontColor)
    
    //MARK:- 展开评论内容按钮
    fileprivate lazy var fiexibleBtn:UIButton = {[weak self] in
        let button = UIButton(title: "展开全部", imageName: "pull-down-arrow",   target: self, selector: #selector(fiexibleCommentContent), font: UIFont.font(psFontSize: 34), titleColor: UIColor.init(hexString: "#999999"))
        button.imageView?.contentMode = .center
        button.positionLabelRespectToImage(position: .left, spacing: 10*LayoutWidthScale, state: .normal)
        return button
    
    }()
    
    //MARK:- 创建点赞按钮
    fileprivate lazy var clickLikeBtn:UIButton = UIButton(title: "",  imageName: "like",  target: self, selector: #selector(clickLike), font: UIFont.font(psFontSize: 34), titleColor:self.commentDefaultFontColor)
    
    //MARK:- 创建显示楼层
    fileprivate lazy var floorBtn:UIButton = UIButton(title: "", backImageName: "comment_floor_bg",  font: UIFont.font(psFontSize: 30), titleColor: UIColor.init(hexString: "#4d4d4d"))
    
    //MARK:- 创建评论内容
    fileprivate lazy var commentLabel = UILabel.getCommentLabel()
    
    //MARK:- 回复评论的底部视图
     lazy var replyCommentBottomView:UIView = UIView()
    
    
    
    
    
    
    
    
    
    //MARK:- 伸缩评论内容
    @objc private func fiexibleCommentContent(){
        printData(message:  #function)

        delegate?.commentCell(commentCell, singleCommentView: self, clickResponseType: ClickResponseType.UnflodBasicComment)
        
    }
    
    //MARK:- 点赞
    @objc private func clickLike(){
        printData(message:  #function)
        delegate?.commentCell(commentCell, singleCommentView: self, clickResponseType: ClickResponseType.ClickLike)
        
    }
    
    //MARK:- 显示所有的评论
    @objc private func displayAllComment(){
        printData(message:  #function)
        delegate?.commentCell(commentCell, singleCommentView: self, clickResponseType: ClickResponseType.DisplayAllReplyComment)
    }
    
    
    
 

}
    
