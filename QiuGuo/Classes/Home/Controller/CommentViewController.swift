//
//  CommentViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/24.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class CommentViewController: BaseViewController {
    
    //MARK:- 文章id
    var ID:Int = 0
    
    //MARK:- menu工具条
    fileprivate lazy var menuToolView:MenuToolView = MenuToolView.init(titles: ["热门评论","","最新评论"])
    
    //MARK:- 评论工具条
    fileprivate lazy var commentToolView:CommentToolViews = CommentToolViews(toolViewsType: .ArticleComment)
    
    //MARK:- contentView
    fileprivate var pageContentView:PageContentView?
    
    
    //MARK:- 加载view
    override func viewDidLoad() {
        super.viewDidLoad()
         setupNaviBack(target: self)
        
    }
    
    //MARK:- 加载数据
    override func loadData() {
        super.loadData()
        DispatchQueue.main.async {[weak self]in
            self?.setupView()
            
        }
    }

    //MARK:- 布局
    override func setupView() {
        super.setupView()
         let menuToolHeight = 120*LayoutHeightScale
        let backView = UIView()
        backView.backgroundColor = UIColor.init(hexString: "#fafafa")
        view.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(backView.superview!)
            make.height.equalTo(menuToolHeight)
        }
       
        if menuToolView.superview == nil {
            view.addSubview(menuToolView)
            menuToolView.snp.makeConstraints({ (make) in
                make.top.equalTo(0)
                make.left.equalTo(200*LayoutWidthScale)
                make.right.equalTo(-200*LayoutWidthScale)
                make.height.equalTo(menuToolHeight)
            })
        }
        
        let commentToolHeight = 140*LayoutHeightScale
        if commentToolView.superview == nil{
            view.addSubview(commentToolView)
            commentToolView.snp.makeConstraints({ (make) in
                make.right.left.bottom.equalTo(commentToolView.superview!)
                make.height.equalTo(commentToolHeight)
            })
            
        }
        
        if pageContentView?.superview == nil{
            var childs = [CommentListViewController]()
            let hotCommentViewController = CommentListViewController(ID: self.ID, type: "hot")
            childs.append(hotCommentViewController)
            
            let newCommentViewController = CommentListViewController(ID: self.ID, type: "new")
            childs.append(newCommentViewController)
            
            let y = kStatusBarH + kNavigationBarH + menuToolHeight
            let height = ScreenHeight - y - commentToolHeight
            let frame = CGRect(x: 0, y: y, width: ScreenWidth, height: height)
            pageContentView = PageContentView(frame: frame, childVcs: childs, parentVc: self)
            view.addSubview(pageContentView!)
            pageContentView?.snp.makeConstraints({ (make) in
                make.top.equalTo(menuToolView.snp.bottom)
                make.left.right.equalTo((pageContentView?.superview!)!)
                make.height.equalTo(height)
            })   
        }
    }
    
    
    
}










