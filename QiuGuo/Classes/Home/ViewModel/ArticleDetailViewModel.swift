//
//  ArticleDetailViewModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/9.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class ArticleDetailViewModel: BaseViewModel {


    //MARK:- 文章id
    var ID:Int = 0
    
    var articleModelPointer:UInt8=0

    //MARK:- 文章详情模型
     var articleDetailModel:ArticleDetailModel?{
        get{
         let key = String.getString(intData: self.ID)
          if self.articleModels[key] != nil{
             return self.articleModels[key]
           }
            return ArticleDetailModel()
        }
    }
    
    //MARK:- 文章详情模型数组
    var articleModels:[String:ArticleDetailModel] = [String:ArticleDetailModel]()
    
    
    
    //MARK:- 加载文章详情
    func loadArticleDetail(successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock){
        
        let urlString = AppRootUrl + "/article/Article/getArticle/"
        NetworkTool.request(type: .POST, urlString: urlString, paramters: ["ID":self.ID,"isIos":1], finishedCallback: { (result) in
            if let dict = result["data"].dictionaryObject{
                let key = String.getString(intData: self.ID)
                self.articleModels[key] = ArticleDetailModel.init(dict:dict)
            }
            successCallBack(result)
            
            
        }) {[weak self] (error) in
            self?.settingFailure()
            failureCallBack(error)
        }

    }
}









