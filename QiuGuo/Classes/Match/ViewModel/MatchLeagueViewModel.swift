//
//  MatchLeagueViewModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/7.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit



class MatchLeagueViewModel: BaseViewModel {
    
    lazy var matchLeagueArr:[MatchLeagueModel] = []
    
    func loadMatchLeague(successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock) {
        let urlString = AppRootUrl + "/match/Match/getLeagues"
        NetworkTool.request(type: .POST, urlString: urlString, paramters: nil, finishedCallback: {[weak self] (result) in
            let dataArr = result["data"]
            if let arr = dataArr.arrayObject{
                self?.matchLeagueArr = []
                for dict in arr{                    
                    let model = MatchLeagueModel.init(dict:dict as! [String : Any])
                    self?.matchLeagueArr.append(model)   
                }
            
            }
            successCallBack(result)
        }) { (error) in
             failureCallBack(error)
        }
    
        
        
    }
    
    
    
    
    
    
    
}









