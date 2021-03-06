//
//  MatchListViewModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/7.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit



class MatchListViewModel: BaseViewModel {

    //MARK:- 赛事栏目ID
    var LeagueID:Int = 0
    //MARK:- 类型 head上滑 end 下滑 默认下滑
    var type:String? = "center"
    
    //MARK:- 滑动到某一个分区
    var scrollToSection:Int = 0


    //MARK:- 比赛模型数组
    lazy var matchListArr:[[MatchListModel]] = []
    
    
    //MARK:- 加载比赛列表
    func loadMatchList(successCallBack:@escaping SucceedBlock,failureCallBack:@escaping FailureBlock) {
        let urlString = AppRootUrl + "/match/Match/getMatchList"
        NetworkTool.request(type: .POST, urlString: urlString, paramters: ["rows":self.rows as Any,"page":self.page as Any,"LeagueID":self.LeagueID,"type":self.type ?? ""], finishedCallback: {[weak self] (result) in
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
            
            if self?.refreshType == .PullDownRefresh {
                if var listArr = self?.matchListArr.first,let newListArr = modelArray.first{
                    let model = listArr.first
                    let newModel = newListArr.first
                    if Date.isSameDate(dateString: model?.StartTime, date2String: newModel?.StartTime){
                       listArr.insert(contentsOf: newListArr, at: 0)
                        modelArray.removeFirst()
                    }
                }
            }else if self?.refreshType == .UpDownRefresh {
               
                if var listArr = self?.matchListArr.last,let newListArr = modelArray.first{
                    let model = listArr.first
                    let newModel = newListArr.first
                    if Date.isSameDate(dateString: model?.StartTime, date2String: newModel?.StartTime){
                        listArr.append(contentsOf: newListArr)
                        modelArray.removeFirst()
                    }
                }
            }
            
                self?.isHead = dataDict["isHead"].stringValue
                self?.isEnd = dataDict["isEnd"].stringValue

                let listModelArray = self?.setupRefresh(isHead: dataDict["isHead"].stringValue, isEnd: dataDict["isEnd"].stringValue, preArray: (self?.matchListArr)! , newArray: modelArray) as! [[MatchListModel]]
                
                if self?.refreshType == .PullDownRefresh {
                    for valueArr in listModelArray{
                        self?.matchListArr.insert(valueArr, at: 0)
                    }
                    if  listModelArray.count > 1  {
                        self?.scrollToSection =  listModelArray.count - 1
                    }else{
                        self?.scrollToSection = 0
                    }
                }else{
                     self?.matchListArr = self?.setupRefresh(isHead: dataDict["isHead"].stringValue, isEnd: dataDict["isEnd"].stringValue, preArray: (self?.matchListArr)! , newArray: modelArray) as! [[MatchListModel]]
                }
 
            
            
            if self?.matchListArr.count == 0{
              self?.dataAbnormalType = .noData
            }
            
            successCallBack(result)
            
        }) {[weak self] (error) in
            self?.settingFailure()
            failureCallBack(error)
        }
    }








}
