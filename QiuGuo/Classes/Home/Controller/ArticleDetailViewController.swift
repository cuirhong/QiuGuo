//
//  ArticleDetailViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/9.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import WebKit

/// 文章详情
class ArticleDetailViewController: BaseViewController {
    
    //MARK:- 文章ID
    var articleID:Int = 0
    
    //MARK:- 文章详情viewModel
    private var articleDetailViewModel:ArticleDetailViewModel = ArticleDetailViewModel()
    
    //MARK:- 加载网页的进度
    fileprivate lazy var progressView:UIProgressView = {
    let progressView = UIProgressView(frame: CGRect(x: 0, y: 44-2, width: ScreenWidth, height: 2))
        progressView.trackTintColor = THEMECOLOR
        progressView.progressTintColor = UIColor.orange
        return progressView
    
    }()
    
    //MARK:- webView
    private lazy var webView:WKWebView = {[weak self] in
       let webView = WKWebView()
        if let controller = self{
              webView.navigationDelegate = controller
            webView.uiDelegate = controller
              webView.addObserver(controller, forKeyPath: "estimatedProgress", options: .new, context: nil)
              controller.navigationController?.navigationBar.addSubview(controller.progressView)
        }
        return webView

    }()
    
    
    //MARK:- 加载view
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupNavi()
    
    }
    
    //MARK:- 初始化数据
    override func initData() {
        super.initData()
        articleDetailViewModel.ID = articleID
    }
    
    //MARK:- 设置导航栏
    override func setupNavi() {
        super.setupNavi()
        setupNaviBack(target: self)
    }
    
    
    //MARK:- 加载数据
    override func loadData() {
        super.loadData()
        articleDetailViewModel.dataAbnormalType = .noAbnormal   
        articleDetailViewModel.loadArticleDetail(successCallBack: {[weak self] (result) in
            let isNormal = self?.checkDataIsNormal(dataAbnormalType: (self?.articleDetailViewModel.dataAbnormalType)!)
            if isNormal == true {
                DispatchQueue.main.async {
                  self?.setupView()
                }
            }
  
            
        }) {[weak self] (error) in
           self?.loadDataFailure(error: error, abnormalType: self?.articleDetailViewModel.dataAbnormalType)
        }
    }
    
    //MARK:- 设置界面
    override func setupView() {
        super.setupView()
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(webView.superview!)
        }
        
        if let url = URL(string: articleDetailViewModel.articleDetailModel.url){
          let request = URLRequest(url: url)
            webView.load(request)
        }else{        
            HUDTool.show(showType: .Failure, text: "抱歉,加载出错!")
        }
        
        
   
    }
    

    
    //MARK:- 观察webView加载的进度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    
    //MARK:- 页面销毁
    deinit {        
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.reloadInputViews()
    }
    
    
    //MARK:- 重写返回按钮事件
    override func back() {
        if webView.canGoBack{
         webView.goBack()
        }else{
            super.back()
            progressView.removeFromSuperview()
        }
       
    }
    
    
}


// MARK: - 遵守WKNavigationDelegate,WKUIDelegate
extension ArticleDetailViewController:WKNavigationDelegate,WKUIDelegate{
    //已经加载完毕
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: true)
    }


}










