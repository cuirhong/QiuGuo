//
//  InformationViewController.swift
//  QiuGuo
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class InformationViewController: BaseViewController {
     var SpecialID:Int = 0
    
    fileprivate lazy var barnerViewModel:BarnerViewModel = BarnerViewModel()
    
    fileprivate lazy var articleViewModel:ArticleListViewModel = ArticleListViewModel()
    
    fileprivate lazy var shuffingFigureView:ShufflingFigureView = {[weak self] in
        var imageUrls:[String] = []
        var titles:[String] = []
            for model in (self?.barnerViewModel.barnerArr)! {
                imageUrls.append(model.Cover!)
                titles.append(model.Title!)
            }

        let view = ShufflingFigureView.init(imageUrls: imageUrls, imageName: nil,titles:titles)
       return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
      
    }
    
    // MARK: - 请求数据
    override func loadData() {
        super.loadData()
        barnerViewModel.loadBarnerData(SpecialID: SpecialID, successCallBack: {[weak self] (result) in
            self?.articleViewModel.loadArticleListData(SpecialID: (self?.SpecialID)!, successCallBack: { (result) in
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
        if barnerViewModel.barnerArr.count > 0{
            view.addSubview(shuffingFigureView)
            shuffingFigureView.snp.remakeConstraints({ (make) in
                make.top.left.right.equalTo(shuffingFigureView.superview!)
                make.height.equalTo(530*LayoutHeightScale)
            })
        
        }
 
    }
    
    
    
    
    
    
}
