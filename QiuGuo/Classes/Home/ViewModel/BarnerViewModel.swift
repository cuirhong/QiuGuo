//
//  BannerViewModel.swift
//  QiuGuo
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class BarnerViewModel: BaseViewModel {
    lazy var barnerArr:[BarnerModel] = []
    
    // MARK: - 加载barner数据
    func loadBarnerData(SpecialID:Int,successCallBack: SucceedBlock?,failureCallBack: FailureBlock?){
        let url = AppRootUrl + "/article/Article/getBarnerList"
        NetworkTool.request(type: .POST, urlString: url, paramters: ["SpecialID":SpecialID,"amount":"15"], finishedCallback: {[weak self] (result) in
          
            let dataArr = result["data"]
            if let arr = dataArr.arrayObject{
                self?.barnerArr = []
                for dict in arr  {
                    let model = BarnerModel.init(dict: (dict as? Dictionary)!)
                    self?.barnerArr.append(model)
                }
               
            }
            guard self?.barnerArr.count == 0 else {
               successCallBack!(result)
                return
            }
            
            failureCallBack!("获取数据出错")
            
            
        }) { (error) in
            failureCallBack!(error)
        }
    }
}






