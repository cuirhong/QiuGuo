//
//  ArticleListViewModel.swift
//  QiuGuo
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class ArticleListViewModel: BaseViewModel {

    lazy var articleListArr:[ArticleListModel] = []

    // MARK: - 加载barner数据
    func loadArticleListData(SpecialID:Int,successCallBack: SucceedBlock?,failureCallBack: FailureBlock?){
        let url = AppRootUrl + "/article/Article/getBarnerList"
        NetworkTool.request(type: .POST, urlString: url, paramters: ["SpecialID":SpecialID,"amount":"15"], finishedCallback: {[weak self] (result) in
            
            let dataArr = result["data"]
            if let arr = dataArr.arrayObject{
                self?.articleListArr = []
                for dict in arr  {
                    let model = ArticleListModel.init(dict: (dict as? Dictionary)!)
                    self?.articleListArr.append(model)
                }                
            }
            successCallBack!(result)
        }) { (error) in
            failureCallBack!(error)
        }
    }
}