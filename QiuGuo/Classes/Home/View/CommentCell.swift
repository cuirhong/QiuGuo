//
//  CommentCell.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/24.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

//点击cell的响应类型
enum ClickResponseType{
    case UnflodBasicComment;//展开基本评论
    case ClickLike;//点赞
    case DisplayAllReplyComment;//显示所有的回复评论
    

}

//代理
protocol CommentCellDelegate:NSObjectProtocol {
    func commentCell(_ commentCell:CommentCell?, singleCommentView:SingleCommentView, clickResponseType:ClickResponseType)
}

/// cell
class CommentCell: BaseCollectionViewCell {
    
    //MARK:- 代理
    weak var delegate:CommentCellDelegate?
    
    //MARK:- 评论模型
    var commentModel:CommentModel?{
        didSet{
            commentView?.delegate = delegate
            
            if (commentModel?.frontArray.count)! > 0{
                
             
                let height:CGFloat = (commentModel?.getTotalReplyCommentHeight())!
               
                commentView?.replyCommentBottomView.snp.updateConstraints({ (make) in
                    make.height.equalTo(height)
                })
                
                let replyCommentViewController = CommentListViewController()
                replyCommentViewController.commentListType = .ReplyCommentList
                replyCommentViewController.commentViewModel.commentDataArray = (commentModel?.frontArray)!
                if let controller = delegate as? UIViewController{
                  controller.addChildViewController(replyCommentViewController)
                }
                (delegate as? UIViewController)?.addChildViewController(replyCommentViewController)
                commentView?.replyCommentBottomView.addSubview(replyCommentViewController.view)
                replyCommentViewController.view.snp.makeConstraints({ (make) in
                    make.top.right.bottom.left.equalTo(replyCommentViewController.view.superview!)
                })
                
            }else{
                commentView?.replyCommentBottomView.snp.updateConstraints({ (make) in
                    make.height.equalTo(0)
                })
            }

            
            commentView?.commentModel = commentModel
            
            commentView?.refreshLayout(layout: (commentModel?.commentLayout)!)
 
           
        }
    }
    
    
    //MARK:- 创建cell
    class func getCommentCell(viewType:CommentViewType,collectionView:UICollectionView,indexPath:IndexPath,cellIdentifier:String)->CommentCell{
        let cell:CommentCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CommentCell
        if cell.commentView == nil{
           cell.setupView(viewType: viewType)
        }
        return cell

    }
    

    
    //MARK:- 设置界面
    private func setupView(viewType:CommentViewType){
        switch viewType {
        case .BasicComment:
            commentView = getBasicCommentView()
        case .replyComment:
            commentView = getReplyCommentView()
        default:
            break
        }
    
        if commentView != nil{
            contentView.addSubview(commentView!)
            commentView?.snp.remakeConstraints({ (make) in
                make.top.right.bottom.left.equalTo((commentView?.superview!)!)
            })
        
        }
    }
    
    //MARK:- 回复评论
    private func getReplyCommentView()->SingleCommentView{
        let replyCommentView = SingleCommentView(commentLayout: CommentModel.getCommentLayout(commentViewType:.replyComment), delegate: self.delegate, commentCell: self)
    

       
        return replyCommentView
        
    }
    
    
    //MARK:- 创建基本评论界面
    private func getBasicCommentView()->SingleCommentView{
        let basicCommentView = SingleCommentView(commentLayout: CommentModel.getCommentLayout(commentViewType:.BasicComment), delegate: self.delegate, commentCell: self)
        return basicCommentView
    }
    
   
    

    //MARK:- 评论view
      var commentView:SingleCommentView?
    


}






