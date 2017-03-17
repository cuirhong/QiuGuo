//
//  InformationViewController.swift
//  QiuGuo
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

private let normalInformationCell = "informationCell"
 let shuffingFigureCell = "shuffingFigureCell"
private let horizontalArticleCell = "horizontalArticleCell"



class ArticleListViewController: BaseViewController {

    //MARK:- 请求barner数据viewModel
    fileprivate lazy var barnerViewModel:BarnerViewModel = BarnerViewModel()
    //MARK:- 请求文章列表数据viewModel
     lazy var articleViewModel:ArticleListViewModel = ArticleListViewModel()
 
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
       
   
    }
    

    
    // MARK: - 请求数据
    override func loadData() {
        super.loadData()
        if articleViewModel.articleListType == .MatchDetail{
        loadMatchArticleList()
        }else{
        loadBarnerAndArticleList()
        }
    }
    
    //MARK:- 加载首页文章列表数据
    func loadBarnerAndArticleList(){
    
        barnerViewModel.loadBarnerData(SpecialID: articleViewModel.SpecialID, successCallBack: {[weak self] (result) in
            self?.loadMatchArticleList()
        }) { (error) in
            printData(message: "请求Barner数据出错")
        }
    }
    
    
    //MARK:- 加载赛事资讯列表
    func loadMatchArticleList(){
    
        //请求咨询列表数据
        self.articleViewModel.loadArticleListData(successCallBack: {[weak self] (result) in
            DispatchQueue.main.async {
                self?.refreshUI()
                self?.endRefreshing()
            }
        }, failureCallBack: { (error) in
            printData(message: "请求专题列表数据出错")
        })
    }
    
    
    
 
    //MARK:- 下拉刷新
    override func downLoadRefresh() {
        super.downLoadRefresh()
        articleViewModel.refreshType = .PullDownRefresh
        articleViewModel.page = 1
        DispatchQueue.global().async {[weak self] in
            self?.loadData()
        }
    }
    
    //MARK:- 上拉加载 
    override func upLoadRefresh() {
        super.upLoadRefresh()
        if articleViewModel.refreshType == .PullDownRefresh || articleViewModel.isEnd == "1"{
            articleViewModel.refreshType = .UpDownRefresh
            articleViewModel.page += 1
            DispatchQueue.global().async {[weak self] in
                self?.loadData()
            }
        }else{
          collectionView.endFooterRefreshingWithNoMoreData()            
        }

        
    }
    

    
    //MARK:- 刷新界面
    override func refreshUI() {
        super.refreshUI()
        
        if collectionView.superview == nil {
            collectionView.register(ArticleNormalCell.self, forCellWithReuseIdentifier: normalInformationCell)
            collectionView.register(BarnerCell.self, forCellWithReuseIdentifier: shuffingFigureCell)
            collectionView.register(ArticleHorizontalCell.self, forCellWithReuseIdentifier: horizontalArticleCell)
            view.addSubview(collectionView)
            addRefresh()
            collectionView.snp.remakeConstraints { (make) in
                make.top.right.bottom.left.equalTo(collectionView.superview!)
            }
        }else{
         collectionView.reloadData()
        }
    }
    
    
    //MARK:- 跳转至详情页面
    func jumpToArticleDetail(articleID:Int){
    
        let controller = ArticleDetailViewController()
        controller.articleID = articleID
        navigationController?.pushViewController(controller, animated: true)

    }
    
    
    
    
    
    
}


// MARK: - 遵守UICollectionViewDataSource数据源代理
extension ArticleListViewController:UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if barnerViewModel.barnerArr.count > 0 {
             return articleViewModel.articleListArr.count + 1
        }
        return articleViewModel.articleListArr.count
        
    }
    
    //MARK:- cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var index = indexPath.item
        if  barnerViewModel.barnerArr.count > 0 {
            index = indexPath.item - 1
            if indexPath.item == 0{
                let cell:BarnerCell = collectionView.dequeueReusableCell(withReuseIdentifier:shuffingFigureCell, for: indexPath) as! BarnerCell
                cell.shuffingFigureView.delegate = self
                cell.barnerArr = barnerViewModel.barnerArr
                return cell
            }
        }

            let articleModel = articleViewModel.articleListArr[index]
            if (articleModel.Covers?.count)! > 1 {
                let cell:ArticleHorizontalCell = collectionView.dequeueReusableCell(withReuseIdentifier:horizontalArticleCell, for: indexPath) as!  ArticleHorizontalCell
                cell.delegate = self
                cell.articleListModel = articleModel
                return cell
            }else{
                let cell: ArticleNormalCell = collectionView.dequeueReusableCell(withReuseIdentifier:normalInformationCell, for: indexPath) as!  ArticleNormalCell
                cell.articleModel = articleModel
                return cell
            }
      
    }
    
    
    
    
    
    
    
}



// MARK: - 遵守UICollectionViewDelegate,ArticleHorizontalCellDelegate代理
extension ArticleListViewController:UICollectionViewDelegate,ArticleHorizontalCellDelegate,ShuffingFigureViewDelegate{
    
    //MARK:- 水平cell被点击
    internal func articleHorizontalCell(_ articleHorizontalCell: ArticleHorizontalCell?, indexPath: IndexPath?, articleModel: ArticleListModel) {
        jumpToArticleDetail(articleID: articleModel.ID)
    }


    //MARK:- 点击cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var index = indexPath.item
        
        if  barnerViewModel.barnerArr.count > 0 {
            if index == 0{
                //防止奔溃
                return
            }
            index = indexPath.item - 1           
        }
        let articleModel = articleViewModel.articleListArr[index]
        jumpToArticleDetail(articleID: articleModel.ID)
        
    }
    
    
    //MARK:- barner被点击
    func shuffingFigureView(_ shuffingFigureView: UIView?, selectedIndex index: Int) {
        if barnerViewModel.barnerArr.count > index{
           let barnerModel = barnerViewModel.barnerArr[index]
            jumpToArticleDetail(articleID: barnerModel.ArticleID)
        }
    }
    

    



}

// MARK: - 遵守UICollectionViewDelegateFlowLayout
extension ArticleListViewController:UICollectionViewDelegateFlowLayout{

    //MARK:- size
    func collectionView(_ sizeForItemAtcollectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var index = indexPath.item
        if  barnerViewModel.barnerArr.count > 0 {
            for model in barnerViewModel.barnerArr {
                 printData(message: model.Title)
            }
            index = indexPath.item - 1
            if indexPath.item == 0{
             return CGSize(width: ScreenWidth, height: 530*LayoutHeightScale)
            
            }
            
            
        }
            let articleModel = articleViewModel.articleListArr[index]
            if (articleModel.Covers?.count)! > 1 {
              
               return CGSize(width: ScreenWidth, height: 408*LayoutHeightScale)
            }
        
    
        return CGSize(width: ScreenWidth, height: 266*LayoutHeightScale)
    }

    


}

















