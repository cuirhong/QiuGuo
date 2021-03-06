//
//  HomeViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/27.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    private var spercialViewModel:SpecialViewModel = SpecialViewModel()

    //MARK:- contentView
    fileprivate  var pageContentView:PageContentView?
    
    //MARK:- menu标题栏
    fileprivate var pageMenuView:PageMenuView?
    
    private var spercialNameArr:[String]{
        get{
            var titles:[String] = []
            for model in spercialViewModel.spericalModels {
                titles.append(model.Name)
                printData(message: model.Name)
            }
            return titles
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavi()
   
    }
    

    //MARK:- 加载数据


    override func loadData(){
        super.loadData()
        spercialViewModel.dataAbnormalType = .noAbnormal    
        spercialViewModel.loadSpecialData(success: {[weak self](result) in
             let isNormal = self?.checkDataIsNormal(dataAbnormalType: (self?.spercialViewModel.dataAbnormalType)!)
            if isNormal == true {
              self?.refreshUI()
            }
            
        }) {[weak self] (error) in
           
            self?.loadDataFailure(error: error, abnormalType: self?.spercialViewModel.dataAbnormalType)
        }
    }
    // MARK: -刷新界面
    override func refreshUI() {
        super.refreshUI()
 
        DispatchQueue.main.async {[weak self] in
            self?.setupUI()
        }
    }

    // MARK: -  设置界面
    func setupUI(){
        
       pageMenuView = PageMenuView.init(titles:spercialNameArr)
        pageMenuView?.delegate = self
        pageMenuView?.backgroundColor = UIColor.clear
        view.addSubview(pageMenuView!)
        let pageMenuHeight = 120*LayoutHeightScale
        pageMenuView?.snp.remakeConstraints { (make) in
            make.left.right.top.equalTo((pageMenuView?.superview!)!)
            make.height.equalTo(pageMenuHeight)
        }
        
        
        
        if (spercialViewModel.spericalModels.count) > 0 {
            var childVcs:[ArticleListViewController] = []
            for model in spercialViewModel.spericalModels {
                let controller = ArticleListViewController()
                controller.articleViewModel.SpecialID = model.SpecialID
                childVcs.append(controller)
            }
            
            let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + pageMenuHeight, width: ScreenWidth, height: ScreenHeight - kStatusBarH - kNavigationBarH-pageMenuHeight-kTabBarH)
            
              pageContentView = PageContentView.init(frame: contentFrame, childVcs: childVcs, parentVc: self)
        }
  
        
        view.addSubview(pageContentView!)
        pageContentView?.delegate = self

        pageContentView?.snp.remakeConstraints({ (make) in
            make.top.equalTo((pageMenuView?.snp.bottom)!)
            make.left.right.bottom.equalTo((pageContentView?.superview)!)
        })
    }

}

// MARK: - 协议方法
extension HomeViewController:PageMenuViewDelegate,PageContentViewDelegate{

    //MARK:- 标题点击代理方法
    func pageMenuView(_ titleView: PageMenuView, sourceIndex: Int, targetIndex: Int) {
       pageContentView?.settingCurrenIndex(targetIndex: targetIndex)
    }
    

    //MARK:- contentView滑动代理方法
    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageMenuView?.setupMenuButton(index: targetIndex)
         
    }
    
    

}











