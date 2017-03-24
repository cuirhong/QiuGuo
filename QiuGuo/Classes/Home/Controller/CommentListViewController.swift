//
//  CommentListViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/24.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
let commentCell = "commentCell"

class CommentListViewController:BaseViewController {
    
    //MARK:- 文章ID
    var ID:Int = 0
    
    //MARK:- 评论viewModel
    fileprivate lazy var commentViewModel:CommentListViewModel = CommentListViewModel(ID: self.ID)
    
    //MARK:- 初始化
    convenience init(ID:Int,type:String){
      self.init()
        self.ID = ID
        commentViewModel.type = type    
    }
    
    //MARK:- 加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCommentListData()
       
      
    }
    
    //MARK:- 加载评论列表
    func loadCommentListData(){
        commentViewModel.loadCommentList(successCallBack: {[weak self] (result) in
            
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
            collectionView.register(CommentCell.classForCoder(), forCellWithReuseIdentifier: commentCell)
            collectionView.snp.makeConstraints({ (make) in
                make.top.left.right.bottom.equalTo(collectionView.superview!)
            })
        }
        
    }
    

    
   
}



// MARK: - 遵守UICollectionViewDataSource
extension CommentListViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCell, for: indexPath)
        return cell
    }
}

// MARK: - 遵守UICollectionViewDelegate
extension CommentListViewController:UICollectionViewDelegate{



}







