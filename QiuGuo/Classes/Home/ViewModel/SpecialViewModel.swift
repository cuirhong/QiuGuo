//
//  SpecialViewModel.swift
//  QiuGuo
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class SpecialViewModel: BaseViewModel {
    
    lazy var spericalModels:[SpecialModel] = []


    // MARK: - 获取首页专题列表
     func loadSpecialData(success: @escaping SucceedBlock,failure:@escaping FailureBlock){
        let url = AppRootUrl + "/article/Article/getSpecials"
        NetworkTool.request(type: .POST, urlString: url, paramters: nil, finishedCallback: {[weak self] (result) in
            let dataArr = result["data"]

            if let arr = dataArr.arrayObject{
                self?.spericalModels = []
                for dict in arr  {
                    let model = SpecialModel.init(dict: (dict as? Dictionary)!)
 
                    self?.spericalModels.append(model)
                }
            }
            if self?.spericalModels.count == 0{
              self?.dataAbnormalType = .noData
            }
            success(result)
        }) {[weak self] (error) in
            self?.settingFailure()
            failure(error)
        }

    }

    
    




}
