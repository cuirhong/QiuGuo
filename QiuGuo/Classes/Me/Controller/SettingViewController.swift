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
        UserDefaults.standard.set(sender.isOn, forKey: KisPushMessage)
    }
    
    func settingOnlyWIFILoadImage(sender:UISwitch){
     UserDefaults.standard.set(sender.isOn, forKey: KonlyWIFILoadImage)
    
    }

    // MARK: - 退出登录
    func logout() {
        UserInfo.logout()
        navigationController?.popViewController(animated: false)
       
    }
}


extension SettingViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if UserInfo.loadAccount() != nil{
        
        return 5
        }
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return 2
        case 3:
            return 3
        default:
            return 1
        }

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:PersonalInfoCell?
        var isNeedUndline:Bool = false
        
        if indexPath.section == 2{
            if indexPath.row == 0{
             isNeedUndline = true
            }
         
        }
        
        if indexPath.section == 3{
            if indexPath.row == 0 || indexPath.row == 1{
              isNeedUndline = true
            
            }
        }
        
 
        if indexPath.section == 1 {
        
            var isCanPush:Bool? = UserDefaults.standard.value(forKey: KisPushMessage) as? Bool
            if isCanPush == nil{
                isCanPush = false
            }
            cell = PersonalInfoCell.init(reuseIdentifier: "switchCell",isNeedIcon:false, isNeedSwitch: true, switchIsOn: isCanPush!,isNeedArrow:false,isNeedUndline:isNeedUndline)
            cell?.buttonSwitch.addTarget(self, action: #selector(settingIsPushMessage(sender:)), for:.valueChanged)
            
        
        }else if indexPath.section == 2{
            if indexPath.row == 0{
                var isLoadImage:Bool? = UserDefaults.standard.value(forKey: KonlyWIFILoadImage) as? Bool
                if isLoadImage == nil{
                    isLoadImage = false
                }
                cell = PersonalInfoCell.init(reuseIdentifier: "switchCell",isNeedIcon:false, isNeedSwitch: true, switchIsOn: isLoadImage!,isNeedArrow:false,isNeedUndline:isNeedUndline)
                cell?.buttonSwitch.addTarget(self, action: #selector(settingOnlyWIFILoadImage(sender:)), for:.valueChanged)
            }else{
                cell = PersonalInfoCell.init(reuseIdentifier: "haveCountCell",isNeedIcon: false, isNeedCount: true,isNeedUndline:isNeedUndline)
                cell?.countLabel.text = CacheTool.cacheSize

            }
            
         
        }else if indexPath.section == 4{
            
          let cell = UITableViewCell.init(style: .default, reuseIdentifier: "logoutButtonCell")
            cell.contentView.addSubview(logoutBtn)
            logoutBtn.snp.remakeConstraints({ (make) in
                make.centerX.centerY.equalTo(logoutBtn.superview!)
            })
           return cell
            
        }else{
            let identifier = "personalCell"
             cell = PersonalInfoCell.init(reuseIdentifier: identifier,isNeedIcon:false,isNeedUndline:isNeedUndline)
      
            
        }
        
        
        var text = ""
        if indexPath.section == 0{
        
          text = array[0]
        }else if  indexPath.section == 1{
         text = array[1]
        
        }else if indexPath.section == 2{
            if indexPath.row == 0{
            
            text = array[2]
            }else{
            text = array[3]
            
            }
        
        
        }else if indexPath.section == 3{
            switch indexPath.row {
            case 0:
                text = array[4]
            case 1:
                text = array[5]
            case 2:
                text = array[6]
            default:
                 break
            }
        
        }else {
            text = array.last!
        
        }

        if (cell?.isKind(of: PersonalInfoCell.classForCoder()))!{
            cell?.userInfoLineLabel.text = text

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
        if indexPath.section == 2 ,indexPath.row == 1{//清除缓存
           _ = CacheTool.clearCache()
             HUDTool.show(showType: .Success, text: "清除成功", viewController: self)
            tableView.reloadSections([indexPath.section], with: .none)
    
        }else{
           HUDTool.show(showType: .Info, text: "抱歉,暂未开通此功能", viewController: self)
        }
    }



}












