//
//  HomeViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/27.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    private var spercialArr:[SpecialModel]?
    
    private var spercialNameArr:[String]{
        get{
            var titles:[String] = []
            for model in spercialArr! {
                titles.append(model.Name!)
                printData(message: model.Name!)
            }
            return titles
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    override func loadData(){
        super.loadData()
        SpecialViewModel.loadSpecialData(success: {[weak self] (result) in
            let code = result["code"]
            if code == 1{
                let dataArr = result["data"]
                if let arr = dataArr.arrayObject{
                    self?.spercialArr = []
                    for dict in arr  {
                        let model = SpecialModel.init(dict: (dict as? Dictionary)!)
                        self?.spercialArr?.append(model)
                    }
                    self?.refreshUI()
                }
            }else{
                printData(message: result["msg"].stringValue)
            }

        }) { (error) in
            printData(message: "获取数据失败")
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
        
        let pageMenu = PageMenuView.init(titles:spercialNameArr)
        pageMenu.delegate = self
        view.addSubview(pageMenu)
        pageMenu.snp.remakeConstraints { (make) in
            make.left.right.top.equalTo(pageMenu.superview!)
            make.height.equalTo(120*LayoutHeightScale)
        }
        
    
        let controller = InformationViewController()
        controller.SpecialID = 16
        view.addSubview(controller.view)
        self.addChildViewController(controller)
        controller.view.snp.remakeConstraints { (make) in
            make.top.equalTo(pageMenu.snp.bottom)
            make.left.right.bottom.equalTo(controller.view.superview!)
            
        }
        
    
    }

}

// MARK: - 协议方法
extension HomeViewController:PageMenuViewDelegate{

    func pageMenuView(_ titleView: PageMenuView, selectedIndex index: Int) {
         printData(message: String(stringInterpolationSegment: index))
    }


}






