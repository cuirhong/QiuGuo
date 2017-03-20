//
//  MatchViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/27.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class MatchViewController: BaseViewController {
    //MARK:- 赛事联赛栏目viewModel
    fileprivate var matchLeagueViewModel:MatchLeagueViewModel = MatchLeagueViewModel()
    //MARK:- 创建pageMenu
    fileprivate var pageMenuView:PageMenuView?
    //MARK:- pageContentView
    fileprivate var pageContentView:PageContentView?
    
    //MARK:- 加载view
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
    }
    
 
    
    //MARK:- 加载数据
    override func loadData() {
        super.loadData()
        matchLeagueViewModel.dataAbnormalType = .noAbnormal 
        matchLeagueViewModel.loadMatchLeague(successCallBack: {[weak self] (result) in
            let isNormal = self?.checkDataIsNormal(dataAbnormalType: (self?.matchLeagueViewModel.dataAbnormalType)!)
            if isNormal == true {
               self?.setupUI()
            }
        }) {[weak self] (error) in
           self?.loadDataFailure(error: error, abnormalType: self?.matchLeagueViewModel.dataAbnormalType)
        }
    }
    
    
    //MARK:- 设置界面
    func setupUI(){
        if matchLeagueViewModel.matchLeagueArr.count == 0{
        return
        }
        
        
        var titles = [String]()
         var childVcArr = [MatchListViewController]()
        for model in matchLeagueViewModel.matchLeagueArr {
            titles.append(model.ShortChsName)
            let controller = MatchListViewController()
            controller.leagueID = model.LeagueID
            childVcArr.append(controller)
        }
        
        //设置menuView
        let pageMenuHeight = 120*LayoutHeightScale
        pageMenuView = PageMenuView.init(titles: titles)
        pageMenuView?.delegate = self
        view.addSubview(pageMenuView!)
        pageMenuView?.snp.remakeConstraints({ (make) in
            make.top.left.right.equalTo((pageMenuView?.superview!)!)
            make.height.equalTo(pageMenuHeight)
            
        })
        
        //设置pageContentView
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + pageMenuHeight, width: ScreenWidth, height: ScreenHeight - kStatusBarH - kNavigationBarH-pageMenuHeight-kTabBarH)
        pageContentView = PageContentView.init(frame: contentFrame, childVcs: childVcArr, parentVc: self)
        view.addSubview(pageContentView!)
        pageContentView?.delegate = self
        pageContentView?.snp.makeConstraints({ (make) in
            make.top.equalTo((pageMenuView?.snp.bottom)!)
            make.bottom.left.right.equalTo((pageContentView?.superview!)!)
        })   
    }
       
}

// MARK: - 遵守代理PageContentViewDelegate,PageMenuViewDelegate
extension MatchViewController:PageContentViewDelegate,PageMenuViewDelegate{
    
    func pageMenuView(_ titleView: PageMenuView, sourceIndex: Int, targetIndex: Int) {
         pageContentView?.settingCurrenIndex(targetIndex: targetIndex)
    }

    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageMenuView?.setupMenuButton(index: targetIndex)
    }




}








