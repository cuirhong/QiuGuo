//
//  SpecialViewModel.swift
//  QiuGuo
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit




class SpecialViewModel: BaseViewModel {

    // MARK: - 获取首页专题列表
    class func loadSpecialData(success: @escaping SucceedBlock,failure:@escaping FailureBlock){
        let url = AppRootUrl + "/article/Article/getSpecials"
        NetworkTool.request(type: .POST, urlString: url, paramters: nil, finishedCallback: { (result) in
            success(result)
        }) { (error) in
            failure(error)
        }

    }

    
    




}
