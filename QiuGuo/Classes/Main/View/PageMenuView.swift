//
//  PageMenuView.swift
//  QiuGuo
//
//  Created by apple on 17/3/5.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//


import UIKit
private let selectorColor:UIColor = UIColor.init(hexString: "2fce81")!
private let normalColor:UIColor = UIColor.init(hexString: "#666666")!
private let selFontColor:UIFont = UIFont.font(psFontSize: 60)

private var oneMenuWidth:CGFloat = 40

private let normalMargin:CGFloat = 72*LayoutWidthScale

private let selMargin:CGFloat = 66*LayoutWidthScale


// MARK: - 代理
protocol PageMenuViewDelegate: class {
    func pageMenuView(_ titleView : PageMenuView, selectedIndex index : Int)
}


class PageMenuView: BaseView {

    var menuTitles:[String] = []
    
    var isMask:Bool = true
    
    weak var delegate:PageMenuViewDelegate?
    
    
    init(titles:[String],isNeedUnline:Bool=false,isNeedMask:Bool=true){
    super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
      menuTitles = titles
        isMask = isNeedMask
    addSubview(scrollView)
        let  left = 50*LayoutWidthScale
        scrollView.snp.remakeConstraints { (make) in
            make.left.equalTo(scrollView.superview!).offset(left)
            make.right.equalTo(scrollView.superview!).offset(-left)
            make.top.equalTo(scrollView.superview!)
            make.height.equalTo(120*LayoutHeightScale)
        }

        
        setupMenuButton()
        
     
        
        
    }
    
    //MARK:-设置约束
    func setupMenuButton(index:Int=0) {
        
        for view in scrollView.subviews{
            view.removeFromSuperview()
        }
        
        var preBtn:UIView = scrollView
        var totalWidth:CGFloat = 0
        var selectorBtn:UIButton?
        for newIndex in 0..<menuTitles.count {
            let btn:UIButton = createMenuButton(title: menuTitles[newIndex],tag:newIndex)
            oneMenuWidth = btn.bounds.size.width
            scrollView.addSubview(btn)

            if index == newIndex{
                btn.isSelected = true
                btn.titleLabel?.font = UIFont.font(psFontSize: 60)
                selectorBtn = btn
            }
            
            if newIndex == 0{
              
                btn.snp.remakeConstraints({ (make) in
                    make.left.equalTo(preBtn).offset(0)
                    make.centerY.equalTo(scrollView)
                })
            }else if index == newIndex || newIndex == index+1{
                
                btn.snp.remakeConstraints({ (make) in
                    make.left.equalTo(preBtn.snp.right).offset(selMargin)
                    make.centerY.equalTo(scrollView)
                })
            }else{
              
                btn.snp.remakeConstraints({ (make) in
                    make.left.equalTo(preBtn.snp.right).offset(normalMargin)
                    make.centerY.equalTo(scrollView)
                })
            }
            totalWidth+=btn.bounds.size.width
            preBtn = btn
        }
        
        //如果需要蒙板
        if isMask{
        
            addSubview(leftMaskImageView)
            addSubview(rightMaskImageView)
            leftMaskImageView.snp.remakeConstraints({ (make) in
                make.left.centerY.equalTo(leftMaskImageView.superview!)
            })
            rightMaskImageView.snp.remakeConstraints({ (make) in
                make.right.centerY.equalTo(rightMaskImageView.superview!)
            })
        }
        
        
        let  margin = CGFloat(menuTitles.count - 1 - 2) * normalMargin + 2*selMargin + 5
        
        totalWidth += margin
        scrollView.contentSize = CGSize(width: totalWidth, height: 0)
        setupTitleCenter(button: selectorBtn!)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate lazy var scrollView:UIScrollView = {[weak self] in
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = false
        scrollView.backgroundColor = UIColor.white
        scrollView.bounces = false
        scrollView.scrollsToTop = false
        scrollView.delegate = self
        return scrollView
    }()
    
    //MARK:- 创建标题按钮
    private func createMenuButton(title:String,tag:Int) -> UIButton {
        let btn:UIButton = UIButton(title: title, target: self, selector: #selector(clickTitleMenu), font: UIFont.font(psFontSize: 52), titleColor: normalColor,selTitleColor:selectorColor)
        btn.tag = tag
        btn.sizeToFit()
        return btn
    }
    
    //MARK:- 创建蒙板
    private lazy var leftMaskImageView:UIImageView = {
        let imageView = UIImageView.init(image: UIImage.getImage("mask_l"))
        return imageView
    }()
    private lazy var rightMaskImageView:UIImageView = {
        let imageView = UIImageView.init(image: UIImage.getImage("mask_r"))
        return imageView
    }()
    

   
    
    
    
}

// MARK: - 代理方法
extension PageMenuView:UIScrollViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
    }
}


// MARK: - 点击交互
extension PageMenuView{
    
    //MARK:- 点击标题按钮
    @objc fileprivate func clickTitleMenu(sender:UIButton){
        delegate?.pageMenuView(self, selectedIndex: sender.tag)
        setupMenuButton(index: sender.tag)        
    }
    
    // MARK: - 让标题按钮自动居中（如果按钮的中心点 > 屏幕的中心点则将按钮中心点偏移）
    fileprivate func setupTitleCenter(button: UIButton) {
        // 判断标题按钮是否需要移动
        let tag:CGFloat = CGFloat(button.tag)
        let scrollViewWidth = ScreenWidth - 50*LayoutWidthScale*2
        var offsetX:CGFloat = button.bounds.size.width * 0.5 + tag * oneMenuWidth + (tag - 1) * normalMargin + selMargin - scrollViewWidth * 0.5
        let maxOffsetX = scrollView.contentSize.width - scrollViewWidth
        if (offsetX < 0) {
            offsetX = 0
        }
        if (offsetX > maxOffsetX) {
            if button.tag != 0 {
                offsetX = maxOffsetX
            }
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    

    
   
    


}







