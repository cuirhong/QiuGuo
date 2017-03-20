//
//  SingleGuessInfoView.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/15.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import WebKit
//代理
@objc

protocol SingleGuessInfoViewDelegate : NSObjectProtocol {

    @objc optional func singleGuessInfoView(_ singleGuessInfoView:SingleGuessInfoView?,supportBtn:UIButton)
   
}


enum SupportTeamType:Int {
    case None;//无
    case SupportTeam;//主胜
    case SupportBeTeam;//客胜
    case SupportDeuce;//平局
}


private let GuessInfoDefaultFontColor = UIColor.init(hexString: "#7f7f7f")

class SingleGuessInfoView: BaseView {
    
    //MARK:- 代理
    weak var delegate:SingleGuessInfoViewDelegate?
    
    //MARK:- 比赛模型
    var matchGuessModel:MatchGuessModel?{
    
        didSet{
        
            if (matchGuessModel?.Matchs.count)! > 0{
                let match = matchGuessModel?.Matchs[0]
                teamNameLabel.text = match?.TeamName
                beTeamNameLabel.text = match?.BeTeamName
                
                teamLogoImageView.kf_setImage(imageUrlStr: match?.TeamLogo)
                beTeamLogoImageView.kf_setImage(imageUrlStr: match?.BeTeamLogo)
                
                let teamScale = getSupportScale(totalPeople: (match?.People)!, supportPeople: (match?.Win)!)
                supportTeamView.progressBar.progress = Float(teamScale)
                
                 let deuceScale = getSupportScale(totalPeople: (match?.People)!, supportPeople: (match?.Draw)!)
                supportDeuceView.progressBar.progress = Float(deuceScale)
                
                 let beTeamScale = getSupportScale(totalPeople: (match?.People)!, supportPeople: (match?.Loss)!)
                supportBeTeamView.progressBar.progress = Float(beTeamScale)
                supportTeamView.supportLabel.text = getSupportText(scale: teamScale)
                supportDeuceView.supportLabel.text = getSupportText(scale: deuceScale)
                supportBeTeamView.supportLabel.text = getSupportText(scale: beTeamScale)
                
                if (matchGuessModel?.Status)! >= 2{
                
                   supportTeamView.progressBar.progressTintColor = THEMECOLOR
                    supportDeuceView.progressBar.progressTintColor = THEMECOLOR
                    supportBeTeamView.progressBar.progressTintColor = THEMECOLOR
                    
                    switch Int((match?.Results)!) {
                    case 0:
                         break
                    case 3:
                        supportTeamView.winImageView.isHidden = false
                    case 4:
                        supportDeuceView.winImageView.isHidden = false
                    case 5:
                        supportBeTeamView.winImageView.isHidden = false
                    default:
                        break
                    }
                    
                    
                }else{
                   let color = UIColor.init(hexString: "bdbdbd")
                    supportTeamView.progressBar.progressTintColor = color
                    supportDeuceView.progressBar.progressTintColor = color
                    supportBeTeamView.progressBar.progressTintColor = color
                }
            }

        }
    
    
    }
    
    //MARK:- 获取支持的比例
    private func getSupportScale(totalPeople:Int,supportPeople:Int)->CGFloat{
        var scale:CGFloat = 0
        if totalPeople > 0{
            scale = CGFloat(supportPeople)/CGFloat(totalPeople)
        }

        return scale
    }
    
    //MARK:- 获取支持的文本
    private func getSupportText(scale:CGFloat)->String{
        var string = "0%人支持"
       
       string = String(format: "%d%%%@", Int(scale*100),"人支持")
 
       return string
    }
    
    
    
    //MARK:-  初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        initData()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- 初始化数据
    private func initData(){
        supportTeamView.supportBtn.setTitle("主胜", for: .normal)
        supportTeamView.supportBtn.tag = SupportTeamType.SupportTeam.rawValue
        
        supportDeuceView.supportBtn.setTitle("平局", for: .normal)
        supportDeuceView.supportBtn.tag = SupportTeamType.SupportDeuce.rawValue
        
        supportBeTeamView.supportBtn.setTitle("客胜", for: .normal)
        supportBeTeamView.supportBtn.tag = SupportTeamType.SupportBeTeam.rawValue
        
        supportTeamView.supportBtn.addTarget(self, action: #selector(chooseSupportTeam(sender:)), for: .touchUpInside)
        
         supportDeuceView.supportBtn.addTarget(self, action: #selector(chooseSupportTeam(sender:)), for: .touchUpInside)
        
         supportBeTeamView.supportBtn.addTarget(self, action: #selector(chooseSupportTeam(sender:)), for: .touchUpInside)

    }
 
    
    //MARK:- 布局
    private func setupUI(){
        
        
        addSubview(teamLogoImageView)
        teamLogoImageView.snp.remakeConstraints { (make) in
            make.top.equalTo(teamLogoImageView.superview!).offset(40*LayoutHeightScale)
           make.left.equalTo(200*LayoutWidthScale)
            make.width.height.equalTo(150*LayoutWidthScale)
        }
        
        addSubview(teamNameLabel)
        teamNameLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(teamLogoImageView.snp.bottom).offset(12*LayoutHeightScale)
            make.centerX.equalTo(teamLogoImageView)
        }
        
        
        addSubview(pkImageView)
        pkImageView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(pkImageView.superview!)
            make.centerY.equalTo(teamLogoImageView)
        }
        
        addSubview(beTeamLogoImageView)
        beTeamLogoImageView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(pkImageView)
            make.left.equalTo(pkImageView.snp.right).offset(146*LayoutWidthScale)
            make.width.height.equalTo(teamLogoImageView)
        }
        
        addSubview(beTeamNameLabel)
        beTeamNameLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(beTeamLogoImageView.snp.bottom).offset(12*LayoutHeightScale)
            make.centerX.equalTo(beTeamLogoImageView)
        }
        
        addSubview(supportDeuceView)
        supportDeuceView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(pkImageView)
            make.top.equalTo(teamNameLabel.snp.bottom).offset(48*LayoutHeightScale)
            make.height.equalTo(130*LayoutHeightScale)
            make.width.equalTo(290*LayoutWidthScale)
        }
        
        addSubview(supportTeamView)
        supportTeamView.snp.remakeConstraints { (make) in
            make.top.equalTo(teamNameLabel.snp.bottom).offset(48*LayoutHeightScale)
           make.right.equalTo(supportDeuceView.snp.left).offset(-51*LayoutWidthScale)
            make.height.equalTo(130*LayoutHeightScale)
            make.width.equalTo(290*LayoutWidthScale)
        }
        
        addSubview(supportBeTeamView)
        supportBeTeamView.snp.remakeConstraints { (make) in
            make.top.equalTo(supportDeuceView)
            make.left.equalTo(supportDeuceView.snp.right).offset(51*LayoutWidthScale)
            make.height.equalTo(130*LayoutHeightScale)
            make.width.equalTo(290*LayoutWidthScale)
        }
        
        
    
    }
    
    //MARK:- 选择支持
     func chooseSupportTeam(sender:UIButton){
//        let image = UIImage.getImage("choosed_none_support_team.png")
//        supportTeamView.supportBtn.setBackgroundImage(image, for: .normal)
//        supportDeuceView.supportBtn.setBackgroundImage(image, for: .normal)
//        supportBeTeamView.supportBtn.setBackgroundImage(image, for: .normal)
//        sender.setBackgroundImage(UIImage.getImage("choosed_support_team.png"), for: .normal)
//        
//        
        supportTeamView.supportBtn.isSelected = false
        supportDeuceView.supportBtn.isSelected = false
        supportBeTeamView.supportBtn.isSelected = false
        sender.isSelected = true 
        
       delegate?.singleGuessInfoView!(self, supportBtn: sender)
        
        printData(message:  #function)
        
        
    }
    
    //MARK:- 主队logo
    private lazy var teamLogoImageView:UIImageView = UIImageView()
    
    //MARK:- 主队队名
    private lazy var teamNameLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 38), textColor: UIColor.init(hexString: "#333333"))
    
    //MARK:- pk图片
    private lazy var pkImageView:UIImageView = UIImageView(image: UIImage.getImage("match_detail_guess_pk.png"))

    //MARK:- 客队logo
    private lazy var beTeamLogoImageView:UIImageView = UIImageView()
    
    //MARK:- 客队队名
    private lazy var beTeamNameLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 38), textColor: UIColor.init(hexString: "#333333"))
    
    //MARK:-  支持主胜
    private lazy var supportTeamView:GuessSupportTeamView = GuessSupportTeamView()
    
    //MARK:- 平局
    private lazy var supportDeuceView:GuessSupportTeamView = GuessSupportTeamView()
    
    //MARK:- 支持客队
    private lazy var supportBeTeamView:GuessSupportTeamView = GuessSupportTeamView()
    
    
    //MARK:- 比赛支持信息view
     class GuessSupportTeamView: BaseView {
        //MARK:- 初始化
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
            
        }
        
        //MARK:- 设置界面
        private func setupUI(){
            addSubview(supportBtn)
            supportBtn.snp.remakeConstraints { (make) in
                make.left.top.right.bottom.equalTo(supportBtn.superview!)
               
            }
            
            addSubview(progressBar)
            progressBar.snp.remakeConstraints { (make) in
                make.left.right.equalTo(supportBtn)
                make.top.equalTo(supportBtn.snp.bottom).offset(18*LayoutHeightScale)
                make.height.equalTo(14*LayoutHeightScale)
            }
        
            addSubview(supportLabel)
            supportLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(progressBar)
                make.top.equalTo(progressBar.snp.bottom).offset(18*LayoutHeightScale)
            }
            
            addSubview(winImageView)
            winImageView.snp.makeConstraints { (make) in
                make.top.right.equalTo(supportBtn)
            }
            winImageView.isHidden = true
        
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK:- 支持按钮
        fileprivate lazy var supportBtn:UIButton = UIButton (title: "主胜",backImageName: "choosed_none_support_team.png", selBackImageName: "choosed_support_team.png", font: UIFont.font(psFontSize: 45), titleColor: UIColor.init(hexString: "#7f7f7f"), selTitleColor: UIColor.init(hexString: "#ffffff"))

        
        //MARK:- progress
        fileprivate lazy var progressBar:UIProgressView = {
            let progressView = UIProgressView()
            progressView.trackTintColor = UIColor.init(hexString: "#d7d7d7")
            progressView.progressTintColor = UIColor.init(hexString: "#bdbdbd")
            return progressView
        }()
        
        //MARK:- 赢的图片
        fileprivate lazy var winImageView:UIImageView = UIImageView(image: UIImage.getImage("win.png"))
        
        //MARK:- 支持label
        fileprivate lazy var supportLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 34), textColor: UIColor.init(hexString: "#bdbdbd"))
        

    }
    
}












////////////////// 比赛竞猜截止日期
class GuessExpirationDateView: BaseView {
    
    //MARK:- 开始日期
    var startDate:String!{
        didSet{
        
            if  let date1 = String.getDateFromString(dateStr: startDate){
            
              let com = Date.dateInterval(date1: Date(), date2:date1)
                if let day = com.day {
                
                 dayLabel.text = String(format: "%02d", day)
                }
               
                if let hour = com.hour {
                 hourLabel.text = String(format: "%02d", hour)
                }
               
                if let minute = com.minute{
                  minuteLabel.text = String(format: "%02d", minute)
                }
              
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
        
        let hourUnitLabel = createDateUnitLabel(text:"时")
        
        addSubview(hourUnitLabel)
        hourUnitLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(hourUnitLabel.superview!.snp.centerX)
            make.centerY.equalTo(hourUnitLabel.superview!)
        }
        
        addSubview(hourLabel)
        hourLabel.snp.remakeConstraints { (make) in
           make.right.equalTo(hourUnitLabel.snp.left).offset(-20*LayoutWidthScale)
           make.bottom.equalTo(hourUnitLabel)
        }
        
        addSubview(minuteLabel)
        minuteLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(hourUnitLabel.snp.right).offset(40*LayoutWidthScale)
            make.bottom.equalTo(hourLabel)
        }
        
        let dayUnitLabel = createDateUnitLabel(text:"天")
        addSubview(dayUnitLabel)
        dayUnitLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(hourLabel.snp.left).offset(-40*LayoutWidthScale)
            make.bottom.equalTo(hourUnitLabel)
        }
        
        addSubview(dayLabel)
        dayLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(dayUnitLabel.snp.left).offset(-14*LayoutWidthScale)
            make.bottom.equalTo(hourUnitLabel)
        }
        
        let minuteUnitLabel = createDateUnitLabel(text:"分")
        addSubview(minuteUnitLabel)
        minuteUnitLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(minuteLabel.snp.right).offset(14*LayoutWidthScale)
            make.bottom.equalTo(hourUnitLabel)
        }
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK:- 天
    private lazy var dayLabel:UILabel = UILabel.init(text: "--", font: UIFont.font(psFontSize: 80), textColor: UIColor.init(hexString: "#7f7f7f"))
    //MARK:- 小时
     private lazy var hourLabel:UILabel = UILabel.init(text: "--", font: UIFont.font(psFontSize: 80), textColor: UIColor.init(hexString: "#7f7f7f"))
    //MARK:- 分钟
     private lazy var minuteLabel:UILabel = UILabel.init(text: "--", font: UIFont.font(psFontSize: 80), textColor: UIColor.init(hexString: "#7f7f7f"))
    
    
    //MARK:- 单位标签
    private func createDateUnitLabel(text:String)->UILabel{
        let label = UILabel.init(text: text, font: UIFont.font(psFontSize: 45), textColor: UIColor.init(hexString: "#7f7f7f"))
        return label
    }
   
}


/////////////////////// 总奖池
class TotalJackpotView: BaseView {
    
    //MARK:- 总投注额
    var totalCoats:Int!{
    
        didSet{
            let totalCoatsText = "\(totalCoats.description)"
            totalScoreLabel.text = "目前奖池:" +  totalCoatsText + "积分"
            totalScoreLabel.setDiffirentText(needText: totalCoatsText, fontSize: 70, fontColor: nil)
        }
    
    }
    
    //MARK:- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    //MARK:- 初始化失败
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-  布局 
    private  func  setupUI(){
        addSubview(jackpotImageView)
        jackpotImageView.snp.remakeConstraints { (make) in
            make.top.equalTo(30*LayoutHeightScale)
            make.centerX.equalTo(jackpotImageView.superview!)
            make.width.height.equalTo(130*LayoutHeightScale)
        }
    
        addSubview(totalScoreLabel)
        totalScoreLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(jackpotImageView.snp.bottom).offset(18*LayoutHeightScale)
            make.centerX.equalTo(totalScoreLabel.superview!)
        }
        
        addSubview(guessRulesLabel)
        guessRulesLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(totalScoreLabel.snp.bottom).offset(28*LayoutHeightScale)
            make.centerX.equalTo(guessRulesLabel.superview!)
           
        }
       
    
    }
    
    
    //MARK:- 奖池图片
    private lazy var jackpotImageView:UIImageView = UIImageView.init(image: UIImage.getImage("prize_pool_trophy.png"))
    
    //MARK:- 目前奖池总积分
    private lazy var totalScoreLabel:UILabel = UILabel.init(text: "", font: UIFont.font(psFontSize: 50), textColor: GuessInfoDefaultFontColor)
    
    //MARK:- 竞猜规则
    private lazy var guessRulesLabel:UILabel = UILabel.init(text: "猜对3场以上的球友平分该奖池", font: UIFont.font(psFontSize: 38), textColor: GuessInfoDefaultFontColor)
}



///////////////////////// 参与者
class GuessParticipatorView: BaseView,UICollectionViewDelegate,UICollectionViewDataSource {
    //MARK:- cellIdentifier
    static let cellIdentifier = "guessParticipatorColleciontViewCell"
    
    
    //MARK:- 比赛竞猜模型
    var matchGuessModel:MatchGuessModel?{
        didSet{
            collectionView.reloadData()
            participatorCountLabel.text = (matchGuessModel?.People.description)! + "/" + (matchGuessModel?.MaxPeople.description)!
        }
    }
    

    
    //MARK:- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    //MARK:- 布局 
    private func setupUI(){
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(82*LayoutHeightScale)
            make.left.equalTo(126*LayoutWidthScale)
            make.right.equalTo(-126*LayoutWidthScale)
            make.height.equalTo(90*LayoutHeightScale)
  
            
        }
        
        addSubview(participatorCountLabel)
        participatorCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom).offset(45*LayoutHeightScale)
            make.centerX.equalTo(participatorCountLabel.superview!)
        }
        
    
    
    }
    
    //MARK:- 初始化失败
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-  参数者总数label
    private lazy var participatorCountLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 45), textColor: GuessInfoDefaultFontColor)
    
    
    //MARK:-  创建collectionView
    private lazy var collectionView:UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 18*LayoutWidthScale
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 88*LayoutHeightScale, height: 88*LayoutHeightScale)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:cellIdentifier)

        return collectionView
        
        }()
    
    //MARK:- collectionView数据源代理方法
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchGuessModel?.UserMatchs.count ?? 0
    }
    
    //MARK:- cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuessParticipatorView.cellIdentifier, for: indexPath)
        let headImageViewTag = 101010
        var headImageView:UIImageView? = cell.viewWithTag(headImageViewTag) as? UIImageView
        if headImageView == nil{
            let imageView = UIImageView()
            cell.contentView.addSubview(imageView)
            imageView.snp.remakeConstraints({ (make) in
                make.top.left.equalTo(imageView.superview!)
                make.width.height.equalTo(88*LayoutHeightScale)
            })
            imageView.layer.cornerRadius = 88*LayoutHeightScale/2
            imageView.clipsToBounds = true
            headImageView = imageView
        }
        let userMatch = matchGuessModel?.UserMatchs[indexPath.row]
        headImageView?.kf_setImage(imageUrlStr: userMatch?.UserHeadimgurl)
        return cell
    }
}


/////////////////////// 竞猜规则
class GuessRulesView: BaseView{
    //MARK:- 竞猜规则html字符串
    var htmlString:String!{
        didSet{
          webView.loadHTMLString(htmlString, baseURL: nil)
        
        }
    
    }
    
    
    //MARK:- 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:- 布局
    private func setupUI(){
    
        addSubview(webView)
        webView.snp.remakeConstraints { (make) in
            make.left.right.bottom.top.equalTo(webView.superview!)
        }
    
    }
    
    
    
    
    //MARK:- 玩法规则webView
    private lazy var webView:WKWebView = WKWebView()
    
    
    
}

















