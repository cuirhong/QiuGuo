//
//  InformationViewController.swift
//  QiuGuo
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

 let normalInformationCell = "informationCell"
 let shuffingFigureCell = "shuffingFigureCell"
let horizontalArticleCell = "horizontalArticleCell"


class ArticleListViewController: BaseViewController {
     var SpecialID:Int? = 0
    //MARK:- 请求barner数据viewModel
    fileprivate lazy var barnerViewModel:BarnerViewModel = BarnerViewModel()
    //MARK:- 请求文章列表数据viewModel
    fileprivate lazy var articleViewModel:ArticleListViewModel = ArticleListViewModel()
 
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupView()
       
   
    }
    
    override func initData() {
        super.initData()
        if let id = SpecialID{
         articleViewModel.SpecialID = id
        }
        
    }
    
    // MARK: - 请求数据
    override func loadData() {
        super.loadData()
        
        barnerViewModel.loadBarnerData(SpecialID: SpecialID!, successCallBack: {[weak self] (result) in
           
            
            //请求咨询列表数据
            self?.articleViewModel.loadArticleListData(successCallBack: { (result) in
                DispatchQueue.main.async {
                    self?.refreshUI()
                    self?.endRefreshing()
                }
                
            }, failureCallBack: { (error) in
                 printData(message: "请求专题列表数据出错")
            })
        

        }) { (error) in
            printData(message: "请求Barner数据出错")
        }
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
            
            collectionView.snp.remakeConstraints { (make) in
                make.top.right.bottom.left.equalTo(collectionView.superview!)
            }
        }else{
        
         collectionView.reloadData()
        
        
        }
        
        
        
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
                cell.barnerArr = barnerViewModel.barnerArr
                
                return cell
            
            }
            
        }
        

        
            let articleModel = articleViewModel.articleListArr[index]
            if (articleModel.Covers?.count)! > 1 {
                let cell:ArticleHorizontalCell = collectionView.dequeueReusableCell(withReuseIdentifier:horizontalArticleCell, for: indexPath) as!  ArticleHorizontalCell
                cell.articleListModel = articleModel
                return cell
            }else{
                let cell: ArticleNormalCell = collectionView.dequeueReusableCell(withReuseIdentifier:normalInformationCell, for: indexPath) as!  ArticleNormalCell
                cell.articleModel = articleModel
                return cell
            }
      
    }
}



// MARK: - 遵守UICollectionViewDelegate代理
extension ArticleListViewController:UICollectionViewDelegate{





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

















