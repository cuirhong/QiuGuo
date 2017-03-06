//
//  BaseViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/27.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载数据
        DispatchQueue.global().async {
            self.loadData()
            
        }
        view.backgroundColor = UIColor.white
    }
    
    func loadData(){
    
    
    }
    
    func initData(){
       printData(message: "加载数据...")
        
        
    }
    
    func refreshUI(){
    
    }

    
    
    func setupNaviBack(imageName:String="arrow_r.png",highlightedImage:String="",target:UIViewController) {
        
        let item = UIBarButtonItem.init(imageName: imageName, highlightedImage: highlightedImage, target: target, action: #selector(back))
        self.navigationItem.leftBarButtonItem = item
    }
    
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
}
