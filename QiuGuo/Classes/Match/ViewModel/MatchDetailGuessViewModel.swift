//
//  MatchDetailGuessViewModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/13.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit



class MatchDetailGuessViewModel: BaseViewModel {


    //MARK:- 竞猜的编号
    var quizId:Int = 0
    
    //MARK:- 赛事的编号
    var matchId:Int = 0
    
    //MARK:- 比赛竞猜模型
    var matchGuessModel:MatchGuessModel?
    
    
    
    //MARK:- 加载比赛对战数据
    func loadDataMatchGuess(successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock){
        let urlString = jointUrlString("/quizs/Football/quizInfo/", paramters: ["quizId":String.getString(intData: self.quizId),"matchId":String.getString(intData: self.matchId),"UserID":String.getString(intData: UserInfo.loadAccount()?.UserID),"UserToken":UserInfo.loadAccount()?.UserToken ?? ""])
        
        NetworkTool.request(type: .GET, urlString: urlString, isQiuUrl: true, paramters: nil , finishedCallback: {[weak self] (result) in
            if let data = result["data"].dictionaryObject{
                self?.dataAbnormalType = .noAbnormal
                self?.matchGuessModel = MatchGuessModel.init(dict:data)
                
                
            }else{
             self?.dataAbnormalType = .noData
            
            }
            successCallBack(result)
        }) { (error) in
             failureCallBack(error)
        }
    }
    
    








}
