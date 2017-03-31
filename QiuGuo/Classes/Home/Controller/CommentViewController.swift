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
    
    //MARK:- 评论对象 1:文章 2:赛事 3:竞猜
    lazy var dataType:Int = 1
    
    //MARK:- menu工具条
    fileprivate lazy var menuToolView:MenuToolView = MenuToolView(titles: ["热门评论","","最新评论"], isSelMaxFont: false)
    
    //MARK:- 评论工具条
    fileprivate lazy var commentToolView:CommentToolViews = CommentToolViews(toolViewsType: .ArticleComment)
    
    //MARK:- contentView
    fileprivate var pageContentView:PageContentView?
    
    //MARK:- contentView的偏移值
    fileprivate lazy var targetContent:Int = 0
    
    //MARK:- 回复评论模型
    fileprivate var replyCommentModel:CommentModel?
    
    
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
            menuToolView.delegate = self
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
            commentToolView.delegate = self
            commentToolView.snp.makeConstraints({ (make) in
                make.right.left.bottom.equalTo(commentToolView.superview!)
                make.height.equalTo(commentToolHeight)
            })
            
        }
        
        if pageContentView?.superview == nil{
            var childs = [CommentListViewController]()
            let hotCommentViewController = CommentListViewController(ID: self.ID, type: "hot")
            hotCommentViewController.commentListType = .NormalCommentList
            hotCommentViewController.delegate = self
            childs.append(hotCommentViewController)
            
            let newCommentViewController = CommentListViewController(ID: self.ID, type: "new")
            newCommentViewController.commentListType = .NormalCommentList
            newCommentViewController.delegate = self
            childs.append(newCommentViewController)
            
            let y = kStatusBarH + kNavigationBarH + menuToolHeight
            let height = ScreenHeight - y - commentToolHeight
            let frame = CGRect(x: 0, y: y, width: ScreenWidth, height: height)
            pageContentView = PageContentView(frame: frame, childVcs: childs, parentVc: self)
            view.addSubview(pageContentView!)
            pageContentView?.delegate = self
            pageContentView?.snp.makeConstraints({ (make) in
                make.top.equalTo(menuToolView.snp.bottom)
                make.left.right.equalTo((pageContentView?.superview!)!)
                make.height.equalTo(height)
            })
            
            //添加评论刷新之后需要设置
            if targetContent != 0{
              pageContentView?.settingCurrenIndex(targetIndex: targetContent)
            }
            
        }
    }
   
}

// MARK: - PageContentViewDelegate,PageMenuViewDelegate
extension CommentViewController:PageContentViewDelegate,PageMenuViewDelegate{
    
    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
       var index = targetIndex
        if index == 1{
          index  = 2
        }
       self.menuToolView.setupMenuButton(index: index)
    }

    func pageMenuView(_ titleView: PageMenuView, sourceIndex: Int, targetIndex: Int) {
        var index = targetIndex
        if index == 2{
            index  = 1
        }
        targetContent = index
        self.pageContentView?.settingCurrenIndex(targetIndex: index)
    }


}

// MARK: - CommentToolViewsDelegate
extension CommentViewController:CommentToolViewsDelegate{

    func commentToolView(_ commentToolView: CommentToolViews, commentType: CommentType) {
        switch commentType {
        case .ReleaseComment:
            if UserInfo.userLogin(){
                let frame =  CGRect(x: 0, y: ScreenHeight - 483*LayoutHeightScale, width: ScreenWidth, height: 483*LayoutHeightScale)
                let editCommentView:EditCommentView = EditCommentView(frame: CGRect(x: 0, y: ScreenHeight - 483*LayoutHeightScale, width: ScreenWidth, height: 483*LayoutHeightScale))
                editCommentView.delegate = self
                if replyCommentModel != nil{
                    //回复评论
                    editCommentView.sendCommentBtn.setTitle("回复", for: .normal)
                }
                let alertStyle = AlertViewStyle(alertType: .Bottom, alertViewFrame: frame, isTapDissmiss: true, bottomBackColor: nil)
                let alertView = AlertBottomView(alertView: editCommentView, alertViewStyle: alertStyle)
                alertView.delegate = self
                alertView.show()
            }

        default:
            break
        }
    }


}

// MARK: - AlertBottomViewDelegate
extension CommentViewController:AlertBottomViewDelegate{

    func alertBottomView(_ alertBottomView: AlertBottomView, didDissmiss: Bool) {
        replyCommentModel = nil
    }


}

// MARK: - EditCommentViewDelegate
extension CommentViewController:EditCommentViewDelegate{
    //MARK:-  评论编辑文本框回调
    func editCommentView(_ editCommentView: EditCommentView, sendCommentText: String) {
        editCommentView.superview?.removeFromSuperview()
        sendComment(sendText: sendCommentText)
    }
    
    //MARK:- 发送评论
    func sendComment(sendText:String){
    
        let sendCommentViewModel = SendCommentViewModel()
        sendCommentViewModel.ID = self.ID
        sendCommentViewModel.DataType = self.dataType
        sendCommentViewModel.content = sendText
        if let onClickID = replyCommentModel?.ID{
           sendCommentViewModel.onclickID = onClickID
        }
        replyCommentModel = nil
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
        
        DispatchQueue.main.async {[weak self] in
            var imageName = "popup_comment_f"
            if isSuecces {
                imageName = "popup_comment_s"
            }
            
            if isSuecces {
                if let views = self?.view.subviews {
                    for view in views{
                        view.removeFromSuperview()
                    }
                    
                }
            }
            self?.loadData()
            let alertStyle = AlertViewStyle(alertType: .Center, alertViewFrame: nil, isTapDissmiss: true, bottomBackColor: UIColor.clear)
            let hintCommentSuccess = AlertBottomView(alertView: UIImageView(image:UIImage.getImage(imageName)), alertViewStyle: alertStyle)
            hintCommentSuccess.show()
        }
    }


}


// MARK: - CommentListViewControllerDelegate
extension CommentViewController :CommentListViewControllerDelegate{

     //MARK:- 回复评论回调
    func commentListViewController(_ controller: CommentListViewController, replyCommentModel: CommentModel) {
        self.replyCommentModel = replyCommentModel
        commentToolView(commentToolView, commentType: .ReleaseComment)
       
    }



}




