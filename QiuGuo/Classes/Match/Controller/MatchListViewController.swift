//
//  MatchListViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/7.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit


private let matchListCell = "matchListCollectionCell"
private let matchListSectionView = "matchListCollectionSectionView"

class MatchListViewController: BaseViewController {
    //MARK:- 赛事栏目ID
    var leagueID:Int = 0
    
    //MARK:- 比赛列表viewModel
    fileprivate  var matchListViewModel = MatchListViewModel()

    //MARK:- 加载
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    
    //MARK:- 初始化数据
    override func initData() {
        super.initData()
        matchListViewModel.LeagueID = leagueID        
    }

    
    //MARK:- 网络请求数据
    override func loadData() {
        super.loadData()
        matchListViewModel.loadMatchList(successCallBack: {[weak self] (result) in
            DispatchQueue.main.async {
                 self?.setupUI()
                self?.endRefreshing()

            }
        }) { (error) in
            HUDTool.show(showType:.Failure,text: error.debugDescription)
        }
   
    }
    
    //MARK:- 下拉刷新
    override func downLoadRefresh() {
        super.downLoadRefresh()
        matchListViewModel.refreshType = .PullDownRefresh
        matchListViewModel.page = 1
        matchListViewModel.type = "end"
        DispatchQueue.global().async {[weak self] in
            self?.loadData()
        }
    }
    
    //MARK:- 上拉加载
    override func upLoadRefresh() {
        super.upLoadRefresh()
        if matchListViewModel.refreshType == .PullDownRefresh || matchListViewModel.isEnd == "1"{
            matchListViewModel.refreshType = .UpDownRefresh
            matchListViewModel.page += 1
            matchListViewModel.type = "head"
            DispatchQueue.global().async {[weak self] in
                self?.loadData()
                
            }
        }else{            
            collectionView.endFooterRefreshingWithNoMoreData()
        }
    }

    
    
    //MARK:- 设置界面
    func setupUI() {

        if collectionView.superview == nil {
            collectionView.register(MatchListCell.self, forCellWithReuseIdentifier: matchListCell)
            collectionView.register(MatchListSectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: matchListSectionView)
            view.addSubview(collectionView)
            addRefresh()
            collectionView.snp.remakeConstraints { (make) in
                make.top.left.right.bottom.equalTo(collectionView.superview!)
            }
        }else{
             refreshUI()
        }
    }


    //MARK:- 刷新界面
    override func refreshUI() {
        super.refreshUI()
        collectionView.reloadData()
    }
}


// MARK: - 遵守UICollectionViewDataSource代理
extension MatchListViewController:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return matchListViewModel.matchListArr.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         let array = matchListViewModel.matchListArr[section]
        return array.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MatchListCell = collectionView.dequeueReusableCell(withReuseIdentifier: matchListCell, for: indexPath) as! MatchListCell
        let modelArray = matchListViewModel.matchListArr[indexPath.section]
        cell.matchListModel = modelArray[indexPath.item]
        return cell
        
    }
    
    
    //分组头部、尾部
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionElementKindSectionHeader:
            let header:MatchListSectionView=collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: matchListSectionView, for: indexPath) as! MatchListSectionView
            let model = matchListViewModel.matchListArr[indexPath.section][indexPath.item]
            header.matchListModel = model
            
            return header
        default:
            return MatchListSectionView()
        }
      
    }

}

// MARK: - 遵守UICollectionViewDelegate
extension MatchListViewController:UICollectionViewDelegate{
    //MARK:- 点击cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { 
        DispatchQueue.main.async {
            let detailController = MatchDetailViewController()
            detailController.matchModel = self.matchListViewModel.matchListArr[indexPath.section][indexPath.item]
           self.navigationController?.pushViewController(detailController, animated: false)
        }
        
    }





}











// MARK: - 遵守UICollectionViewFlowLayout代理
extension MatchListViewController:UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: ScreenWidth, height: 260*LayoutHeightScale+20)
    }
    
    //返回分组的头部视图的尺寸，在这里控制分组头部视图的高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: ScreenWidth, height: 80*LayoutHeightScale)
    }

}






































