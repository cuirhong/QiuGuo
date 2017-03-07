//
//  MatchListModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/7.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit


//MARK:- 赛事联赛栏目
class MatchListModel: BaseModel {
    
    //MARK:- 赛事ID
    var MatchID:Int? = 0
    
    //MARK:- 主队队标
    var TeamLogo:String? = ""
    
    //MARK:- 客队队标
    var BeTeamLogo:String? = ""
    
    //MARK:- 第几轮
    var Round:Int? = 0
    
    //MARK:- 主队ID
    var TeamID:Int? = 0
    
    //MARK:- 客队ID
    var BeTeamID:Int? = 0
    
    //MARK:- 主队名字
    var TeamName:String? = ""
    
    //MARK:- 客队名字
    var BeTeamName:String? = ""
    
    //MARK:- 开始时间
    var StartTime:String? = ""
    
    //MARK:- 评论数量
    var Score:Int? = 0
    
    //MARK:- 评论数量
    var BeScore:Int? = 0
    
    //MARK:- 比赛结果（0：等待比赛结果。3：主队赢。4：平局。5：客队赢。6：赛事取消）
    var Results:Int? = 0
    
    //MARK:- 联赛ID
    var LeagueID:Int? = 0
    
    //MARK:- 联赛名称
    var LeagueName:String? = ""
    
    //MARK:- 0未开始 1 进行中 4 已结束
    var status:String? = ""
    
    //MARK:- 名称
    var RoundName:String? = ""
    
    
    
    
    
}
