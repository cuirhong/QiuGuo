//
//  SettingViewController.swift
//  QiuGuo
//
//  Created by apple on 17/3/5.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit
import SVProgressHUD


class SettingViewController: BaseViewController {
    
    var array:Array = ["账号与安全","消息推送设置","仅WIFI网络下下载图片","清理缓存","帮助与反馈","给球友app评分","关于我们","退出登录"]
    
    fileprivate lazy var logoutBtn:UIButton = UIButton(title:"退出登录", target: self, selector: #selector(logout), font: UIFont.font(psFontSize: 45), titleColor: DEFAUlTFONTCOLOR)
    
    fileprivate lazy var tableView:UITableView = {[weak self] in
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNaviBack(target: self)
        setupUI()    
    }


    // MARK: - 设置界面
    func setupUI() {
        view.addSubview(tableView)
        tableView.snp.remakeConstraints { (make) in
            make.top.right.bottom.left.equalTo(tableView.superview!)
        }
        
    }
    
    // MARK: - 设置是否推送消息
    func settingIsPushMessage(sender:UISwitch){
        UserDefaults.standard.set(sender.isOn, forKey: KonlyWIFILoadImage)
    }

    // MARK: - 退出登录
    func logout() {
        UserInfo.logout()
    }
}


extension SettingViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:PersonalInfoCell?
        if indexPath.section == 2{
            
            var isCanPush:Bool? = UserDefaults.standard.value(forKey: KonlyWIFILoadImage) as? Bool
            if isCanPush == nil{
               isCanPush = false
            }
            cell = PersonalInfoCell.init(reuseIdentifier: "switchCell",isNeedIcon:false, isNeedSwitch: true, switchIsOn: isCanPush!,isNeedArrow:false)
            cell?.buttonSwitch.addTarget(self, action: #selector(settingIsPushMessage), for:.valueChanged)
        }else if indexPath.section == 3{
            cell = PersonalInfoCell.init(reuseIdentifier: "haveCountCell",isNeedIcon: false, isNeedCount: true)
            cell?.countLabel.text = CacheTool.cacheSize
        
        }else if indexPath.section == 7{
            
          let cell = UITableViewCell.init(style: .default, reuseIdentifier: "logoutButtonCell")
          cell.contentView.addSubview(logoutBtn)
            logoutBtn.snp.remakeConstraints({ (make) in
            make.centerX.centerY.equalTo(logoutBtn.superview!)
            })
           return cell
            
        }else{
            let identifier = "personalCell"
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PersonalInfoCell
            if cell == nil{
                cell = PersonalInfoCell.init(reuseIdentifier: identifier, isNeedIcon: false)
            }
        
        
        }
        if (cell?.isKind(of: PersonalInfoCell.classForCoder()))!{
            cell?.userInfoLineLabel.text = array[indexPath.section]

        }
               return cell!
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38*LayoutHeightScale
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 140*LayoutHeightScale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 3{//清除缓存
            if CacheTool.clearCache(){
            SVProgressHUD.showSuccess(withStatus: "清除成功")
                tableView.reloadSections([indexPath.section], with: .none)
            }
            
    
        }
    }



}












