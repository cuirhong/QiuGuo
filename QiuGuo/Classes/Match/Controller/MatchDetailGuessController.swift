//
//  MatchDetailGuessController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/13.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import WebKit

/// 球赛详情对战
class MatchDetailGuessController: BaseViewController {
    
    //MARK:- webView
    private lazy var webView:WKWebView = WKWebView()
    
    //MARK:- 加载数据viewModel
     lazy var matchGuessViewModel = MatchDetailGuessViewModel()
    
    
    //MARK:- 加载view
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    //MARK:-  初始化数据
    override func initData() {
        super.initData()
        
    }
    
    //MARK:- 加载数据
    override func loadData() {
        super.loadData()
        
        matchGuessViewModel.loadDataMatchGuess(successCallBack: {[weak self] (result) in
            if self?.matchGuessViewModel.dataAbnormalType == .noAbnormal{
                DispatchQueue.main.async {
                     self?.setupView()
                }
               
            
            }else{
            
                self?.setUpDataAbnormalUI(topOffSet: 150*LayoutHeightScale, hintTextArr: ["抱歉","本场比赛暂无竞猜"])
            
            }
   
        }) { (error) in
          HUDTool.show(showType: .Failure, text: error.debugDescription)
        }
   
    }


}


// MARK: - WKNavigationDelegate
extension MatchDetailGuessController:WKNavigationDelegate{



}


// MARK: - WKUIDelegate
extension MatchDetailGuessController:WKUIDelegate{


}
