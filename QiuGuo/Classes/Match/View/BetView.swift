//
//  Betswift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/17.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

/// 比赛详情页的menu工具
class BetView: UIView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        setupUI()
    }
    
    private func setupUI(){
        
        
        
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        
        
        addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(bottomView.superview!)
            make.height.equalTo(600*LayoutHeightScale)
        }
        
        addSubview(meMaskView)
        meMaskView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(meMaskView.superview!)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.addSubview(betButton)
        betButton.snp.makeConstraints { (make) in
            make.left.equalTo(64*LayoutWidthScale)
            make.right.equalTo(-64*LayoutWidthScale)
            make.bottom.equalTo(-72*LayoutHeightScale)
            make.height.equalTo(97*LayoutHeightScale)
        }
        
        
        bottomView.addSubview(changeTicketsSeg)
        changeTicketsSeg.snp.makeConstraints { (make) in
            make.bottom.equalTo(betButton.snp.top).offset(-90*LayoutHeightScale)
            make.centerX.equalTo(betButton)
            make.width.equalTo(450*LayoutWidthScale)
        }
        
        let label1:UILabel = UILabel(text: "投", font: UIFont.font(psFontSize: 38), textColor: UIColor.init(hexString: "464646"))
        bottomView.addSubview(label1)
        label1.snp.makeConstraints { (make) in
            make.right.equalTo(changeTicketsSeg.snp.left).offset(-35*LayoutWidthScale)
            make.centerY.equalTo(changeTicketsSeg)
        }
        
        let label2:UILabel = UILabel(text: "倍", font: UIFont.font(psFontSize: 38), textColor: UIColor.init(hexString: "464646"))
        bottomView.addSubview(label2)
        label2.snp.makeConstraints { (make) in
            make.left.equalTo(changeTicketsSeg.snp.right).offset(35*LayoutWidthScale)
            make.centerY.equalTo(changeTicketsSeg)
        }
        
       bottomView.addSubview(meTicketsLabel)
        meTicketsLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(changeTicketsSeg.snp.top).offset(-70*LayoutHeightScale)
            make.left.equalTo(64*LayoutWidthScale)
        }
        
        bottomView.addSubview(currentChooseHintBtn)
        currentChooseHintBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(currentChooseHintBtn.superview!)
            make.bottom.equalTo(meTicketsLabel.snp.top).offset(-62*LayoutHeightScale)
            make.height.equalTo(85*LayoutHeightScale)
        }

    
    
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK:- 立即投注
    @objc private func bet(){
        printData(message:  #function)
        HUDTool.show(showType: .Info, text: "抱歉暂未开通此功能")
        
    }
    //MARK:- 蒙版
    fileprivate lazy var meMaskView:UIView = {
    
        let view = UIView()
        view.backgroundColor = UIColor.init(hexString: "#000")
        view.alpha = 0.5
        
        return view
    }()
    
    //MARK:- 移除按钮
    fileprivate lazy var moveBtn:UIButton = UIButton( imageName: "",target: self, selector: #selector(move))
    
    //MARK:- 提示当前已经选择的
    fileprivate lazy var currentChooseHintBtn:UIButton = UIButton(title: "你当前选择为:", backgroundColor: UIColor.init(hexString: "#efeeee"), font: UIFont.font(psFontSize: 38), titleColor: THEMECOLOR)
    //MARK:- 我的球票
    fileprivate lazy var meTicketsLabel:UILabel = {
        
        let label = UILabel(text: "我的球票" + " 0", font: UIFont.font(psFontSize: 38), textColor: UIColor.init(hexString: "464646"))
        label.setDiffirentText(needText: "0", fontSize: 38, fontColor: THEMECOLOR)
        return label
        
    }()
    
    //MARK:- 立刻投注
    fileprivate lazy var betButton:UIButton = UIButton(title: "立即投注 100球票", backgroundColor: THEMECOLOR, target: self, selector: #selector(bet), font: UIFont.font(psFontSize: 45), titleColor: UIColor.init(hexString: "#ffffff"))
    //MARK:- 改变投注
    fileprivate lazy var changeTicketsSeg:UISegmentedControl = UISegmentedControl.init(items: ["-","1","+"])
    
    //MARK:- 触摸屏幕
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        move()
    }

    //MARK:- 移除
    @objc private func move(){
       self.removeFromSuperview()
    }
    




}
