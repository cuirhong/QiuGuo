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
        let detailHeadView = MatchDetailHeadView()
        detailHeadView.matchModel = matchModel
        detailHeadView.delegate = self
       view.addSubview(detailHeadView)
        detailHeadView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(detailHeadView.superview!)
            make.height.equalTo(272*LayoutHeightScale)
        }
        
        
        
        let articleController = ArticleListViewController()
        articleController.articleViewModel.leagueID = matchModel.LeagueID
        articleController.articleViewModel.matchID = matchModel.MatchID
        articleController.articleViewModel.articleListType = .MatchDetail
        addChildViewController(articleController)
        view.addSubview(articleController.view)
        articleController.view.snp.makeConstraints { (make) in
            make.top.equalTo(detailHeadView.snp.bottom)
            make.left.bottom.right.equalTo(articleController.view.superview!)
        }
    }
}

// MARK: - 遵守MatchDetailHeadViewDelegate
extension MatchDetailViewController:MatchDetailHeadViewDelegate{
    //MARK:- 代理调用返回
    func matchDetailHeadView(_ headView: MatchDetailHeadView) {
        back()
    }



}
