//
//  MatchListViewModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/7.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit



class MatchListViewModel: BaseViewModel {
    //MARK:- 每页最多显示的信息数
    var rows:Int? = 10
    //MARK:- 当前页面
    var page:Int? = 1
    //MARK:- 赛事栏目ID
    var LeagueID:Int = 0
    //MARK:- 类型 head上滑 end 下滑 默认下滑
    var type:String? = "end"


    //MARK:- 比赛模型数组
    lazy var matchListArr:[[MatchListModel]] = []
    
    
    //MARK:- 加载比赛列表
    func loadMatchList(successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock) {
        let urlString = AppRootUrl + "/match/Match/getMatchList"
        NetworkTool.request(type: .POST, urlString: urlString, paramters: ["rows":self.rows as Any,"page":self.page as Any,"LeagueID":self.LeagueID,"type":self.type as Any], finishedCallback: {[weak self] (result) in
            let dataDict = result["data"]
            var modelArray = [[MatchListModel]]()
            if let dataArr  = dataDict["data"].array{
                for dict in dataArr{
                    if let arrayObject = dict["s"].arrayObject{
                        var sectionArray = [MatchListModel]()
                        for dictionary in arrayObject{
                            let model = MatchListModel.init(dict:dictionary as! [String : Any])
                            sectionArray.append(model)
                        }
                        modelArray.append(sectionArray)
                    }
                }
            }
            
            self?.matchListArr = self?.setupRefresh(isHead: dataDict["isHead"].stringValue, isEnd: dataDict["isEnd"].stringValue, preArray: (self?.matchListArr)! , newArray: modelArray) as! [[MatchListModel]]
            successCallBack(result)
            
        }) { (error) in
            failureCallBack(error)
        }
    }








}
