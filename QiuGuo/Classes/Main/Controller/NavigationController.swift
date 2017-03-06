//
//  NavigationController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/27.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupUI()
        
    }
    
    func setupNavi(){
    
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage.init(), for: .any, barMetrics: .default)
        navigationBar.shadowImage = UIImage.init()
        
        navigationBar.barTintColor = THEMECOLOR
        

        
        navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.font(psFontSize: 46),NSForegroundColorAttributeName:UIColor.init(hexString: "#ffffff")!]
    
    }
    
    
    func setupUI(){
        
    
    }
    
    
    
    
    
    
}
