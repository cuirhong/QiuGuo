//
//  MatchListViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/7.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit


private let matchListCell = "matchListCollectionCell"
private let matchListHeaderView = "matchListCollectionHeaderView"

class MatchListViewController: BaseViewController {
    //MARK:- 赛事栏目ID
    var leagueID:Int = 0
    
    //MARK:- 比赛列表viewModel
    fileprivate lazy var matchListViewModel = MatchListViewModel()

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
            }
          
        }) { (error) in
            HUDTool.show(showType:.Failure,text: error.debugDescription)
         
        }
   
    }
    
    
    //MARK:- 设置界面
    func setupUI() {

        if collectionView.superview == nil {
            collectionView.register(MatchListCell.self, forCellWithReuseIdentifier: matchListCell)
            collectionView.register(MatchHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: matchListHeaderView)
            view.addSubview(collectionView)
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
            let header:MatchHeadView=collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: matchListHeaderView, for: indexPath) as! MatchHeadView
            let model = matchListViewModel.matchListArr[indexPath.section][indexPath.item]
            header.matchListModel = model
            
            return header
        default:
            return MatchHeadView()
        }
      
    }
   
//    //返回分组脚部视图的尺寸，在这里控制分组脚部视图的高度
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSizeMake(UIScreen.mainScreen().bounds.size.width, 40)
//    }




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






































