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
    
    
    //MARK:- 加载视图
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK:- 支持主队
    @objc private func supportTeam(sender:UIButton){
    
    
    
    }
    
    //MARK:- 支持客队
    private func supportBeTeam(sender:UIButton){
    
    
    }

    //MARK:- 背景图片 
    fileprivate lazy var bgImageView = UIImageView()

    //MARK:- 提示支持的一方球队
    fileprivate lazy var hintSupportBtn:UIButton = UIButton(title: "请选择你支持的一方球队", backImageName: "hint_choose_support_team_bg.png", font: UIFont.font(psFontSize: 40), titleColor: chatBallDefaultFontColor)
    //MARK:- 主队背景图
    fileprivate lazy var teamBgImageView:UIImageView = UIImageView(image: UIImage.getImage("team_bg_l.png"))
    //MARK:- 客队背景图
    fileprivate lazy var beTeamBgImageView:UIImageView = UIImageView(image: UIImage.getImage("team_bg_r.png"))
    
    //MARK:- 支持主队按钮
    fileprivate lazy var supportTeamBtn:UIButton = UIButton(title: "支持主队", backImageName: "support_team_btn_bg.png",  target: self, selector: #selector(supportTeam(sender:)), font: UIFont.font(psFontSize: 40), titleColor: chatBallDefaultFontColor)
    
    //MARK:- 支持客队按钮
    fileprivate lazy var supportBeTeamBtn:UIButton = UIButton(title: "支持客队", backImageName: "support_be_team_btn_bg.png",  target: self, selector: #selector(supportTeam(sender:)), font: UIFont.font(psFontSize: 40), titleColor: chatBallDefaultFontColor)
    //MARK:- vs图片
    fileprivate lazy var vsImageView:UIImageView = UIImageView(image: UIImage.getImage("vs.png"))

    
    
    
    
    
    
    
    
    
    

}
