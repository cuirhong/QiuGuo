//
//  CommentListViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/24.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit


var commentCollectionCell = "commentCell"
var replyCommentCell = "replyCommentCell"
let nickNameHeight:CGFloat = 20.5
let fiexibleBtnHeight:CGFloat = 16.0
let timeLabelHeight:CGFloat = 13.5


enum CommentListType {
    case MeComment;// 我的评论
    case ReplyCommentList;// 回复评论的评论列表
    case NormalCommentList;//普通评论
}



protocol CommentListViewControllerDelegate:NSObjectProtocol {
    func commentListViewController(_ controller:CommentListViewController,replyCommentModel:CommentModel)
}

class CommentListViewController:BaseViewController {
    
    //MARK:- 评论列表的类型
    var commentListType:CommentListType = .MeComment

    //MARK:- 文章ID
    var ID:Int = 0
    
    //MARK:- 评论编辑框代理
    weak var delegate:CommentListViewControllerDelegate?
    
    //MARK:- 评论viewModel
     lazy var commentViewModel:CommentListViewModel = CommentListViewModel(ID: self.ID)
    
    //MARK:- 发送／删除评论viewModel
    lazy var sendCommentViewModel:SendCommentViewModel  = SendCommentViewModel()
    
    //MARK:- 初始化
    convenience init(ID:Int,type:String){
      self.init()
        self.ID = ID
        commentViewModel.type = type    
    }
    
    //MARK:- 加载
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBack(target: self)
        switch commentListType {
        case .MeComment:
             fallthrough
        case .NormalCommentList:
            NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: reloadDataCommentNotifName), object: nil)
            loadCommentListData()
            
            addRefresh(downLoadRefresh: true, upLoadRefresh: true)
        case .ReplyCommentList:
            setupView()
        }

        
    }
    
    //MARK:- 加载评论列表
    func loadCommentListData(){
        commentViewModel.loadCommentList(commentListType: commentListType, successCallBack: {[weak self] (result) in
            DispatchQueue.main.async {
                let isNormal = self?.checkDataIsNormal(hintTextArr: ["暂无评论 快抢沙发"], hintImageName: "sofa", dataAbnormalType: (self?.commentViewModel.dataAbnormalType)!)
                if isNormal == true{
                    
                    self?.setupView()
                    
                }
                 self?.endRefreshing()
                
            }
        }) {[weak self] (error) in
            self?.endRefreshing()
            HUDTool.show(showType: .Failure, text: error.debugDescription)
        }

    }
    
    
    //MARK:- 加载view
    override func setupView() {
        super.setupView()
        
        if collectionView.superview == nil{
            view.addSubview(collectionView)
            
            collectionView.register(CommentCell.classForCoder(), forCellWithReuseIdentifier: commentCollectionCell)
            collectionView.register(CommentCell.classForCoder(), forCellWithReuseIdentifier: replyCommentCell)
            collectionView.snp.makeConstraints({ (make) in
                make.top.left.right.bottom.equalTo(collectionView.superview!)
            })
        }else{
        
            collectionView.reloadData()
        
        }
        
    }
    
    //MARK:- 刷新数据
    func reloadData(notif:NSNotification){
        let object:String = notif.object as! String
        if object == "0"{
            //展开
           collectionView.reloadData()
        }else if object == "1"{
           //删除/添加
            commentViewModel.refreshType = .PullDownRefresh
            commentViewModel.page = 1
            commentViewModel.rows = commentViewModel.commentDataArray.count + 1
            commentViewModel.dataAbnormalType = .noAbnormal
            DispatchQueue.global().async {[weak self] in
                 self?.loadCommentListData()
            }
        }
    }
    
    //MARK:- 删除评论
    func deleteComment(commentModel:CommentModel){
        DispatchQueue.global().async {[weak self] in
            self?.sendCommentViewModel.ID = commentModel.ID
            self?.sendCommentViewModel.deleteComment(successCallBack: { (result) in
                let code = result["code"]
                if code == 1 {
                    
                    printData(message: "删除成功")
                }else{
                     printData(message: "删除失败")
                   
                }
            }) { (error) in
                printData(message: error.debugDescription)
                
            }
        }
    }
    
    //MARK:- 点赞
    func clickLikeComment(commentModel:CommentModel){
        DispatchQueue.global().async {[weak self]in
            self?.sendCommentViewModel.ID = commentModel.ID
            self?.sendCommentViewModel.clickLike(successCallBack: { (result) in
                let code = result["code"]
                if code == 1 {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: reloadDataCommentNotifName), object: "1")
                    }
                }else{
                    HUDTool.show(showType: .Failure, text: "失败")
                }

            }, failureCallBack: { (error) in
                 HUDTool.show(showType: .Failure, text: error.debugDescription)
            })
            
        }
    
    }
    
    
    //MARK:- 下拉刷新
    override func downLoadRefresh() {
        super.downLoadRefresh()
        commentViewModel.refreshType = .PullDownRefresh
        commentViewModel.page = 1
        commentViewModel.rows = 10
        commentViewModel.dataAbnormalType = .noAbnormal
        DispatchQueue.global().async {[weak self] in
            self?.loadCommentListData()
        }
    }
    
    //MARK:- 上拉加载
    override func upLoadRefresh() {
        super.upLoadRefresh()
        if commentViewModel.refreshType == .PullDownRefresh || commentViewModel.isEnd == "1"{
            commentViewModel.refreshType = .UpDownRefresh
            commentViewModel.page += 1
             commentViewModel.rows = 10
            commentViewModel.dataAbnormalType = .noAbnormal
            DispatchQueue.global().async {[weak self] in
                self?.loadCommentListData()
            }
        }else{
            collectionView.endFooterRefreshingWithNoMoreData()
        }
    }
    
    //MARK:- 回复评论
    func replyComment(_ commentModel:CommentModel){
       delegate?.commentListViewController(self, replyCommentModel: commentModel)
      
    }
    
    //MARK:- 举报评论
    func reportComment(_ commentModel:CommentModel){

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        
        let spamAction = UIAlertAction(title: "垃圾广告信息", style: .default) {[weak self] (action) in
            self?.reportComment(title: action.title)
        }
        
        let breakLawAction = UIAlertAction(title: "色情,暴力,血腥等违反法律法规内容", style: .default) {[weak self]  (action) in
            self?.reportComment(title: action.title)
        }
        
        let abuseAction = UIAlertAction(title: "辱骂,歧视,挑衅等不友善内容", style: .default) {[weak self]  (action) in
            self?.reportComment(title: action.title)
        }
        
        let actions = [cancelAction,spamAction,breakLawAction,abuseAction]
        UIAlertController.setActionTitle(actions: [spamAction,breakLawAction,abuseAction], color: UIColor.init(hexString: "#808080")!)
         UIAlertController.setActionTitle(actions: [cancelAction], color: THEMECOLOR)
  
        let alertController =  UIAlertController.alert(title: nil, message: nil, style: .actionSheet, actions: actions)
       
        present(alertController, animated: true, completion: nil)
    
    
    }
    
    //MARK:- 举报评论
    func reportComment(title:String?){
        if title == nil{
            HUDTool.show(showType: .Info, text: "请选择举报原因",viewController: self)
            return
        }
        sendCommentViewModel.reportComment(reason: title!, successCallBack: { (result) in
            
            DispatchQueue.main.async {
                let code = result["code"].intValue
                 var imageName = "popup_report_f"
                if code == 1{
                     //举报成功
                      imageName = "popup_report_s"
                }
               
                let alertStyle = AlertViewStyle(alertType: .Center, alertViewFrame: nil, isTapDissmiss: true, bottomBackColor: nil)
                let hintCommentSuccess = AlertBottomView(alertView: UIImageView(image:UIImage.getImage(imageName)), alertViewStyle: alertStyle)
                hintCommentSuccess.show()
            }  
        }) { (error) in
             HUDTool.show(showType: .Info, text: error.debugDescription)
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    
   
}



// MARK: - 遵守UICollectionViewDataSource
extension CommentListViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentViewModel.commentDataArray.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let commentModle = commentViewModel.commentDataArray[indexPath.item]
        
        var viewType:CommentViewType = .BasicComment
        var cellIdentifier:String = commentCollectionCell
        
        if commentModle.displyType == 2{
            viewType = .replyComment
           cellIdentifier = replyCommentCell
            
        }
         let cell = CommentCell.getCommentCell(viewType: viewType, collectionView: collectionView, indexPath: indexPath, cellIdentifier: cellIdentifier)
        cell.delegate = self
        
        cell.commentModel = commentModle
        
        
        if commentModle.displyType == 2{
          
            /*
             view.layer.shadowOffset = CGSizeMake(0, 3);
             view.layer.shadowOpacity = 0.7;
             view.layer.shouldRasterize = YES;
             
             // shadow
             UIBezierPath *path = [UIBezierPath bezierPath];
             
             CGPoint topLeft      = view.bounds.origin;
             CGPoint bottomLeft   = CGPointMake(0.0, CGRectGetHeight(view.bounds) + 10);
             CGPoint bottomMiddle = CGPointMake(CGRectGetWidth(view.bounds) / 2, CGRectGetHeight(view.bounds) - 5);
             CGPoint bottomRight  = CGPointMake(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds) + 10);
             CGPoint topRight     = CGPointMake(CGRectGetWidth(view.bounds), 0.0);
             
             [path moveToPoint:topLeft];
             [path addLineToPoint:bottomLeft];
             [path addQuadCurveToPoint:bottomRight
             controlPoint:bottomMiddle];  
             [path addLineToPoint:topRight];  
             [path addLineToPoint:topLeft];  
             [path closePath];  
             
             view.layer.shadowPath = path.CGPath;
             */
         
            cell.commentView?.layer.shadowOffset = CGSize(width: 0, height: 3)
            cell.commentView?.layer.shadowOpacity = 0.1
        
            let width = commentModle.commentLayout.commentTextWidth + (80+16)*LayoutWidthScale + commentModle.commentLayout.clickBtnRight
            let height = commentModle.getCommentCellHeight()
          
            let shodwPath = UIBezierPath.init()
            let topLeft = CGPoint(x: 0, y: 0)
            let bottomLeft = CGPoint(x: 0, y: commentModle.getCommentCellHeight() - 3)
            let bottomMiddle = CGPoint(x: width/2, y: height-3)
            let bottomRight = CGPoint(x: width, y: height-3)
            let topRight = CGPoint(x: width, y: 0)
            shodwPath.move(to: topLeft)
            shodwPath.addLine(to: bottomLeft)
            shodwPath.addQuadCurve(to: bottomRight, controlPoint: bottomMiddle)
            shodwPath.addLine(to: topRight)
            shodwPath.addLine(to: topLeft)
            shodwPath.close()
            cell.commentView?.layer.shadowPath = shodwPath.cgPath
        }
        return cell
    }
    
    //MARK:- 点击cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        if UserInfo.userLogin() == false{
            return
        }
        
        var commentModel:CommentModel? = commentViewModel.commentDataArray[indexPath.item]
         let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        var actions = [cancelAction]
     
        UIAlertController.setActionTitle(actions: [cancelAction], color: THEMECOLOR)
        if commentModel?.UserID == UserInfo.loadAccount()?.UserID{//自己的评论
           
            let deleteAction = UIAlertAction(title: "删除", style: .destructive, handler: {[weak self] (anction) in
                self?.deleteComment(commentModel:commentModel!)
                commentModel = nil
            })
            actions.append(deleteAction)
        }else{//回复评论
            let reportComment = UIAlertAction(title: "举报", style: .default, handler: {[weak self] (action) in
                 self?.reportComment(commentModel!)
            })
            
            let replyComment = UIAlertAction(title: "回复", style: .default, handler: {[weak self] (anction) in
                self?.replyComment(commentModel!)
                
            })
            actions.append(reportComment)
            actions.append(replyComment)
               UIAlertController.setActionTitle(actions: [reportComment,replyComment], color: UIColor.init(hexString: "#808080")!)
        
        }
        let alertController =  UIAlertController.alert(title: nil, message: nil, style: .actionSheet, actions: actions)
        present(alertController, animated: true, completion: nil)
        
    }
    
  
    
    
    
    
    
}

// MARK: - 遵守UICollectionViewDelegate
extension CommentListViewController:UICollectionViewDelegate{



}


// MARK: - 遵守UICollectionViewDelegateFlowLayout
extension CommentListViewController:UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let commentModel = commentViewModel.commentDataArray[indexPath.item]
        let height:CGFloat = commentModel.getCommentCellHeight()
        var width = ScreenWidth
        if commentModel.displyType == 2{
           width = commentModel.commentLayout.commentTextWidth + (80+16)*LayoutWidthScale + commentModel.commentLayout.clickBtnRight - 2

        }
        return CGSize(width: width, height: height)
    }
}

// MARK: - 遵守CommentCellDelegate
extension CommentListViewController:CommentCellDelegate{
    func commentCell(_ commentCell: CommentCell?, singleCommentView: SingleCommentView, clickResponseType: ClickResponseType) {
        switch clickResponseType {
        case .UnflodBasicComment://展开评论
            singleCommentView.commentModel?.fiexildAllContent = 1
            //通知最底部评论视图的controller刷新
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: reloadDataCommentNotifName), object: "0")
        case .ClickLike://点赞
            if let modle = singleCommentView.commentModel{
             clickLikeComment(commentModel:modle)
            }
            
            
        default:
             break
        }
    }
}















