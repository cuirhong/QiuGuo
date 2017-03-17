//
//  MatchGuessModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/15.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

//MARK:- 赛事联赛栏目
class MatchGuessModel: BaseModel {
    
    //MARK:- Model
    var ID:Int = 0
    
    //MARK:- 房主的用户编号
    var UserID:Int = 0
    
    //MARK:- 房主的头像
    var UserHeadimgurl:String = ""
    
    //MARK:- 竞猜的标题
    var Title:String = ""
    
    //MARK:- 竞猜场数
    var TotalTouts:Int = 0
    
    //MARK:- 最低猜中比赛数
    var MinTouts:Int = 0
    
    //MARK:- 总投注额
    var TotalCosts:Int = 0
    
    //MARK:- 投注额
    var Costs:Int = 0
    
    //MARK:- 总参与人数
    var People:Int = 0
    
    //MARK:- 最大参与人数
    var MaxPeople:Int = 0
    
    //MARK:- 开始比赛时间
    var StartTime:String = ""
    
    //MARK:- 下注总倍数
    var Multiple:Int = 0
    
    //MARK:- 竞猜成功中人数
    var RightPeople:Int = 0
    
    //MARK:- 点击数（查看人次）
    var ClickNum:Int = 0
    
    //MARK:- 竞猜类型(1：足球竞猜，2：问答竞猜)
    var Genre:Int = 0
    
    //MARK:- 是否被取消的竞猜
    var Cancel:Bool = false
    
    //MARK:- 0 正常 11 不归还球票
    var BalanceType:Int = 0
    
    //MARK:- 竞猜状态。（0：等待开始，1：正在进行，2：已结束等待结算，3：已结束完成结算，4：结算异常）
    var Status:Int = 0
    
    //MARK:- 足球关联的比赛信息
    var Matchs:[Match] = [Match]()
    
    //MARK:- 竞猜的用户头像，最后竞猜的8位
    var UserMatchs:[UserMatch] = [UserMatch]()
    
    //MARK:- 自定义玩法规则，如果不为空表示自定义
    var CustomRules:String = ""
    

    //MARK:- 重写夫类方法
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "UserMatchs"{
            var matchModelArr:[UserMatch] = [UserMatch]()
            if let matchArr = value as? Array<AnyObject>{
                for dict in matchArr {
                    if let dataDict = dict as? Dictionary<String, Any>{
                        let matchModel = UserMatch.init(dict:dataDict)
                        matchModelArr.append(matchModel)
                    }
                }
            }
            super.setValue(matchModelArr, forKey: key)        
        }else if key == "Matchs"{
            var matchModelArr:[Match] = [Match]()
            if let matchArr = value as? Array<AnyObject>{
                for dict in matchArr {
                    if let dataDict = dict as? Dictionary<String, Any>{
                        let matchModel = Match.init(dict:dataDict)
                        matchModelArr.append(matchModel)
                    }
                }
            }
            super.setValue(matchModelArr, forKey: key)
        }else{
          super.setValue(value, forKey: key)
        }
    }

}





/// 竞猜的用户头像
class UserMatch: BaseModel {
    var UserID:Int = 0
    var UserHeadimgurl:String = ""
    
}


/// 比赛信息
class Match: BaseModel {
    
    //MARK:- 竞猜编号
    var QuizID:Int = 0
    
    //MARK:- 赛事ID
    var MatchID:Int = 0
    
    
    //MARK:- 所属联赛编号
    var LeagueID:Int = 0
    
    
    //MARK:- 主队的编号
    var TeamID:Int = 0
    
    //MARK:- 客队的编号
    var BeTeamID:Int = 0
    
    //MARK:- 主队的名称
    var TeamName:String? = ""
    //MARK:- 客队名字
    var BeTeamName:String? = ""
    
    //MARK:- 主队队标
    var TeamLogo:String? = ""
    
    //MARK:- 客队队标
    var BeTeamLogo:String? = ""
    
    //MARK:- 总参与人数
    var People:Int = 0
    
    //MARK:- 开始时间
    var StartTime:String? = ""
    
    //MARK:- 选择胜的人数
    var Win:Int = 0
    
    //MARK:- 选择平的人数
    var Draw:Int = 0
    
    //MARK:- 选择平的人数
    var Loss:Int = 0

    //MARK:- 比赛结果（0：等待比赛结果。3：主队赢。4：平局。5：客队赢）
    var Results:Int = 0

    //MARK:- 赛附属的赛事名称
    var LeagueName:String? = ""
    
    //MARK:- 比赛的状态 (0：等待开赛，2：比赛结束)
    var Status:Int = 0

    
     
}












