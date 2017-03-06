//
//  ShufflingFigureView.swift
//  QiuGuo
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import Kingfisher


private let shuffingFigureCell = "shuffingFigureCell"

@objc
protocol ShuffingFigureViewDelegate {
    @objc optional func shuffingFigureView(_ shuffingFigureView:UIView?,selectedIndex index:Int)
}
class ShufflingFigureView: BaseView {
    weak var delegate:ShuffingFigureViewDelegate?
    //网络图片地址数组
    fileprivate var imageUrlArr:[String]? = []
     //本地图片地址数组
    fileprivate var imageNameArr:[String]? = []
    //标题数组
    fileprivate var titleArr:[String]? = []
    
    
    init(imageUrls:[String]?=[],imageName:[String]?=[],titles:[String]?=[]){
    super.init(frame: CGRect.zero)
        if (imageUrls != nil) {
          imageUrlArr = imageUrls
        }
   
        if imageName != nil {
         imageNameArr = imageName
        }
        
        if titleArr != nil {
         titleArr = titles
        }

        setupUI()

    }
    
    private func setupUI(){
    
        addSubview(collectionView)
        collectionView.snp.remakeConstraints { (make) in
            make.left.right.bottom.top.equalTo(collectionView.superview!)
        }
        
        addSubview(bottomMaskView)
        bottomMaskView.snp.remakeConstraints { (make) in
            make.bottom.left.right.equalTo(bottomMaskView.superview!)
            make.height.equalTo(84*LayoutHeightScale)
        }
        
        addSubview(pageControll)
        pageControll.snp.remakeConstraints { (make) in
            make.right.equalTo(40*LayoutWidthScale)
            make.top.equalTo(bottomMaskView).offset(30*LayoutHeightScale)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(30*LayoutWidthScale)
            make.top.equalTo(bottomMaskView.snp.top).offset(20*LayoutHeightScale)
            make.right.lessThanOrEqualTo(pageControll.snp.left)
        }
        
      
        pageControll.numberOfPages = (titleArr?.count)!
         pageControll.currentPage = 0
        
    
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    
    
    // MARK:- 懒加载
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
        let layout =  UICollectionViewFlowLayout()
        //布局属性 大小 滚动方向  间距
        layout.itemSize = CGSize(width: ScreenWidth, height: 530*LayoutHeightScale)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self as UICollectionViewDataSource?
        collectionView.delegate = self as UICollectionViewDelegate?
        collectionView.backgroundColor = UIColor.white
    
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: shuffingFigureCell)
        return collectionView
        }()

    // MARK:- 创建轮播图的标题
    fileprivate lazy var titleLabel:UILabel = UILabel(text: "梅西捧起冠军奖杯", font: UIFont.font(psFontSize: 46), textColor: UIColor.init(hexString: "#ffffff"), textAlignment: .left)
   
    
    // MARK:- 创建pageControll
    fileprivate lazy var pageControll:UIPageControl = {
        
        let pageControl = UIPageControl()
        pageControl.setValue(UIImage.getImage("banner_point_n.png"), forKey: "pageImage")
        pageControl.setValue(UIImage.getImage("banner_point_h.png"), forKey: "currentPageImage")
        return pageControl
    }()
    // MARK:- 创建蒙板视图
    fileprivate lazy var bottomMaskView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hexString: "#000")
        view.alpha = 0.5
        return view
    }()
    
    

    
    
    
    
    
}


//协议方法
extension ShufflingFigureView:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard imageUrlArr?.count == 0 else {
            return (imageUrlArr?.count)!
        }
        guard imageNameArr?.count == 0 else {
            return (imageNameArr?.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: shuffingFigureCell, for: indexPath)
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

        if (imageNameArr?.count)! > indexPath.item{
        
            imageView?.image = UIImage.getImage((imageNameArr?[indexPath.item])!)
        
        }else if (imageUrlArr?.count)! > indexPath.item{

            let url:String = imageUrlArr![indexPath.item]
            let resource = ImageResource(downloadURL:NSURL.init(string:url) as! URL, cacheKey: url)
            imageView?.kf.setImage(with: resource)
         
        }
        
        guard (titleArr?.count)!<indexPath.item else {
             titleLabel.text = titleArr?[indexPath.item]
            return cell
        }
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.shuffingFigureView!(self, selectedIndex: indexPath.item)
    }
    
    



}








