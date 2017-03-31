//
//  MeViewModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/29.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit


class MeViewModel: BaseViewModel {
    
    //MARK:- 用户中心首页
    func userCenter(successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock){
        
        let urlString = AppRootUrl + "/user/UserCenter/index"
        let partermers = ["UserID":UserInfo.loadAccount()?.UserID ?? 0,"UserToken":UserInfo.loadAccount()?.UserToken ?? ""] as [String : Any]
        
        NetworkTool.request(type: .POST, urlString: urlString, isQiuUrl: true, paramters: partermers, finishedCallback: { (result) in
            
            successCallBack(result)
        }) { (error) in
            failureCallBack(error)
        }

    }
    
    
    
    
    
    
    
    
}





