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
let horizontalInformationCell = "horizontalInformationCell"


class InformationViewController: BaseViewController {
     var SpecialID:Int? = 0
    //MARK:- 请求barner数据viewModel
    fileprivate lazy var barnerViewModel:BarnerViewModel = BarnerViewModel()
    //MARK:- 请求文章列表数据viewModel
    fileprivate lazy var articleViewModel:ArticleListViewModel = ArticleListViewModel()
 
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
   
    }
    
    // MARK: - 请求数据
    override func loadData() {
        super.loadData()
        
        barnerViewModel.loadBarnerData(SpecialID: SpecialID!, successCallBack: {[weak self] (result) in
           
            
            //请求咨询列表数据
            self?.articleViewModel.loadArticleListData(SpecialID: (self?.SpecialID)!, page: 1, successCallBack: { (result) in
                DispatchQueue.main.async {
                    self?.refreshUI()
                }
                
            }, failureCallBack: { (error) in
                 printData(message: "请求专题列表数据出错")
            })
        

        }) { (error) in
            printData(message: "请求Barner数据出错")
        }
    }
    
    
    override func refreshUI() {
        super.refreshUI()
        
        collectionView.register(InformationCell.self, forCellWithReuseIdentifier: normalInformationCell)
        collectionView.register(BarnerCell.self, forCellWithReuseIdentifier: shuffingFigureCell)        
        view.addSubview(collectionView)
        collectionView.snp.remakeConstraints { (make) in
            make.top.right.bottom.left.equalTo(collectionView.superview!)
        }
        
    }
}


// MARK: - 遵守UICollectionViewDataSource数据源代理
extension InformationViewController:UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if barnerViewModel.barnerArr.count > 0 {
             return articleViewModel.articleListArr.count + 1
        }
        return articleViewModel.articleListArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.item == 0 && barnerViewModel.barnerArr.count > 0 {
            let cell:BarnerCell = collectionView.dequeueReusableCell(withReuseIdentifier:shuffingFigureCell, for: indexPath) as! BarnerCell
            cell.barnerArr = barnerViewModel.barnerArr
         
            return cell 
        }else{
            var index = indexPath.item
            if barnerViewModel.barnerArr.count > 0 {
               index = indexPath.item - 1
            }
            let cell:InformationCell = collectionView.dequeueReusableCell(withReuseIdentifier:normalInformationCell, for: indexPath) as! InformationCell
            cell.articleModel = articleViewModel.articleListArr[index]            
            return cell
        }
    }
}

// MARK: - 遵守UICollectionViewDelegate代理
extension InformationViewController:UICollectionViewDelegate{





}

// MARK: - 遵守UICollectionViewDelegateFlowLayout
extension InformationViewController:UICollectionViewDelegateFlowLayout{

    func collectionView(_ sizeForItemAtcollectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 && barnerViewModel.barnerArr.count > 0 {
            return CGSize(width: ScreenWidth, height: 530*LayoutHeightScale)
        }
        return CGSize(width: ScreenWidth, height: 266*LayoutHeightScale)
    }

    


}

















