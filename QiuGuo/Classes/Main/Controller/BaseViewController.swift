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
    
    //MARK:- 提示view
    fileprivate var hintView:HintView?
    

    
    //MARK:- 加载view
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
       
    }
    
    //MARK:- view将要显示
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
    //MARK:- view将要消失
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

    
    //MARK:- 设置返回按钮
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
     
        return collectionView
        
        }()
    //MARK:- 添加上拉刷新下拉加载
    func addRefresh(downLoadRefresh:Bool=true,upLoadRefresh:Bool=true){
        if downLoadRefresh{
            //添加下拉刷新
            let headerView = RefreshHeaderView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 70))
            _ = collectionView.setUpHeaderRefresh(headerView, action: {[weak self] in
                self?.downLoadRefresh()
            })
        }
        if upLoadRefresh {
            //添加上啦加载
            let footer = RefreshFooterView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 70))            
            _ = collectionView.setUpFooterRefresh(footer, action: {[weak self] in
                self?.upLoadRefresh()
            })
        }
    }
    
    //MARK:- 下拉刷新
    func downLoadRefresh() {
        
       collectionView.endFooterRefreshing()
        hintView?.removeFromSuperview()
    }
    
    //MARK:- 上啦加载
    func upLoadRefresh() {
        collectionView.endHeaderRefreshing()
         hintView?.removeFromSuperview()
        
    }
    
    //MARK:- 结束刷新
    func endRefreshing(){
      collectionView.endFooterRefreshing()
      collectionView.endHeaderRefreshing()
    }
    
    //MARK:- 设置数据异常界面
    func checkDataIsNormal(hintTextArr:[String]=["没有更多数据了!"],dataAbnormalType:DataAbnormalType = .noData)->Bool{
        var imageString = ""
        switch dataAbnormalType {
        case .noData:
            imageString = "no_data.png"
             hintView = HintView.init(imageString, textArr: hintTextArr)
        case .noNetwork:
            imageString = "no-network.png"
            let textArr:[String] = ["网络不可用,点击屏幕重试"]
             hintView = HintView.init(imageString, textArr: textArr)
            hintView?.addGestureRecognizer(UITapGestureRecognizer.init(target:self, action:#selector(noNetworkTapLoadData)))
        default:
             return true
        }
        
        self.view.addSubview(hintView!)
        hintView?.snp.makeConstraints { (make) in
           make.top.right.bottom.left.equalTo((hintView?.superview!)!)
            
        }
        
        return false
    }
    
    //MARK:- 无网络点击加载数据
    func noNetworkTapLoadData(){
        hintView?.removeFromSuperview()
        DispatchQueue.global().async {[weak self] in
          self?.loadData()
        }
    }

    
    //MARK:- 加载数据失败
    func loadDataFailure(error:Any?=nil,abnormalType:DataAbnormalType?){
        if abnormalType == .noNetwork{
            _ = checkDataIsNormal(dataAbnormalType: abnormalType ?? .noNetwork)
        }else{
            HUDTool.show(showType: .Failure, text: error.debugDescription,viewController:self)
            
        }
    
    }
    
    
    
    //MARK:- 返回事件
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:-  开始触摸屏幕
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        HUDTool.dismiss()
    }
    
}


















