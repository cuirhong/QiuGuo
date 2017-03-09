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
    
    //MARK:- 当前页
    lazy var page:Int=1
    
    //MARK:- 一页多少
    lazy var rows:Int=10
    
    //MARK:- 设置刷新基本数据
    func setupRefresh(isHead:String="",isEnd:String="", preArray:[Any],newArray:[Any]) -> [Any] {
      

        if self.refreshType == .PullDownRefresh{
            if isHead.isEmpty {
                if newArray.count <= self.rows {
                    //1:有 0:无 5:无效
                    self.isHead = "1"
                }else{
                    self.isHead = "0"
                }
            }
            self.isEnd = "5"
           return newArray
        }else{
            if isEnd.isEmpty{
                if newArray.count < self.rows {
                    self.isEnd = "0"
                }else{
                    self.isEnd = "1"
                }
            }
            self.isHead = "5"
            var array = preArray
            array.append(contentsOf: newArray)
            return array
            
        }
   
    }
    
    
    
    

}
