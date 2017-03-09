//
//  ArticleListViewModel.swift
//  QiuGuo
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class ArticleListViewModel: BaseViewModel {

     var articleListArr:[ArticleListModel] = []
    
    lazy var SpecialID:Int = -1

    // MARK: - 加载咨询列表数据
    func loadArticleListData(successCallBack: SucceedBlock?,failureCallBack: FailureBlock?){
        let url = AppRootUrl + "/article/Article/getArticleList"
        NetworkTool.request(type: .POST, urlString: url, paramters: ["SpecialID":self.SpecialID,"page":self.page,"rows":self.rows], finishedCallback: {[weak self] (result) in
            let dataArr = result["data"]["data"]
            var newModelArr = [ArticleListModel]()
            if let arr = dataArr.arrayObject{
                
                for dict in arr  {
                    let model = ArticleListModel.init(dict: (dict as? Dictionary)!)
                    newModelArr.append(model)
                }                
            }

            self?.articleListArr = (self?.setupRefresh( preArray: (self?.articleListArr)!, newArray: newModelArr) as? [ArticleListModel])!
            successCallBack!(result)
        }) { (error) in
            failureCallBack!(error)
        }
    }
}
