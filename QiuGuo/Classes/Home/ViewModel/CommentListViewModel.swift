//
//  CommentListViewModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/24.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit


class CommentListViewModel: BaseViewModel {

    //MARK:- 文章ID
    var ID:Int = 0

    //MARK:- 热门 hot 最新 new
    var type:String = "hot"
    
    //MARK:- 参数
    var paramters:[String:Any]?{
        get{
            self.rows = 20
            let dict = ["ID":self.ID,"type":self.type,"page":self.page,"rows":self.rows] as [String : Any]
            return dict
        }
    }
    
    //MARK:- url
    var urlString = AppRootUrl + "/article/Article/getContentList"
    
    //MARK:- 初始化
    convenience init(ID:Int) {
        self.init()
        self.ID = ID
        
    }
    
    
}


extension CommentListViewModel{
    //MARK:- 加载评论
    func loadCommentList(successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock){
        NetworkTool.request(type: .POST, urlString: self.urlString, isQiuUrl: true, paramters: self.paramters, finishedCallback: {[weak self] (result) in
            self?.dataAbnormalType = .noData
            successCallBack(result)
        }) { (error) in
            failureCallBack(error)
        }
    }
}










