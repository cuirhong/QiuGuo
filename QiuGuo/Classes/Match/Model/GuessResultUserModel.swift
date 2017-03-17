//
//  GuessResultUserModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/15.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class GuessResultUserModel: BaseModel {
    //MARK:- 用户ID
    var UserID:Int = 0
    
    //MARK:- 用户的昵称
    var UserName:String = ""
    
    //MARK:- 用户的头像地址
    var UserHeadimgurl:String = ""
    
    //MARK:- 赚取的积分数
    var IncomeExp:Int = 0
    
    //MARK:- 猜对的场次(结束后进行统计得到)
    var RightNum:Int = 0
    
    
    
    //MARK:- 结果排名名次(自己添加)
    var resultRankNum:Int = 0
  
    
  
}


