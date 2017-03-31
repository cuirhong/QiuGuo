//
//  CommentToolViews.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/22.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//
import UIKit


protocol CommentToolViewsDelegate:NSObjectProtocol {
      func commentToolView(_ commentToolView:CommentToolViews,commentType:CommentType)
}

enum CommentType {
    case ReleaseComment;//发布评论
    case JumpToComment;//跳转到评论
}

//评论工具的类型
enum CommentTooViewsType {
    case ArticleDetail;
    case ArticleComment;
}

class CommentToolViews: BaseView {
    
    //MARK:- 评论代理
    weak var delegate:CommentToolViewsDelegate?
    
    //MARK:- 文章详情模型
    var articleDetailModel:ArticleDetailModel?{
        didSet{
            commentCountLabel.text = String.getString(intData: articleDetailModel?.Comments)
        }
    }
    
    //MARK:- 初始化
    convenience init(toolViewsType:CommentTooViewsType) {
        self.init(frame: CGRect.zero)
        setupCommentUI()
        switch toolViewsType {
        case .ArticleDetail:
             setupAritcleDetailUI()
        case .ArticleComment:
            setupAritcleCommentUI()
        }
        
    }
    
    //MARK:- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(hexString: "#f5f9f7")
    }
    
    //MARK:- 布局公共区域
    private func setupCommentUI(){
    
        addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(topLine.superview!)
            make.height.equalTo(CGFloat.undLineHeight())
        }
    
    
    }
    
 
    //MARK:- 布局
    private func setupAritcleDetailUI(){
       
        
        addSubview(commentCountLabel)
        commentCountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-50*LayoutWidthScale)
            make.centerY.equalTo(commentCountLabel.superview!)
        }
        commentCountLabel.sizeToFit()
        
        addSubview(commentImageView)
        commentImageView.snp.makeConstraints { (make) in
            make.right.equalTo(commentCountLabel.snp.left).offset(-22*LayoutWidthScale)
            make.centerY.equalTo(commentCountLabel)
            make.width.equalTo(58*LayoutWidthScale)
            make.height.equalTo(56*LayoutHeightScale)
        }
        
    
        
        addSubview(releaseCommentBtn)
        releaseCommentBtn.snp.makeConstraints { (make) in
            make.left.equalTo(releaseCommentBtn.superview!)
            make.top.equalTo(20*LayoutHeightScale)
            make.bottom.equalTo(-20*LayoutHeightScale)
            make.right.equalTo(commentImageView.snp.left).offset(-32*LayoutWidthScale)
           
        }
        
        addSubview(commentCountBtn)
        commentCountBtn.snp.makeConstraints { (make) in
            make.right.equalTo(commentCountBtn.superview!)
            make.top.bottom.equalTo(releaseCommentBtn)
            make.left.equalTo(commentImageView)
        }
 

    }
    
    //MARK:- 设置文章评论列表
    private func setupAritcleCommentUI(){
        addSubview(releaseCommentBtn)
        releaseCommentBtn.snp.makeConstraints { (make) in
            make.left.equalTo(50*LayoutWidthScale)
            make.right.equalTo(-50*LayoutWidthScale)
            make.top.equalTo(20*LayoutHeightScale)
            make.bottom.equalTo(-20*LayoutHeightScale)
        }
    }
    
    
    //MARK:- 顶部线
    fileprivate lazy var topLine:UILabel =  UILabel.unline()
    
    //MARK:- 发布评论按钮
    fileprivate lazy var releaseCommentBtn:UIButton = UIButton(title: " 我也说两句", imageName: "edit", backImageName: "input_box.png",highlightedImageName:"input_box.png",selBackImageName:"input_box.png", target: self, selector: #selector(releaseComment), font: UIFont.font(psFontSize: 40), titleColor: UIColor.init(hexString: "#cccccc"))
    //MARK:- 评论数
    fileprivate lazy var commentCountLabel:UILabel = UILabel(text: "0", font: UIFont.font(psFontSize: 50), textColor: THEMECOLOR)
    
    //MARK:- 评论图片 
    fileprivate lazy var commentImageView:UIImageView = UIImageView(image: UIImage.getImage("comment_count.png"))
    
    //MARK:- 点击跳转到评论数按钮
    fileprivate lazy var commentCountBtn:UIButton = UIButton(target: self, selector: #selector(jumpToComment))
    
    
    
    //MARK:- 发布评论
    @objc private func releaseComment(){
      printData(message:  #function)
        
        delegate?.commentToolView(self, commentType: .ReleaseComment)
    
    
    }
    
    //MARK:- 跳转到详情
    @objc private func jumpToComment(){
    
        printData(message:  #function)
        delegate?.commentToolView(self, commentType: .JumpToComment)
    
    }
    
    //MARK:- 初始化失败
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
