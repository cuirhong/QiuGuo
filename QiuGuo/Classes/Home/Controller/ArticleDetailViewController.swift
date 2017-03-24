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
    var articleID:Int = 0{
        didSet{
            articleDetailViewModel.ID = articleID
        
        }
    }
    //MARK:- 跳转文章id
    var jumpArticleID:Int = 0{
        didSet{
            if self.articleID != jumpArticleID{
                self.articleID = jumpArticleID
                DispatchQueue.global().async {[weak self] in
                    self?.loadData()
                }
            }
        }
    }

    //MARK:- 文章详情viewModel
    private var articleDetailViewModel:ArticleDetailViewModel = ArticleDetailViewModel()
    
    //MARK:- 加载网页的进度
    fileprivate lazy var progressView:UIProgressView = {
    let progressView = UIProgressView(frame: CGRect(x: 0, y: 44-2, width: ScreenWidth, height: 2))
        progressView.trackTintColor = UIColor.white
        progressView.progressTintColor = THEMECOLOR
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
    
    //MARK:- 评论工具
    private lazy var commentToolView:CommentToolViews = CommentToolViews(toolViewsType: .ArticleDetail)

    //MARK:- 加载view
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
    
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
        
        
        if commentToolView.superview == nil{
            view.addSubview(commentToolView)
            commentToolView.delegate = self
            commentToolView.snp.makeConstraints { (make) in
                make.right.bottom.left.equalTo(commentToolView.superview!)
                make.height.equalTo(140*LayoutHeightScale)
            }
        }
        
          commentToolView.articleDetailModel = articleDetailViewModel.articleDetailModel
        
   
        if webView.superview == nil{
            view.addSubview(webView)
            webView.snp.makeConstraints { (make) in
                make.left.right.top.equalTo(webView.superview!)
                make.bottom.equalTo(commentToolView.snp.top)
            }
            
            if let url = URL(string: articleDetailViewModel.articleDetailModel?.url ?? ""){
                let request = URLRequest(url: url)
                webView.load(request)
            }else{
                HUDTool.show(showType: .Failure, text: "抱歉,加载出错!")
            }
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

    //MARK:- 已经开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        HUDTool.show(showType: .Load)
    }
    
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
        //获取到跳转之后文章的id,评论需要
        
        if let urlString = navigationAction.request.url?.absoluteString{
            if urlString.contains("isIos"){//如果是点击更多文章跳转
                var newStringArr:[String]? = urlString.components(separatedBy: ".html")
                newStringArr = newStringArr?.first?.components(separatedBy: "/")
                printData(message: navigationAction.request.url?.absoluteString)
                if let articleID = newStringArr?.last{
                    self.jumpArticleID = Int(articleID)!
                    printData(message: self.jumpArticleID)
                    decisionHandler(WKNavigationActionPolicy.allow)
                }else{
                    decisionHandler(WKNavigationActionPolicy.cancel)
                }
            }else{
               decisionHandler(WKNavigationActionPolicy.allow)
            
            }
        }else{
           decisionHandler(WKNavigationActionPolicy.allow)
            
        
        }
    }
}


// MARK: - 遵守CommentToolViewsDelegate
extension ArticleDetailViewController:CommentToolViewsDelegate{
    //MARK:- 评论代理
    func commentToolView(_ commentToolView: CommentToolViews, commentType: CommentType) {
        switch commentType {
        case .ReleaseComment:
            if UserInfo.userLogin(){
                let frame =  CGRect(x: 0, y: ScreenHeight - 483*LayoutHeightScale, width: ScreenWidth, height: 483*LayoutHeightScale)
                let editCommentView:EditCommentView = EditCommentView(frame: CGRect(x: 0, y: ScreenHeight - 483*LayoutHeightScale, width: ScreenWidth, height: 483*LayoutHeightScale))
                editCommentView.delegate = self
                let alertStyle = AlertViewStyle(alertType: .Bottom, alertViewFrame: frame, isTapDissmiss: true, bottomBackColor: nil)
                let alertView = AlertBottomView(alertView: editCommentView, alertViewStyle: alertStyle)
                alertView.show()
            }
        case .JumpToComment:
           
            let commentController = CommentViewController()
            commentController.ID = self.articleID
            self.navigationController?.pushViewController(commentController, animated: true)
        }
    }


}

// MARK: - 遵守EditCommentViewDelegate
extension ArticleDetailViewController:EditCommentViewDelegate{
    //MARK:-  发送评论
    func editCommentView(_ editCommentView: EditCommentView, sendCommentText: String) {
        editCommentView.superview?.removeFromSuperview()
        let sendCommentViewModel = SendCommentViewModel()
        sendCommentViewModel.ID = self.articleID
        sendCommentViewModel.DataType = 1
        sendCommentViewModel.content = sendCommentText

            sendCommentViewModel.sendComment(successCallBack: { (result) in
                let code = result["code"].intValue

                self.commentResult(isSuecces: code == 1)

            }) { (error) in
                //评论失败
                 self.commentResult(isSuecces: false)
            }
    
    }
    
    
    //MARK:- 评论结果
    func commentResult(isSuecces:Bool){
        
        DispatchQueue.main.async {
            var imageName = "popup_comment_f"
            if isSuecces {
                imageName = "popup_comment_s"
                DispatchQueue.global().async {
                     self.loadData()
                }
            }
            
            let alertStyle = AlertViewStyle(alertType: .Center, alertViewFrame: nil, isTapDissmiss: true, bottomBackColor: UIColor.clear)
            let hintCommentSuccess = AlertBottomView(alertView: UIImageView(image:UIImage.getImage(imageName)), alertViewStyle: alertStyle)
            hintCommentSuccess.show()
        }
    }

}





