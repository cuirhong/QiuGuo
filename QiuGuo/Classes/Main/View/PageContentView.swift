//
//  PageContentView.swift
//  QiuGuo
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

private let contentCellID = "contentCellID"
// MARK: - 代理
protocol PageContentViewDelegate: class {
    func pageContentView(_ contentView : PageContentView,progress:CGFloat,sourceIndex:Int,targetIndex:Int)
}


class PageContentView: BaseView {
    //MARK:- contentView的frame
    fileprivate var newFrame:CGRect = CGRect.zero
    //MARK:- 定义代理
    weak var delegate:PageContentViewDelegate?
    
    //MARK:- 是否是点击滚动
    fileprivate var isClickScrollDelegate:Bool = false
    //MARK:- 开始偏移位置
    fileprivate var startOffsetX:CGFloat = 0
    //MARK:- 子控制器
    fileprivate var childVcArr:[UIViewController] = []
    //MARK:- 父控制器(需要使用弱引用，否则又循环引用)
    fileprivate weak  var parentVc:UIViewController?
    //MARK:- 创建collectionView
    fileprivate lazy var collectionView:UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()

        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellID)
        return collectionView

    }()
    
    
    
    //MARK:- 初始化
    init(frame:CGRect,childVcs:[UIViewController],parentVc:UIViewController){
    
        super.init(frame: frame)
        newFrame = frame
        childVcArr = childVcs
        self.parentVc = parentVc
        setupUI()
    
    
    }
    
    //MARK:- 设置界面
    private func setupUI(){
        for childVc in childVcArr {
             parentVc?.addChildViewController(childVc)
           
        }
        addSubview(collectionView)

        //这里使用left.right.top.bottom和夫试图相等时布局有问题
        collectionView.snp.remakeConstraints { (make) in
                make.top.left.equalTo(0)
                make.width.equalTo(newFrame.size.width)
                make.height.equalTo(newFrame.size.height)
            
        }
    
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}


// MARK: - 遵守数据源代理方法
extension PageContentView:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellID, for: indexPath)
        for view in cell.contentView.subviews {
             view.removeFromSuperview()
        }
        
        let childVc = childVcArr[indexPath.item]
        cell.contentView.addSubview(childVc.view)
        childVc.view.snp.remakeConstraints { (make) in
            make.top.right.bottom.left.equalTo(childVc.view.superview!)
        }
         return cell
    }
}

// MARK: - 遵守UICollectionViewDelegate代理方法
extension PageContentView:UICollectionViewDelegate{
    
    //MARK:-  开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isClickScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    //MARK:- 滑动完成
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //如果是点击传导过来则不处理
        if isClickScrollDelegate {
            return
        }
        
        //左右滑动处理
        var progress:CGFloat = 0
        var sourceIndex:Int = 0
        var targetIndex:Int = 0
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewWidth = newFrame.size.width
        if currentOffsetX > startOffsetX{
            progress = currentOffsetX / scrollViewWidth - floor(currentOffsetX/scrollViewWidth)
            sourceIndex = Int(currentOffsetX / scrollViewWidth)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcArr.count {
                 targetIndex = childVcArr.count - 1
            }
            
            if currentOffsetX - startOffsetX == scrollViewWidth{
            progress = 1
                targetIndex = sourceIndex
            }
        
        
        }else{
        
            progress = 1 - (currentOffsetX / scrollViewWidth - floor(currentOffsetX / scrollViewWidth))
            targetIndex = Int(currentOffsetX/scrollViewWidth)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcArr.count {
                 sourceIndex = childVcArr.count - 1
            }
            if startOffsetX - currentOffsetX == scrollViewWidth{
                sourceIndex = targetIndex
            }
        }
        
        
        // MARK: - 调用代理方法
        delegate?.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
   
    }
    
    
    



}


// MARK: - 遵守UICollectionViewDelegateFlowLayout布局方法 
extension PageContentView:UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return newFrame.size
    }



}





