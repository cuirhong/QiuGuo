//
//  MatchDetailViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/9.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

/// 球赛详情
class MatchDetailViewController: BaseViewController {
    
    //MARK:- 比赛模型
    var matchModel:MatchListModel = MatchListModel()
    
    //MARK:- 赛程
    fileprivate lazy var detailHeadView:MatchDetailHeadView = MatchDetailHeadView()
    
    //MARK:- pageMenu
    fileprivate lazy  var pageMenuView:MenuToolView = MenuToolView.init(titles: ["资讯","对战","聊个球"])
    
    //MARK:- pageContent
    fileprivate var pageContentView:PageContentView?

    //MARK:- 加载
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK:- view将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK:- view将要消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    

    //MARK:- 设置界面
    override func setupView() {
        super.setupView()
        //比赛赛程
        detailHeadView.matchModel = matchModel
        let headViewHeight = 272*LayoutHeightScale
        detailHeadView.delegate = self
       view.addSubview(detailHeadView)
        detailHeadView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(detailHeadView.superview!)
            make.height.equalTo(headViewHeight)
        }
        
        
//        //设置menuView
//        let pageMenuHeight = 120*LayoutHeightScale
//        pageMenuView.delegate = self
//        view.addSubview(pageMenuView)
//        pageMenuView.snp.remakeConstraints({ (make) in
//            make.top.equalTo(detailHeadView.snp.bottom)
//            make.left.equalTo(pageMenuView.superview!).offset(100*LayoutWidthScale)
//            make.right.equalTo(pageMenuView.superview!).offset(-100*LayoutWidthScale)
//            make.height.equalTo(pageMenuHeight)
//            
//        })
//        
//        //设置pageContentView
//        var childVcArr:[UIViewController] = []
        
        //资讯
        let articleController = ArticleListViewController()
        articleController.articleViewModel.leagueID = matchModel.LeagueID
        articleController.articleViewModel.matchID = matchModel.MatchID
        articleController.articleViewModel.articleListType = .MatchDetail
        self.addChildViewController(articleController)
        view.addSubview(articleController.view)
        articleController.view.snp.makeConstraints { (make) in
            make.top.equalTo(detailHeadView.snp.bottom)
            make.bottom.left.right.equalTo(articleController.view.superview!)
        }
//        childVcArr.append(articleController)
//        
//        //对战
//        let guessController = MatchDetailGuessController()
//        guessController.matchGuessViewModel.matchId = matchModel.MatchID
//        childVcArr.append(guessController)
//        
//        //聊个球 
//        let chatBallController = ChatBallViewController()
//        chatBallController.matchModel = matchModel
//        childVcArr.append(chatBallController)
//
//        //导航栏已经隐藏了
//        let contentFrame = CGRect(x: 0, y:  headViewHeight + pageMenuHeight, width: ScreenWidth, height: ScreenHeight  - headViewHeight-pageMenuHeight)
//        pageContentView = PageContentView.init(frame: contentFrame, childVcs: childVcArr, parentVc: self)
//        view.addSubview(pageContentView!)
//        pageContentView?.delegate = self
//        pageContentView?.snp.makeConstraints({ (make) in
//            make.top.equalTo((pageMenuView.snp.bottom))
//            make.bottom.left.right.equalTo((pageContentView?.superview!)!)
//        })   
    }
}

// MARK: - 遵守MatchDetailHeadViewDelegate
extension MatchDetailViewController:MatchDetailHeadViewDelegate{
    //MARK:- 代理调用返回
    func matchDetailHeadView(_ headView: MatchDetailHeadView) {
        back()
    }
}


// MARK: - 遵守PageMenuViewDelegate
extension MatchDetailViewController:PageMenuViewDelegate{
    func pageMenuView(_ titleView: PageMenuView, sourceIndex: Int, targetIndex: Int) {
        pageContentView?.settingCurrenIndex(courceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

// MARK: - 遵守PageContentViewDelegate
extension MatchDetailViewController:PageContentViewDelegate{
    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageMenuView.setupMenuButton(index: targetIndex)
    }
}







