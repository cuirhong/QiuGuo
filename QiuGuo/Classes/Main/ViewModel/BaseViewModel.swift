//
//  BaseViewModel.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/27.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

//MARK:- 刷新类型
enum ViewModelRefreshType {
    case PullDownRefresh;//下拉刷新
    case UpDownRefresh;//上啦加载
}

class BaseViewModel: NSObject {
    
    //MARK:- 刷新的类型
    lazy var refreshType:ViewModelRefreshType? = .PullDownRefresh
    
    //MARK:- 上啦加载的时候是否还有下一页
    lazy var isEnd:String?="0"
    
    //MARK:- 下拉刷新的时候是否还有上一页
    lazy var isHead:String?="0"
    
    //MARK:- 设置刷新基本数据
    func setupRefresh(isHead:String,isEnd:String, preArray:[Any],newArray:[Any]) -> [Any] {
        self.isHead = isHead
        self.isEnd = isEnd
        
        if self.refreshType == .PullDownRefresh{
           return newArray
        }else{
            var array = preArray
            array.append(newArray as AnyObject)
            return array
            
        }
   
    }
    
    
    
    

}
