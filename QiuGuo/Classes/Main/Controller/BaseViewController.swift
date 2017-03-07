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
    
    func setupNavi(){
        let logoImage = UIImageView(image: UIImage.getImage("logo.png"))
        self.navigationItem.titleView = logoImage
    
    }
    
    func loadData(){
       
    
    
    }
    
    func initData(){
       printData(message: "加载数据...")
        
        
    }
    
    func refreshUI(){
        HUDTool.dismiss()
    
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
        
        collectionView.bounces = false
        collectionView.dataSource = self as! UICollectionViewDataSource?
        collectionView.delegate = self as! UICollectionViewDelegate?
        collectionView.backgroundColor = UIColor.white
               
        return collectionView
        
        }()
    
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
}
