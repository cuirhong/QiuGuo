//
//  CommentListViewModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/24.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommentListViewModel: BaseViewModel {

    //MARK:- 文章ID
    var ID:Int = 0

    //MARK:- 热门 hot 最新 new
    var type:String = "hot"
    
    //MARK:- 参数
    var paramters:[String:Any]?{
        get{
        
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
    
    
    //MARK:- 模型数组
    var commentDataArray:[CommentModel] = []
    
    
    
    
    //MARK:- 设置评论数据
    func setupData(result:JSON){
    
        var dataModelArray:[CommentModel] = []
        if let dataArray = result["data"]["data"].arrayObject as? [[String:Any]] {
            for dataDict in dataArray {
                let commentModel = CommentModel(dict: dataDict)
                
                commentModel.commentLayout = CommentModel.getCommentLayout(commentViewType: .BasicComment)
                commentModel.displyType = 0
                dataModelArray.append(commentModel)
                
                if let frontCommentArray = dataDict["front"] as? [[String:Any]]{
                    var floorCount = 1
                    commentModel.displyType = 1
                    for dict in frontCommentArray{
                        let model = CommentModel(dict: dict)
                        model.commentLayout = CommentModel.getCommentLayout(commentViewType: .replyComment)
                        model.displyType = 2
                        
                        model.floorCount = floorCount
                        floorCount += 1
                        commentModel.frontArray.append(model)
                    }
                }
            }
        }
        
        
        self.commentDataArray = self.setupRefresh(preArray: self.commentDataArray, newArray: dataModelArray) as! [CommentModel]
        
        
        
        if self.commentDataArray.count == 0{
            self.dataAbnormalType = .noData
            
        }

    }
    
    
}


extension CommentListViewModel{
    //MARK:- 加载评论
    func loadCommentList(commentListType:CommentListType, successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock){
        var urlString = ""
        var paramters = [String:Any]()
        
        
        switch commentListType {
        case .MeComment:
            urlString = AppRootUrl + "/user/UserCenter/myContent"
            paramters = ["rows":self.rows,"page":self.page,"UserID":UserInfo.loadAccount()?.UserID ?? "","UserToken":UserInfo.loadAccount()?.UserToken ?? ""] as [String : Any]
        case .NormalCommentList:
            urlString = self.urlString
            paramters = self.paramters!
        default:
            return
        }

        NetworkTool.request(type: .POST, urlString: urlString, isQiuUrl: true, paramters: paramters, finishedCallback: {[weak self] (result) in
            self?.setupData(result: result)
            successCallBack(result)
        }) { (error) in
            failureCallBack(error)
        }
    }
   
}











