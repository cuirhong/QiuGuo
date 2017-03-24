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
           
            successCallBack(result)
        }) { (error) in
            failureCallBack(error)
        }
    
    
    }
    
    
}









