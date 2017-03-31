//
//  MeModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/29.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
enum MeTypeID:Int{
    
    case Null = 0;
    
    case MeScore = 201;
    case MeTicket = 202;
    case MeComment = 206;
    
    
    case Setting = 301;
    
    
    
    
}

class MeModel: BaseModel {
    
    var ID:Int = 0
    
    var imageName:String = ""
    
    var title:String = ""
    
    var controller:String = ""
    
    var _count:Int = 0
    var count:Int!{
    
        get{
            switch ID {
            case MeTypeID.MeComment.rawValue:
                return 0
            case MeTypeID.MeScore.rawValue:
                return UserInfo.loadAccount()?.Exp
            case MeTypeID.MeTicket.rawValue:
                return UserInfo.loadAccount()?.Point
            default:
                break
            }
          return _count
        }
    }
    
    var isNeedLogin:Int = 1
   
}
