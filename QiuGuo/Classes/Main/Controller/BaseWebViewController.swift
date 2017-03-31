//
//  BaseWebViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/30.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import WebKit
class BaseWebViewController: BaseViewController {
    
    
    //MARK:- 观察webView加载的进度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    
    //MARK:- 加载网页的进度
     lazy var progressView:UIProgressView = {
        let progressView = UIProgressView(frame: CGRect(x: 0, y: 44-2, width: ScreenWidth, height: 2))
        progressView.trackTintColor = UIColor.white
        progressView.progressTintColor = THEMECOLOR
        return progressView
        
    }()
    
    //MARK:- webView
     lazy var webView:WKWebView = {[weak self] in
        
        
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        let userContentController = WKUserContentController()
        userContentController.add(self as! WKScriptMessageHandler , name: WebViewFromJsName.init().JumpToCommentMethod)
        
        let webView = WKWebView(frame: CGRect.zero, configuration: config)
        if let controller = self{
            webView.navigationDelegate = controller
            webView.uiDelegate = controller
            webView.addObserver(controller, forKeyPath: "estimatedProgress", options: .new, context: nil)
            controller.navigationController?.navigationBar.addSubview(controller.progressView)
            
        }
        return webView
        
        
        }()
    
    
  
    
}


// MARK: - 遵守WKNavigationDelegate,WKUIDelegate
extension BaseWebViewController:WKNavigationDelegate,WKUIDelegate{
    
    
    
    //已经加载完毕
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: true)
        HUDTool.dismiss()
    }
    
    //MARK:- 加载失败调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.setProgress(0.0, animated: true)
        HUDTool.dismiss()
        HUDTool.show(showType: .Failure, text: error.localizedDescription)
    }
    
    //MARK:- 发送请求之前决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(WKNavigationActionPolicy.allow)
        
    }
}






