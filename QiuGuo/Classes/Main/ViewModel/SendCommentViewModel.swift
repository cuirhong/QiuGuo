//
//  SendCommentViewModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/23.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class SendCommentViewModel: BaseViewModel {
    
    //MARK:- 文章ID 【回复的时候可以不传递】
    var ID:Int = 0
    
    //MARK:- 评论或者回复内容
    var content:String = ""
    
    //MARK:- 回复的时候，点击的评论ID
    var onclickID:Int = 0
    
    //MARK:- 评论类型(1：文章，2：赛事，3：竞猜)
    var DataType:Int = 0
    

    //MARK:- 发送评论
    func sendComment(successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock){
        
        let urlString = AppRootUrl + "/article/Article/sendContent"

        let paramters = ["UserID":UserInfo.loadAccount()?.UserID ?? 0,"UserToken":UserInfo.loadAccount()?.UserToken ?? "","ID":self.ID,"content":self.content,"onclickID":self.onclickID,"DataType":self.DataType] as [String : Any]
    
        NetworkTool.request(type: .POST, urlString: urlString, isQiuUrl: true, paramters: paramters, finishedCallback: { (result) in
            let code = result["code"].intValue
            if code == 1{
            //评论成功
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: reloadDataCommentNotifName), object: "1")
                }
            }
           
            successCallBack(result)
        }) { (error) in
            failureCallBack(error)
        }
    }
    
 
}


// MARK: - Description
extension SendCommentViewModel{

    //MARK:- 删除评论
    func deleteComment(successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock){
    
        let urlString = AppRootUrl + "/user/UserCenter/deleteContent"
        let paramters = ["UserID":UserInfo.loadAccount()?.UserID ?? 0,"UserToken":UserInfo.loadAccount()?.UserToken ?? "","ID":self.ID] as [String : Any]
        NetworkTool.request(type: .POST, urlString: urlString, isQiuUrl: true, paramters: paramters, finishedCallback: { (result) in
            let code = result["code"]
            if code == 1 {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: reloadDataCommentNotifName), object: "1")
                }
                HUDTool.show(showType: .Success, text: "删除成功")
            }else{
                HUDTool.show(showType: .Failure, text: "删除失败")
            }
            successCallBack(result)
        }) { (error) in
             HUDTool.show(showType: .Failure, text: error.debugDescription)
            failureCallBack(error)
        }

    }
}


// MARK: - 点赞
extension SendCommentViewModel{

    func clickLike(successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock){
     
        let urlString = AppRootUrl + "/article/Article/hits"
        let paramters = ["CommentID":self.ID] as [String : Any]
        NetworkTool.request(type: .POST, urlString: urlString, isQiuUrl: true, paramters: paramters, finishedCallback: { (result) in
      
            successCallBack(result)
        }) { (error) in
           
            failureCallBack(error)
        }
    }


}

// MARK: - 举报评论
extension SendCommentViewModel{
    
    func reportComment(reason:String, successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock){
    
        let urlString = AppRootUrl + "/article/Article/tipoff"
        let paramters = ["CommentID":self.ID,"DataID":self.onclickID,"Reasons":reason] as [String : Any]
        NetworkTool.request(type: .POST, urlString: urlString, isQiuUrl: true, paramters: paramters, finishedCallback: { (result) in
            
            successCallBack(result)
        }) { (error) in
            
            failureCallBack(error)
        }

    
    
    
    }





}




