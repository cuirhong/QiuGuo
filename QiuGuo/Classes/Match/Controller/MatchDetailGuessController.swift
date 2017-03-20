//
//  MatchDetailGuessController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/13.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import WebKit

private let normalCellIdentifier = "normalCollectionCell"

private let guessResultRankCellIdentifier = "guessResultRankCell"

private let matchDetailGuessSectionHeaderIdentifier = "matchDetailGuessCell"

/// 竞猜cell的类型
enum MatchDetailGuessCellType {
    case None;//无数据
    case MatchInfo;//赛程
    case GuessExpirationDate;//竞猜截止日期
    case TotalJackpot;//总奖池
    case GuessParticipator;//竞猜参与者
    case GuessRuseltRank;//竞猜结果排序
    case GuessRules;//竞猜规则
}

/// 球赛详情对战
class MatchDetailGuessController: BaseViewController {

    
    
    //MARK:- 加载数据viewModel
     lazy var matchGuessViewModel = MatchDetailGuessViewModel()
    //MARK:- 竞猜结果排名viewModel
     lazy var guessResultRankViewModel = GuessResultRankViewModel()
    //MARK:- 已经选择支持的队
    fileprivate lazy var didSupportTeam:SupportTeamType = .None
    
    //MARK:- 参加竞猜按钮 
    fileprivate lazy var joinGuessBtn:UIButton = UIButton(title: "参与竞猜",backgroundColor:UIColor.gray, target: self, selector: #selector(joinGuess), font: UIFont.font(psFontSize: 45), titleColor: UIColor.init(hexString: "#ffffff"))
    
    
    //MARK:- 加载view
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    //MARK:-  初始化数据
    override func initData() {
        super.initData()
        
    }
    
    //MARK:- 加载数据
    override func loadData() {
        super.loadData()
        matchGuessViewModel.dataAbnormalType = .noAbnormal
        matchGuessViewModel.loadDataMatchGuess(successCallBack: {[weak self] (result) in
            let isNormal = self?.checkDataIsNormal( hintTextArr: ["抱歉","本场比赛暂无竞猜"])
            if isNormal == true{
                if (self?.matchGuessViewModel.matchGuessModel?.Status)! >= 2{
                    self?.loadGuessResultRank()
                }else{
                    DispatchQueue.main.async {
                        self?.setupView()
                    }
                }
            }
        }) {[weak self] (error) in
            self?.loadDataFailure(error: error, abnormalType: self?.matchGuessViewModel.dataAbnormalType ?? .noNetwork)
        }
    }
    
    //MARK:- 加载竞猜结果排序列表
    private func loadGuessResultRank(){
        
        if let match = matchGuessViewModel.matchGuessModel?.Matchs.first{
          guessResultRankViewModel.quizId = match.QuizID
        }
      guessResultRankViewModel.dataAbnormalType = .noAbnormal   
      guessResultRankViewModel.loadGuessResultRankList(successCallBack: {[weak self] (result) in
        let isNormal = self?.checkDataIsNormal( hintTextArr: ["抱歉","本场比赛暂无竞猜"])
        if isNormal == true{
            DispatchQueue.main.async {
                self?.setupView()
            }
        }
       
      }) {[weak self](error) in
        
           self?.loadDataFailure(error: error, abnormalType: (self?.guessResultRankViewModel.dataAbnormalType)!)
        
        }
    }
    
    
    //MARK:- 布局 
    override func setupView() {
        super.setupView()
        if collectionView.superview == nil{
            //注册
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: normalCellIdentifier)
            collectionView.register(GuessResultRankCell.self, forCellWithReuseIdentifier: guessResultRankCellIdentifier)
            collectionView.register(MatchGuessSectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: matchDetailGuessSectionHeaderIdentifier)
            view.addSubview(collectionView)
            if (matchGuessViewModel.matchGuessModel?.Status)! >= 2{
                if (guessResultRankViewModel.guessResultUserArr?.count)! > 0{
                    addRefresh(downLoadRefresh: false, upLoadRefresh: true)
                }
                collectionView.snp.remakeConstraints { (make) in
                    make.top.left.right.bottom.equalTo(collectionView.superview!)
                }
            }else if matchGuessViewModel.matchGuessModel?.Status == 0{
               view.addSubview(joinGuessBtn)
                joinGuessBtn.isUserInteractionEnabled = false
                joinGuessBtn.snp.remakeConstraints({ (make) in
                    make.left.right.equalTo(joinGuessBtn.superview!)
                    make.bottom.equalTo(-0.5)
                    make.height.equalTo(140*LayoutHeightScale)
                })
                
                collectionView.snp.remakeConstraints { (make) in
                    make.top.left.right.equalTo(collectionView.superview!)
                    make.bottom.equalTo(joinGuessBtn.snp.top)
                }
            }
        }else{
            collectionView.reloadData()
            endRefreshing()
        }       
    }
    
    //MARK:- 获取竞猜cell的类型
    fileprivate func getGuessCellType(indexPath:IndexPath)->MatchDetailGuessCellType{
        switch indexPath.section {
        case 0:
             return .MatchInfo
        case 1:
            if (matchGuessViewModel.matchGuessModel?.Status)! < 2{
                 return .GuessExpirationDate
            }
        case 2:
            return .TotalJackpot
        case 3:
            if (matchGuessViewModel.matchGuessModel?.UserMatchs.count)! > 0{
                return .GuessParticipator
            }
        case 4:
            return .GuessRules
        case 5:
            if (guessResultRankViewModel.guessResultUserArr?.count)! > 0{
             return .GuessRuseltRank
            }
        default:
            break
        }
        return .None
    }
    
    //MARK:- 上拉加载
    override func upLoadRefresh() {
        super.upLoadRefresh()
        if guessResultRankViewModel.refreshType == .PullDownRefresh || guessResultRankViewModel.isEnd == "1"{
            guessResultRankViewModel.refreshType = .UpDownRefresh
            guessResultRankViewModel.page += 1
            DispatchQueue.global().async {[weak self] in
               self?.loadGuessResultRank()                
            }
        }else{
            collectionView.endFooterRefreshingWithNoMoreData()
        }
    }
    
    //MARK:- 下拉刷新
    override func downLoadRefresh() {
        super.downLoadRefresh()
        endRefreshing()
    }
    
    //MARK:- 参与竞猜
    @objc private func joinGuess(sender:UIButton){
         printData(message:  #function)
        if UserInfo.userLogin(){//出发登录操作
           let betView = BetView()
            view.addSubview(betView)
            betView.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(joinGuessBtn)
               make.top.equalTo(betView.superview!)
            })
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension MatchDetailGuessController:UICollectionViewDataSource{
    //MARK:- 多少个分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    //MARK:- 一个分区多少行
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (matchGuessViewModel.matchGuessModel?.Status)! > 2,section == 5{
            return guessResultRankViewModel.guessResultUserArr?.count ?? 0
        }
        return 1
    }
    //MARK:- cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (matchGuessViewModel.matchGuessModel?.Status)! > 2,indexPath.section == 5{
            let cell:GuessResultRankCell = collectionView.dequeueReusableCell(withReuseIdentifier: guessResultRankCellIdentifier, for: indexPath) as! GuessResultRankCell
            cell.guessResultUser = guessResultRankViewModel.guessResultUserArr?[indexPath.row]
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: normalCellIdentifier, for: indexPath)
            for view in cell.contentView.subviews {
                view.removeFromSuperview()
            }
            if getGuessCellType(indexPath: indexPath) != .None{
                var view:UIView = UIView()
                switch indexPath.section {
                case 0:
                   let infoView = SingleGuessInfoView()
                   infoView.delegate = self
                    infoView.matchGuessModel = matchGuessViewModel.matchGuessModel
                    view = infoView
                case 1:
                    let expirationDateView = GuessExpirationDateView()
                    expirationDateView.startDate = matchGuessViewModel.matchGuessModel?.StartTime
                    view = expirationDateView
                case 2:
                    let jackpotView = TotalJackpotView()
                    jackpotView.totalCoats = matchGuessViewModel.matchGuessModel?.TotalCosts
                    view = jackpotView
                case 3:
                    let participatorView = GuessParticipatorView()
                    participatorView.matchGuessModel = matchGuessViewModel.matchGuessModel
                    view = participatorView
                case 4:
                    let guessRulesView = GuessRulesView()
                    if let CustomRules = matchGuessViewModel.matchGuessModel?.CustomRules {
                        if CustomRules != ""{
                           guessRulesView.htmlString = CustomRules
                        }
                    }
                    view = guessRulesView
                default:
                    break
                }
                cell.contentView.addSubview(view)
                view.snp.remakeConstraints({ (make) in
                    make.left.right.bottom.top.equalTo(view.superview!)
                })
            }
           
            return cell
        }
    }
    
   
    //MARK:- 分区头
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionElementKindSectionHeader:
            let header:MatchGuessSectionView=collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: matchDetailGuessSectionHeaderIdentifier, for: indexPath) as! MatchGuessSectionView
            var titleText = ""
            switch indexPath.section {
            case 0:
                titleText = "90 分钟内胜平负"
                if (matchGuessViewModel.matchGuessModel?.Status)! >= 2{
                     titleText = "比赛已经结束"
                }
                header.title = titleText
            case 1:
               
                header.title = "距离竞猜截止"
            case 2:
               
                header.title = "积分池"
            case 3:
                header.title = "参与者"
            case 4:
                header.title = "玩法规则"
            case 5:
                header.title = "本场竞猜排名"
            default:
                break
            }

            return header
        default:
            return UICollectionReusableView()
        }
        
    }
    
}


// MARK: - UICollectionViewDelegate
extension MatchDetailGuessController:UICollectionViewDelegate{

    


}

// MARK: - UICollectionViewDelegateFlowLayout
extension MatchDetailGuessController:UICollectionViewDelegateFlowLayout{
    //MARK:-  cell的高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellType = getGuessCellType(indexPath: indexPath)
        var height:CGFloat = 0
        switch cellType {
        case .MatchInfo:
            height =  566*LayoutHeightScale
        case .GuessExpirationDate:
            height = 222*LayoutHeightScale
        case .TotalJackpot:
            height = 400*LayoutHeightScale
        case .GuessParticipator:
            height = 312*LayoutHeightScale
        case .GuessRules:
            height = 502*LayoutHeightScale
        case .GuessRuseltRank:
            height = 163*LayoutHeightScale
        default:
            height = 0.5
        }
        return CGSize(width: ScreenWidth, height: height)
    }
    //MARK:- 分区头的高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let cellType = getGuessCellType(indexPath: IndexPath.init(row: 0, section: section))
        var height:CGFloat = 0
        if cellType != .None{
            height = 96*LayoutHeightScale
        }
        return CGSize(width: ScreenWidth, height: height)
    }


}

// MARK: - 遵守SingleGuessInfoViewDelegate
extension MatchDetailGuessController:SingleGuessInfoViewDelegate{
    
    //MARK:- 选择支持的球队代理
    func singleGuessInfoView(_ singleGuessInfoView: SingleGuessInfoView?, supportBtn: UIButton) {
        joinGuessBtn.isUserInteractionEnabled = true
        joinGuessBtn.backgroundColor = THEMECOLOR
        didSupportTeam = SupportTeamType(rawValue: supportBtn.tag)!
    }




}


