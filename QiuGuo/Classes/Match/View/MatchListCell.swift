//
//  MatchListCell.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/7.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit



/// 赛程列表cell
class MatchListCell: BaseCollectionViewCell {
    
    //MARK:- 赛程列表模型
    var matchListModel:MatchListModel?{
        didSet{
            
            roundNameLabel.text = matchListModel?.RoundName
            
            teamNameLabel.text = matchListModel?.TeamName
            teamLogoImageView.kf_setImage(imageUrlStr: matchListModel?.TeamLogo)
            
            beTeamNameLabel.text = matchListModel?.BeTeamName
            beTeamLogoImageView.kf_setImage(imageUrlStr: matchListModel?.BeTeamLogo)
            
         
            if matchListModel?.status == "0"{
             settingWillStartMatchUI()            
            }else if matchListModel?.status == "1"{
            settingBeingMatchUI()
            }else{
            settingDidEndMatchUI()
            }
        }
    }
    
    //MARK:- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    //MARK:- 设置界面
    private func setupUI(){
        matchStatusButton.titleEdgeInsets.bottom += 5
        matchStatusButton.imageEdgeInsets.bottom += 5
        
        contentView.addSubview(roundNameLabel)
        contentView.addSubview(teamNameLabel)
        contentView.addSubview(teamLogoImageView)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(colonLable)
        contentView.addSubview(beScoreLabel)
        contentView.addSubview(pkImageView)
        contentView.addSubview(beTeamLogoImageView)
        contentView.addSubview(beTeamNameLabel)
        contentView.addSubview(matchStatusButton)
        contentView.addSubview(undline)
        
        //中间
        roundNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(30*heightScale)
            make.centerX.equalTo(roundNameLabel.superview!)
        }
        
        undline.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(undline.superview!)
            make.height.equalTo(1 * heightScale)
        }
        
        
        colonLable.snp.makeConstraints { (make) in
            make.centerX.equalTo(colonLable.superview!)
            make.top.equalTo(roundNameLabel.snp.bottom).offset(47*heightScale)
        }
        
        scoreLabel.snp.makeConstraints { (make) in
            make.right.equalTo(colonLable.snp.left).offset(-25*widthScale)
            make.top.equalTo(roundNameLabel.snp.bottom).offset(47*heightScale)
        }
        
        pkImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(pkImageView.superview!)
            make.top.equalTo(roundNameLabel.snp.bottom).offset(18*heightScale)
            make.width.height.equalTo(90*widthScale)
            
        }
        
        matchStatusButton.snp.makeConstraints { (make) in
           make.bottom.equalTo(undline.snp.top).offset(-8*heightScale)
            make.centerX.equalTo(matchStatusButton.superview!)
        }
        
        //主队
        teamLogoImageView.snp.makeConstraints { (make) in
            make.right.equalTo(scoreLabel.snp.left).offset(-40*widthScale)
            make.top.equalTo(roundNameLabel.snp.bottom).offset(20*heightScale)
            make.width.height.equalTo(100*widthScale)
        }
        
        teamNameLabel.snp.makeConstraints { (make) in
            make.right.equalTo(teamLogoImageView.snp.left).offset(-10*widthScale)
            make.centerY.equalTo(teamLogoImageView)
        }
        
        
        
        //客队
        beScoreLabel.snp.makeConstraints { (make) in
            make.left.equalTo(colonLable.snp.right).offset(25*widthScale)
            make.top.equalTo(scoreLabel)
        }
        
        beTeamLogoImageView.snp.makeConstraints { (make) in
            make.left.equalTo(beScoreLabel.snp.right).offset(40*widthScale)
            make.top.width.height.equalTo(teamLogoImageView)
            
        }
        
        beTeamNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(beTeamLogoImageView.snp.right).offset(10*widthScale)
            make.centerY.equalTo(beTeamLogoImageView)
        }

    }
    
    
    //MARK:- 设置已结束界面
    private func settingDidEndMatchUI(){
        
        pkImageView.isHidden = true
        scoreLabel.isHidden = false
        beScoreLabel.isHidden = false
        colonLable.isHidden = false
      
        matchStatusButton.setBackgroundImage(UIImage(named:"l_time_bg_grey"), for: .normal)
        matchStatusButton.setTitle("已结束", for: .normal)
        matchStatusButton.setImage(nil, for: .normal)
        
        scoreLabel.text = matchListModel?.Score.description
        beScoreLabel.text = matchListModel?.BeScore.description
    }
    //MARK:- 设置即将开始界面
    private func settingWillStartMatchUI(){
        pkImageView.isHidden = false
        scoreLabel.isHidden = true
        beScoreLabel.isHidden = true
        colonLable.isHidden = true
        
        matchStatusButton.setBackgroundImage(UIImage(named:"l_time_bg_blue"), for: .normal)
        matchStatusButton.setImage(UIImage.getImage("icon_clock"), for: .normal)
        
        var time = " ----"
        if let dateStr = matchListModel?.StartTime{

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
        scoreLabel.isHidden = false
        beScoreLabel.isHidden = false
        colonLable.isHidden = false
        
        matchStatusButton.setBackgroundImage(UIImage(named:"l_time_bg_green"), for: .normal)
        matchStatusButton.setTitle("进行中", for: .normal)
        matchStatusButton.setImage(nil, for: .normal)
        scoreLabel.text = matchListModel?.Score.description
        beScoreLabel.text = matchListModel?.BeScore.description

    
    
    }
    
    
    
    //MARK:- 宽布局比例
    private let widthScale = LayoutWidthScale
    //MARK:- 高布局比例
    private let heightScale = LayoutHeightScale * (260*LayoutHeightScale + 20) / (260*LayoutHeightScale)
    
    
    //MARK:- 名称
    private lazy var roundNameLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 30), textColor: UIColor.init(hexString: "#999999"))
    //MARK:- 主队名称
    private lazy var teamNameLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 36), textColor: UIColor.init(hexString: "#464646"),textAlignment:.right)
    //MARK:- 主队Logo
    private lazy var teamLogoImageView:UIImageView = UIImageView()
    //MARK:- 主队得分
    private lazy var scoreLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 45), textColor: UIColor.init(hexString: "#464646"))
    //MARK:- 得分冒号
    private lazy var colonLable:UILabel = UILabel(text: ":", font: UIFont.font(psFontSize: 45), textColor: UIColor.init(hexString: "#464646"))
    //MARK:- 客队得分
    private lazy var beScoreLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 45), textColor: UIColor.init(hexString: "#464646"))
    //MARK:- 客队Logo
    private lazy var beTeamLogoImageView:UIImageView = UIImageView()
    //MARK:- 客队名称
    private lazy var beTeamNameLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 36), textColor: UIColor.init(hexString: "#464646"))
    //MARK:- 比赛状态按钮
    private lazy var matchStatusButton:UIButton = UIButton(title: "", font: UIFont.font(psFontSize: 32), titleColor: UIColor.white)
    //MARK:- 未开始pk图标
    private lazy var pkImageView:UIImageView = UIImageView(image: UIImage.getImage("compared"))
    //MARK:- 分割线
    private lazy var undline:UILabel = UILabel.unline(hexString: "#b3b3b3")
    
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}







