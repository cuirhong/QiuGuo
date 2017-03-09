//
//  BaseViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/27.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    //MARK:- 是否是第一次加载界面
    lazy var isFirstLoadView:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstLoadView == true{
            //加载数据
            isFirstLoadView = false
            DispatchQueue.global().async {
                self.loadData()
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HUDTool.dismiss()
    }
    
    //MARK:- 设置导航栏
    func setupNavi(){
        let logoImage = UIImageView(image: UIImage.getImage("logo.png"))
        self.navigationItem.titleView = logoImage
    
    }
    
    //MARK:- 设置界面
    func setupView(){
    
    
    }
    
    //MARK:- 加载数据
    func loadData(){
       
    
    
    }
    
    func initData(){
       printData(message: "加载数据...")
        
        
    }
    
    //MARK:- 刷新界面
    func refreshUI(){
       
    
    }

    
    
    func setupNaviBack(imageName:String="arrow_back",highlightedImage:String="",target:UIViewController) {
        
        let item = UIBarButtonItem.init(imageName: imageName, highlightedImage: highlightedImage, target: target, action: #selector(back))
        self.navigationItem.leftBarButtonItem = item
    }
    
    //MARK:-  创建collectionView
     lazy var collectionView:UICollectionView = {[weak self] in
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
       
        collectionView.dataSource = self as! UICollectionViewDataSource?
        collectionView.delegate = self as! UICollectionViewDelegate?
        collectionView.backgroundColor = UIColor.white
        
        //添加下拉刷新
        let headerView = RefreshHeaderView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 70))
       _ = collectionView.setUpHeaderRefresh(headerView, action: {[weak self] in
          self?.downLoadRefresh()
        })
        
        //添加上啦加载
        let footer = RefreshFooterView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 70))
        _ = collectionView.setUpFooterRefresh(footer, action: { 
             self?.upLoadRefresh()
        })
  
            
               
        return collectionView
        
        }()
    
    //MARK:- 下拉刷新
    func downLoadRefresh() {
       collectionView.endFooterRefreshing()
    }
    
    //MARK:- 上啦加载
    func upLoadRefresh() {
        collectionView.endHeaderRefreshing()
        
    }
    
    //MARK:- 结束刷新
    func endRefreshing(){
      collectionView.endFooterRefreshing()
      collectionView.endHeaderRefreshing()
    }
    
    
    //MARK:- 返回事件
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
}
