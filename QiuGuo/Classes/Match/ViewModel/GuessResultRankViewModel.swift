//
//  GuessResultRankViewModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/15.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//


class GuessResultRankViewModel: BaseViewModel {
    
    //MARK:- 竞猜编号
    var quizId:Int = 0

    //MARK:- 竞猜结果用户列表
    var guessResultUserArr:[GuessResultUserModel]? = [GuessResultUserModel]()

    
    
    //MARK:- 加载用户竞猜排名列表
    func loadGuessResultRankList(successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock){
        let urlString = jointUrlString("/quizs/Football/quizUser/", paramters: ["quizId":String.getString(intData: self.quizId),"rows":String.getString(intData: self.rows),"page":String.getString(intData: self.page)])
        NetworkTool.request(type: .GET, urlString: urlString, isQiuUrl: true, paramters: nil, finishedCallback: {[weak self] (result) in
            var modelArr:[GuessResultUserModel] = [GuessResultUserModel]()
            
            if let dataArr = result["data"]["data"].arrayObject{
                 var rankNum = 1
                for dataDict in dataArr{                   
                    if let dict = dataDict as? Dictionary<String, Any>{
                        let model = GuessResultUserModel.init(dict:dict)
                        model.resultRankNum = rankNum
                        modelArr.append(model)
                        rankNum += 1
                    }
                }
            }
            self?.guessResultUserArr = self?.setupRefresh(preArray: (self?.guessResultUserArr)!, newArray: modelArr) as? [GuessResultUserModel]
            successCallBack(result)
        }) {[weak self] (error) in
            self?.settingFailure()
            failureCallBack(error)
        }
    }
    
    
    

}
