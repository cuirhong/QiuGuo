//
//  MatchDetailHeadView.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/9.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit


/**
 *  协议
 */
@objc
protocol MatchDetailHeadViewDelegate {
    func matchDetailHeadView(_ headView:MatchDetailHeadView)
}


/// 球赛详情头视图
class MatchDetailHeadView: BaseView {
    
    //MARK:- 代理 
    weak var delegate:MatchDetailHeadViewDelegate?
    
    
    //MARK:- 球赛模型
    var matchModel:MatchListModel?{
        didSet{
        
            roundNameLabel.text = matchModel?.RoundName
            
            teamLogoImageVeiw.kf_setImage(imageUrlStr: matchModel?.TeamLogo)
            
            beTeamLogoImageView.kf_setImage(imageUrlStr: matchModel?.BeTeamLogo)
            
            teamNameLabel.text = matchModel?.TeamName
            
            beTeamNameLabel.text = matchModel?.BeTeamName
            
            if let scroe = matchModel?.Score, let beScroe = matchModel?.BeScore{                
                scroceLabel.text = String(format: "%d : %d", scroe,beScroe)
            }else{
               scroceLabel.text = "-- : --"
            }

            matchStatusButton.isUserInteractionEnabled = false
            if matchModel?.status == "0"{
                settingWillStartMatchUI()
            }else if matchModel?.status == "1"{
                settingBeingMatchUI()
            }else{
                settingDidEndMatchUI()
            }
 
            
        }

    }
    
    
    //MARK:- 设置已结束界面
    private func settingDidEndMatchUI(){
        
        pkImageView.isHidden = true
     
         scroceLabel.isHidden = false
 
        matchStatusButton.setTitle("已结束", for: .normal)
        matchStatusButton.setImage(nil, for: .normal)
    
    }
    //MARK:- 设置即将开始界面
    private func settingWillStartMatchUI(){
        pkImageView.isHidden = false
        scroceLabel.isHidden = true

        matchStatusButton.setImage(UIImage.getImage("icon_clock"), for: .normal)
        
        var time = " ----"
        if let dateStr = matchModel?.StartTime{
            
            let date = String.getDateFromString(dateStr: dateStr)
            let com = date?.getDateComponents()
            
            if let hour = com?.hour,let minute = com?.minute{
                time = String(format: " %02d:%02d", hour,minute)
            }
        }
        matchStatusButton.setTitle(time, for: .normal)
    }
    //MARK:- 设置正在进行的比赛界面
    private func settingBeingMatchUI(){
        pkImageView.isHidden = true
 
        scroceLabel.isHidden = false

        matchStatusButton.setTitle("进行中", for: .normal)
        matchStatusButton.setImage(nil, for: .normal)
        
        
    }


    //MARK:- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = THEMECOLOR
        
        setupUI()
    }
    

    //MARK:- 设置UI
    private func setupUI(){
        
        addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(22*LayoutWidthScale)
            make.width.height.equalTo(88*LayoutHeightScale)
            make.top.equalTo(70*LayoutHeightScale)
        }
        
        addSubview(roundNameLabel)
        roundNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(76*LayoutHeightScale)
            make.centerX.equalTo(roundNameLabel.superview!)
        }
        
        
        addSubview(teamLogoImageVeiw)
        teamLogoImageVeiw.snp.makeConstraints { (make) in
            make.width.height.equalTo(88*LayoutHeightScale)
            make.right.equalTo(roundNameLabel.snp.left).offset(-50*LayoutWidthScale)
            make.top.equalTo(roundNameLabel)
        }
        
        addSubview(beTeamLogoImageView)
        beTeamLogoImageView.snp.makeConstraints { (make) in
            make.left.equalTo(roundNameLabel.snp.right).offset(50*LayoutWidthScale)
            make.top.width.height.equalTo(teamLogoImageVeiw)
        }

        
        addSubview(leftMaskImageView)
        leftMaskImageView.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(leftMaskImageView.superview!)
            make.top.equalTo(teamLogoImageVeiw.snp.bottom)
            make.right.equalTo((leftMaskImageView.superview?.snp.centerX)!)
        }
        
        addSubview(rightMaskImageView)
        rightMaskImageView.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(rightMaskImageView.superview!)
            make.left.equalTo(rightMaskImageView.superview!.snp.centerX)
            make.top.equalTo(leftMaskImageView)
        }
        
        
        addSubview(matchStatusButton)
        matchStatusButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(matchStatusButton.superview!)
            make.centerY.equalTo(leftMaskImageView)
        }
        
        //比分label不好控制布局，多加一个方便布局
        let label = UILabel()
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(roundNameLabel.snp.bottom)
            make.bottom.equalTo(matchStatusButton.snp.top)
            make.centerX.equalTo(label.superview!)
        }
        
        addSubview(scroceLabel)
        scroceLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(label)  
        }
        
        addSubview(pkImageView)
        pkImageView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(scroceLabel)
        }
        
        
       addSubview(teamNameLabel)
        teamNameLabel.snp.makeConstraints { (make) in
            make.right.equalTo(matchStatusButton.snp.left).offset(-98*LayoutWidthScale)
            make.centerY.equalTo(matchStatusButton)
        }
        
        addSubview(beTeamNameLabel)
        beTeamNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(matchStatusButton.snp.right).offset(98*LayoutWidthScale)
            make.centerY.equalTo(matchStatusButton)
        }

        let label1 = UILabel.unline()
        addSubview(label1)
        label1.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(label1.superview!)
            make.height.equalTo(1*LayoutHeightScale)
        }

    }
    
    
    
    
    
    
    //MARK:- 主队logo
    fileprivate lazy var teamLogoImageVeiw:UIImageView = UIImageView()
    
    //MARK:- 客队logo
    fileprivate lazy var beTeamLogoImageView:UIImageView = UIImageView()
    
    //MARK:- 名称
    fileprivate lazy var roundNameLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 34), textColor: UIColor.init(hexString: "#ffffff"),textAlignment:.center)
    
    //MARK:- 比分
    fileprivate lazy var scroceLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 60), textColor: UIColor.init(hexString: "#ffffff"),textAlignment:.center)
    
    //MARK:- 比赛状态按钮
    private lazy var matchStatusButton:UIButton = UIButton(title: "", font: UIFont.font(psFontSize: 34), titleColor: UIColor.init(hexString: "#ffffff"))
    
    //MARK:- 主队队名
    fileprivate lazy var teamNameLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 34), textColor: UIColor.init(hexString: "#ffffff"))
    
    //MARK:- 客队队名
    fileprivate lazy var beTeamNameLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 34), textColor: UIColor.init(hexString: "#ffffff"))
    
    //MARK:- 左边的蒙版 
    
    fileprivate lazy var leftMaskImageView:UIImageView = UIImageView(image: UIImage.getImage("team_navi_left.png"))
    
    //MARK:- 右边的蒙版
    fileprivate lazy var rightMaskImageView:UIImageView = UIImageView(image: UIImage.getImage("team_navi_right.png"))
    
    //MARK:- 返回按钮
    fileprivate lazy var backButton:UIButton = UIButton(title: "", imageName: "arrow_back", target: self, selector: #selector(MatchDetailHeadView.back))
    
    //MARK:- 未开始pk图标
    private lazy var pkImageView:UIImageView = UIImageView(image: UIImage.getImage("compared_w.png"))
    
    
    //MARK:- 返回按钮事件
    func back(){
        
        delegate?.matchDetailHeadView(self)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
}







