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
    
    //MARK:- 文章详情模型
    var articleDetailModel:ArticleDetailModel = ArticleDetailModel()
    
    
    
    
    //MARK:- 加载文章详情
    func loadArticleDetail(successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock){
        
        let urlString = AppRootUrl + "/article/Article/getArticle/"
        NetworkTool.request(type: .POST, urlString: urlString, paramters: ["ID":self.ID,"isIos":1], finishedCallback: { (result) in
            if let dict = result["data"].dictionaryObject{            
            self.articleDetailModel = ArticleDetailModel.init(dict:dict)
            }
            successCallBack(result)
            
            
        }) { (error) in
             failureCallBack(error)
        }

    }













}
