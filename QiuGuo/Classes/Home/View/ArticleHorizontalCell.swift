//
//  ArticleHorizontalCell.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/8.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit


private let articleImageCell = "articleImageCell"

@objc
protocol ArticleHorizontalCellDelegate {
    func articleHorizontalCell(_ articleHorizontalCell:ArticleHorizontalCell?,indexPath:IndexPath?,articleModel:ArticleListModel)
}

class ArticleHorizontalCell: ArticleNormalCell {
    
    //MARK:- 代理
    weak var delegate:ArticleHorizontalCellDelegate?


    //MARK:- 文章列表模型
    var articleListModel:ArticleListModel?{    
        didSet{
            textLabel.text = articleListModel?.Title
            if articleModel?.IsProfundity == 1{
                resourceLabel.text = "深度"
                resourceLabel.textColor = UIColor.init(hexString: "#808080")
            }else{
                if articleModel?.Tag != ""{
                    resourceLabel.text = articleModel?.Tag
                    if let color = articleModel?.TagColor{
                        resourceLabel.textColor = UIColor.init(hexString: color)
                    }
                }
            }
 
            commentButton.setTitle((articleListModel?.Comments.description)! + " " + "评论", for: .normal)
            collectionView.reloadData()
        }
    }
    
    
    
    
    
    
    // MARK:- 懒加载
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
        let layout =  UICollectionViewFlowLayout()
        //布局属性 大小 滚动方向  间距
        
        layout.minimumLineSpacing = 23*LayoutWidthScale
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.dataSource = self as UICollectionViewDataSource?
        collectionView.delegate = self as UICollectionViewDelegate?
        collectionView.backgroundColor = UIColor.white
        
        
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: articleImageCell)
        return collectionView
        }()

    
    //MARK:- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
        //添加跳转到详情界面
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(jumpToDetail)))
    }
    
    //MARK:- 跳转到文章详情
    func jumpToDetail(){
        if let model = articleListModel{
             delegate?.articleHorizontalCell(self, indexPath: nil, articleModel: model) 
        }   
    }
    
    //MARK:- 设置界面
    func setupUI(){
 
        textLabel.numberOfLines = 1
        textLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(20*LayoutHeightScale)
            make.left.equalTo(30*LayoutWidthScale)
            make.right.equalTo(-30*LayoutWidthScale)
             
        }
    
        contentView.addSubview(collectionView)
        collectionView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(textLabel)
            make.top.equalTo(textLabel.snp.bottom).offset(20*LayoutHeightScale)
            make.height.equalTo(216*LayoutHeightScale)
        }
        
        
        resourceLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(textLabel)
           make.centerY.equalTo(commentButton)
        }

    }
    
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// MARK: - 遵守UICollectionViewDataSource
extension ArticleHorizontalCell:UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (articleListModel?.Covers?.count)!
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: articleImageCell, for: indexPath)

        let imageTag = 100
        var imageView:UIImageView? = cell.contentView.viewWithTag(imageTag) as! UIImageView?
        if imageView == nil{
            imageView = UIImageView()
            imageView?.tag = imageTag
            cell.contentView.addSubview(imageView!)
            imageView?.snp.remakeConstraints({ (make) in
                make.left.right.bottom.top.equalTo((imageView?.superview!)!)
            })
        }
        imageView?.kf_setImage(imageUrlStr: articleListModel?.Covers?[indexPath.item])
        
        return cell
       
    }



}

// MARK: - 遵守UICollectionViewDelegate
extension ArticleHorizontalCell:UICollectionViewDelegate{


    //MARK:- 点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
       
    }


}

// MARK: - 遵守UICollectionViewDelegateFlowLayout
extension ArticleHorizontalCell:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 325*LayoutWidthScale, height: 215*LayoutHeightScale)
    }




}










