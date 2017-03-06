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
        
        setupNavi()
        //加载数据
        DispatchQueue.global().async {
            self.loadData()
            
        }
        view.backgroundColor = UIColor.white
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

    
    
    func setupNaviBack(imageName:String="arrow_r.png",highlightedImage:String="",target:UIViewController) {
        
        let item = UIBarButtonItem.init(imageName: imageName, highlightedImage: highlightedImage, target: target, action: #selector(back))
        self.navigationItem.leftBarButtonItem = item
    }
    
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
}
