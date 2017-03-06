//
//  MeViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/27.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit

class MeViewController: BaseViewController {
    
    var array:[[String]] = []
    
    fileprivate lazy var tabelView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false

        let headView = MeHeadView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 400*LayoutHeightScale))
        if UserInfo.loadAccount() == nil {
              headView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickUserHeadView)))
        }
        tableView.rowHeight = 174*LayoutHeightScale        
        tableView.tableHeaderView = headView
        return tableView

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        
        
        
        setupUI()
        if UserInfo.loadAccount() == nil{
            NotificationCenter.default.addObserver(self, selector: #selector(login), name: NSNotification.Name(rawValue: LoginNotificationName), object: nil)
            
        }
    
    }
    
    //MARK:- 初始化数据
    override func initData() {
        super.initData()
        
        let meMessageArr = ["message","我的消息","10"]
        let meIntegralArr = ["integral","我的积分","234"]
         let meTicketArr = ["ticket","我的球票","4434"]
         let meGuesslArr = ["trophy","我的竞猜","378"]
         let giftArr = ["gift","兑换礼品","54"]
         let settingArr = ["setting","设置",""]
        
        
        
        array.append(meMessageArr)
          array.append(meIntegralArr)
          array.append(meTicketArr)
          array.append(meGuesslArr)
          array.append(giftArr)
          array.append(settingArr)
   
    }
    
    //MARK:- 登录
    func login() {
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
      
    }
    
    
    func setupUI(){
 
        
         view.addSubview(tabelView)
        tabelView.snp.remakeConstraints { (make) in
            make.top.right.bottom.left.equalTo(tabelView.superview!)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func clickUserHeadView(){

        if UserInfo.userLogin() {
          
   
        }
  
    
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = nil
    }
    
    
    //MARK:- 西沟方法
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: LoginNotificationName), object: nil)
    }
    
    
    
    
    
    
}


// MARK: - 协议方法
extension MeViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "personalCell"
        var cell:PersonalInfoCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? PersonalInfoCell
        if cell == nil{
            cell = PersonalInfoCell.init(style: .default, reuseIdentifier: identifier, isNeedCount: true)
        }
        
        switch indexPath.section {
        case 0:
            let infoArr = array[0]
            cell?.array = infoArr
        case 1:
            let index = indexPath.row + 1
            cell?.array = array[index]
        case 2:
            cell?.array = array.last
    default: break
        }
        return cell!

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return 4
        }
        return 1
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30*LayoutHeightScale
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell:PersonalInfoCell = tableView.cellForRow(at: indexPath) as! PersonalInfoCell
        var controller:UIViewController?
       
        if cell.userInfoLineLabel.text == "设置"{
        
            controller = SettingViewController()
        }
        guard controller == nil else {
            controller?.title = cell.userInfoLineLabel.text
            self.navigationController?.pushViewController(controller!, animated: true)
            return
        }
        
    }


}
















