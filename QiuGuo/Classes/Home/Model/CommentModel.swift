//
//  CommentModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/27.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import Foundation
import YYText


class CommentModel: BaseModel {
    
    
    //MARK:- 评论ID
    var ID:Int = 0
    
    //MARK:- 评论内容
    var Content:String = ""
    
    //MARK:- 头像
    var UserHeadimgurl:String = ""
    
    //MARK:- 点赞数目
    var LikeNum:Int = 0
    
    //MARK:- 时间
    var _Time:String = ""
    var Time:String!{
        get{
          return _Time
        
        }
        
        set{
            _Time = newValue
        }
    }
    
    //MARK:- 数据ID 新闻就是文章ID
    var DataID:Int = 0
    
    //MARK:- 类型 1 文章
    var DataType:Int = 0
    
    //MARK:- 用户id
    var UserID:Int = 0
    
    //MARK:- MARK
    var UserName:String = ""
    
    
    
    
    
    // MARK: - 自己添加属性
    //被评论数组
    var frontArray:[CommentModel] = []
    //评论布局
    var commentLayout:CommentLayout = CommentLayout()
    //楼层数
    var floorCount:Int = 0
    //textView
    private lazy var commentLabel:YYLabel = UILabel.getCommentLabel()
    

    
    //评论正常的高度
    private var _contenNormalHeight:CGFloat = -1
     var contentNormalHeight:CGFloat!{
        get{
            if _contenNormalHeight >= 0{
             return _contenNormalHeight
            
            }
            let frame = CGRect(x: 0, y: 0, width: commentLayout.commentTextWidth, height: CGFloat.greatestFiniteMagnitude)
            commentLabel.frame = frame
        
             commentLabel.numberOfLines = limitOfLines
            commentLabel.text = Content
            
            if let noramlHeight = commentLabel.textLayout?.textBoundingSize.height {
                self.contentNormalHeight = noramlHeight
            }else{
                
                self.contentNormalHeight = 0
                
            }
            return _contenNormalHeight
        }
    
        set{
            _contenNormalHeight = newValue
        }
    }
    
    
    //评论展开的高度
    private var _contentMaxHeight:CGFloat = -1
     var contentMaxHeight:CGFloat{
        get{
            if _contentMaxHeight >= 0 {
              
              return _contentMaxHeight
            }
            let frame = CGRect(x: 0, y: 0, width: commentLayout.commentTextWidth, height: CGFloat.greatestFiniteMagnitude)
            commentLabel.frame = frame
            commentLabel.numberOfLines = 0
            commentLabel.text = Content
            
            if let textHeight = commentLabel.textLayout?.textBoundingSize.height{
                self.contentMaxHeight = textHeight
            }else{
            
                self.contentMaxHeight = 0
            
            }
            
            return _contentMaxHeight
        }
        
        set{
          _contentMaxHeight = newValue
        }
    
    }
    //评论显示的高度
    var contentDisplyHeight:CGFloat{    
        get{
            if displyLines != limitOfLines{
                 return contentMaxHeight
            }else{
                return contentNormalHeight
            }
        }
    }
    
    //限制多少行
    var limitOfLines:UInt = 6
    //显示多少行
    var displyLines:UInt = 6
    
    //显示类型(原评论／还是回复评论的评论)0:单个评论 1:原评论加回复评论的评论 2:单个回复评论的评论
    var displyType:Int = 0
    
    //展开全部 -1:不需要展开所有评论按钮，0:不展开评论 1:展开评论
    private var _fiexildAllContent:Int = 0
    var fiexildAllContent:Int{
        get{
        
            if contentMaxHeight > contentNormalHeight {
                return _fiexildAllContent
            }
            return -1
        }
        
        set{
           _fiexildAllContent = newValue
            if newValue == 1 {
             displyLines = 0           
            }
        }
    }
    

}







extension CommentModel{

    //MARK:- 创建评论布局
    class func getCommentLayout(commentViewType:CommentViewType)->CommentLayout{
        let clickBtnRight = 50*LayoutWidthScale
        let nickNameLeft = 155*LayoutWidthScale
        var commentLayout = CommentLayout()
        if commentViewType == .BasicComment{
        
            commentLayout = CommentLayout(commentViewType: .BasicComment, clickBtnTop: 52*LayoutHeightScale, clickBtnRight: clickBtnRight, nickNameLeft: nickNameLeft, commentTextWidth: ScreenWidth-nickNameLeft-clickBtnRight)
        }else{
        
            let newClickBtnRight = 35*LayoutWidthScale
            let newNickNameLeft = 96*LayoutWidthScale

            commentLayout = CommentLayout(commentViewType: .replyComment, clickBtnTop: 50*LayoutHeightScale, clickBtnRight: newClickBtnRight, nickNameLeft: newNickNameLeft, commentTextWidth: ScreenWidth-nickNameLeft-clickBtnRight-newNickNameLeft-newClickBtnRight)
        }
        
        return commentLayout
    
    
    }
    
    
    
    //MARK:- 获取评论的高度
    
    func getCommentCellHeight()->CGFloat{
    
        var height:CGFloat = 0
        if displyType == 0 {
            height = commentLayout.clickBtnTop + nickNameHeight + 26 * LayoutHeightScale + timeLabelHeight + 58 * LayoutHeightScale +  contentDisplyHeight + 70*LayoutHeightScale
            if fiexildAllContent == 0 {
                height += (fiexibleBtnHeight + 68*LayoutHeightScale)
                
            }
        }else {
            
            if displyType == 1{
                let frontCommentHeight:CGFloat = getTotalReplyCommentHeight()
                
                height  = commentLayout.clickBtnTop + nickNameHeight + 26 * LayoutHeightScale + timeLabelHeight  + 26 * LayoutHeightScale + frontCommentHeight + 60*LayoutHeightScale + contentDisplyHeight + 70*LayoutHeightScale
                if fiexildAllContent == 0 {
                    
                    height += (fiexibleBtnHeight + 68*LayoutHeightScale)
                }
            }else{
                height = getOneReplyCommentHeight()
            }
        }
        return height

    }
    
    //MARK:- 获取所有回复评论的高
    func getTotalReplyCommentHeight()->CGFloat{
     var frontCommentHeight:CGFloat = 0
        for model in frontArray {
            let replySingleHeight = model.getOneReplyCommentHeight()
            frontCommentHeight += replySingleHeight
            
        }
      return frontCommentHeight
    }
    
    //MARK:- 一个回复评论的高
    func getOneReplyCommentHeight()->CGFloat{
        var height = commentLayout.clickBtnTop + nickNameHeight + 58 * LayoutHeightScale + contentDisplyHeight + 55 * LayoutHeightScale
        if fiexildAllContent == 0{
           height += (fiexibleBtnHeight + 68*LayoutHeightScale)
           
        }
        return height
    }

}







