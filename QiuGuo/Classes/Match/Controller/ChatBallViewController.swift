//
//  ChatBallViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/14.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

private let chatBallDefaultFontColor = UIColor.init(hexString: "#ffffff")

/// 比赛详情页（聊个球页面）
class ChatBallViewController: BaseViewController{
    
    //MARK:- 比赛模型
    var matchModel:MatchListModel!{
        didSet{
           teamNameLabel.text = matchModel.TeamName
            beTeamNameLabel.text  = matchModel.BeTeamName
            
            teamLogoImageView.kf_setImage(imageUrlStr: matchModel.TeamLogo)
            
         beTeamLogoImageView.kf_setImage(imageUrlStr: matchModel.BeTeamLogo)
        
        
        
        }
    
    }
    
    //MARK:- 加载视图
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK:- 设置界面
    override func setupView() {
        super.setupView()
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalTo(bgImageView.superview!)
        }
        
        
        view.addSubview(hintSupportBtn)
        hintSupportBtn.snp.makeConstraints { (make) in
            make.top.equalTo(200*LayoutHeightScale)
            make.left.equalTo(60*LayoutWidthScale)
            make.right.equalTo(-60*LayoutWidthScale)
            make.height.equalTo(86*LayoutHeightScale)
        }
        
        view.addSubview(teamBgImageView)
        teamBgImageView.snp.makeConstraints { (make) in
            make.top.equalTo(hintSupportBtn.snp.bottom).offset(26*LayoutHeightScale)
            make.left.equalTo(hintSupportBtn)
            make.right.equalTo(hintSupportBtn.snp.centerX)
            make.height.equalTo(643*LayoutHeightScale)
        }
        
        view.addSubview(beTeamBgImageView)
        beTeamBgImageView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(teamBgImageView)
            make.right.equalTo(hintSupportBtn)
            make.left.equalTo(teamBgImageView.snp.right)
        }
        
        view.addSubview(supportTeamBtn)
        supportTeamBtn.snp.makeConstraints { (make) in
            make.top.equalTo(teamBgImageView.snp.bottom)
            make.left.right.equalTo(teamBgImageView)
            make.height.equalTo(151*LayoutHeightScale)
        }
        
        view.addSubview(supportBeTeamBtn)
        supportBeTeamBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(supportTeamBtn)
            make.left.right.equalTo(beTeamBgImageView)
        }
        
        
        teamBgImageView.addSubview(teamLogoImageView)
        teamLogoImageView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(teamLogoImageView.superview!)
            make.width.height.equalTo(160*LayoutWidthScale)
        }
        
        beTeamBgImageView.addSubview(beTeamLogoImageView)
        beTeamLogoImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(beTeamLogoImageView.superview!)
            make.centerY.equalTo(teamLogoImageView)
            make.width.height.equalTo(teamLogoImageView)
        }
        
        view.addSubview(vsImageView)
        vsImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(teamBgImageView.snp.right)
            make.centerY.equalTo(teamBgImageView)
            make.width.equalTo(178*LayoutWidthScale)
            make.height.equalTo(240*LayoutHeightScale)
        }
        
        
        let teamLabel = ChatBallViewController.createBaseTextLabel(text: "主队")
        teamBgImageView.addSubview(teamLabel)
        teamLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(teamLogoImageView.snp.top).offset(-55*LayoutHeightScale)
            make.centerX.equalTo(teamLogoImageView)
            
        }
        
        let beTeamLabel = ChatBallViewController.createBaseTextLabel(text: "客队")
        beTeamBgImageView.addSubview(beTeamLabel)
        beTeamLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(beTeamLogoImageView.snp.top).offset(-55*LayoutHeightScale)
            make.centerX.equalTo(beTeamLogoImageView)
        }
        
        
        teamBgImageView.addSubview(teamNameLabel)
        teamNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(teamNameLabel.superview!)
            make.top.equalTo(teamLogoImageView.snp.bottom).offset(55*LayoutHeightScale)
        }
        
        beTeamBgImageView.addSubview(beTeamNameLabel)
        beTeamNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(beTeamNameLabel.superview!)
            make.top.equalTo(beTeamLogoImageView.snp.bottom).offset(55*LayoutHeightScale)
        }
        
        
    }
    
    //MARK:- 支持主队
    @objc private func supportTeam(sender:UIButton){
    
    
    
    }
    
    //MARK:- 支持客队
    @objc private func supportBeTeam(sender:UIButton){
    
    
    }

    //MARK:- 背景图片 
    fileprivate lazy var bgImageView = UIImageView(image: UIImage.getImage("chat_ball_bg.png"))

    //MARK:- 提示支持的一方球队
    fileprivate lazy var hintSupportBtn:UIButton = UIButton(title: "请选择你支持的一方球队", backImageName: "hint_choose_support_team_bg.png", font: UIFont.font(psFontSize: 40), titleColor: chatBallDefaultFontColor)
    //MARK:- 主队背景图
    fileprivate lazy var teamBgImageView:UIImageView = UIImageView(image: UIImage.getImage("team_bg_l.png"))
    //MARK:- 客队背景图
    fileprivate lazy var beTeamBgImageView:UIImageView = UIImageView(image: UIImage.getImage("team_bg_r.png"))
    
    //MARK:- 支持主队按钮
    fileprivate lazy var supportTeamBtn:UIButton = UIButton(title: "支持主队", backImageName: "support_team_btn_bg.png",  target: self, selector: #selector(supportTeam(sender:)), font: UIFont.font(psFontSize: 40), titleColor: chatBallDefaultFontColor)
    
    //MARK:- 支持客队按钮
    fileprivate lazy var supportBeTeamBtn:UIButton = UIButton(title: "支持客队", backImageName: "support_be_team_btn_bg.png",  target: self, selector: #selector(supportBeTeam(sender:)), font: UIFont.font(psFontSize: 40), titleColor: chatBallDefaultFontColor)
    //MARK:- vs图片
    fileprivate lazy var vsImageView:UIImageView = UIImageView(image: UIImage.getImage("vs.png"))


    //MARK:- 主队名字
    fileprivate lazy var teamNameLabel:UILabel = ChatBallViewController.createBaseTextLabel(text:"")
    
    //MARK:- 客队名字
    fileprivate lazy var beTeamNameLabel:UILabel = ChatBallViewController.createBaseTextLabel(text:"")
    //MARK:- 主队logo
    fileprivate lazy var teamLogoImageView:UIImageView = UIImageView()
    
    //MARK:- 客队logo
    fileprivate lazy var beTeamLogoImageView:UIImageView = UIImageView()

    //MARK:- 创建基本的文本标签
    class func createBaseTextLabel(text:String)->UILabel{
        let label = UILabel(text: text, font: UIFont.font(psFontSize: 40), textColor: chatBallDefaultFontColor)
        return label
    }
    
    
    
    
    

}
