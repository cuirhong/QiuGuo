//
//  MeViewController.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/2/27.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

import UIKit




class MeViewController: BaseViewController {
    
    //MARK:- 我的页面模型数组
    var array:[[MeModel]] = []
    
    //MARK:- viewModel
    lazy var meViewModel = MeViewModel()
    
    fileprivate lazy var tabelView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false

      
        return tableView

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = nil

        initData()
        if UserInfo.loadAccount() != nil {
            DispatchQueue.global().async {[weak self]in
                self?.loadData()
            }
        }else{
            setupUI()
        }
        
    }
    
    //MARK:- 初始化数据
    override func initData() {
        super.initData()
        
        let jsonPath = Bundle.main.path(forResource: "MeCenterData.json", ofType: nil)
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: jsonPath!))
        let dataArr = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[[String:Any]]]
        for jsonArr in dataArr {
            var sectionArr = [MeModel]()
            for dict in jsonArr {
                let model = MeModel(dict: dict)
                sectionArr.append(model)
            }
            array.append(sectionArr)
            
        }

   
    }
    
    //MARK:- 加载数据
    override func loadData() {
        super.loadData()
       
        meViewModel.userCenter(successCallBack: {[weak self ] (result) in
            let code = result["code"].intValue
    
            if let dict = result["data"].dictionaryObject , code == 1 {
                //成功
                let  userAccount = UserInfo.init(dict: dict)
                UserInfo.loadAccount()?.isFirst = userAccount.isFirst
                UserInfo.loadAccount()?.Headimgurl = userAccount.Headimgurl
                UserInfo.loadAccount()?.Signature = userAccount.Signature
                UserInfo.loadAccount()?.Nickname = userAccount.Nickname
                UserInfo.loadAccount()?.Age = userAccount.Age
                UserInfo.loadAccount()?.Point = userAccount.Point
                UserInfo.loadAccount()?.Exp = userAccount.Exp
                UserInfo.loadAccount()?.Notice = userAccount.Notice
                UserInfo.loadAccount()?.Sex = userAccount.Sex
  
                _ =  UserInfo.loadAccount()?.saveUserInfo()
            }
            DispatchQueue.main.async {
                self?.setupUI()
            }
        }) { (error) in
            HUDTool.show(showType: .Failure, text: error.debugDescription)
        }
    }
    
 
    
  
    
    //MARK:- 设置界面
    func setupUI(){
 
        let headView = MeHeadView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 400*LayoutHeightScale))
        headView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickUserHeadView)))

        tabelView.rowHeight = 174*LayoutHeightScale
        tabelView.tableHeaderView = headView
        if tabelView.superview == nil{
           view.addSubview(tabelView)
        }
        
        tabelView.snp.remakeConstraints { (make) in
            make.top.right.bottom.left.equalTo(tabelView.superview!)
        }
    }
    
    //MARK:- 点击用户头像
    func clickUserHeadView(){

        if UserInfo.userLogin() {
          
   
        }
  
    
    
    }
    
    
    //MARK:- 已经点击了row
    func didSelectRow(meModel:MeModel){
    
        DispatchQueue.main.async {[weak self] in
         
            if (meModel.isNeedLogin) == 1{
                
                if UserInfo.userLogin() == false{
                    return
                }
            }
            
            if (meModel.controller.characters.count) > 0 {
                
                let controller = meModel.controller
                let spaceName = Bundle.main.infoDictionary!["CFBundleExecutable"]
                
                let className = (spaceName as! String) + "." + controller
                let vcClass:AnyClass = NSClassFromString(className)!
                //告诉编译器实际的类型
                let trueClass = vcClass as! UIViewController.Type
                let jumpController = trueClass.init()
                
                jumpController.title = meModel.title
                self?.navigationController?.pushViewController(jumpController, animated: true)}

        }
    
    
    }
    

    
    
    //MARK:- 西沟方法
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: LoginNotificationName), object: nil)
    }
    
    
    
    
    
    
}


// MARK: - 协议方法
extension MeViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return array.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "personalCell"
        var cell:PersonalInfoCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? PersonalInfoCell
        if cell == nil{
            cell = PersonalInfoCell.init(style: .default, reuseIdentifier: identifier, isNeedCount: true)
        }
        
        let modelArr = array[indexPath.section]
        
        cell?.meModel = modelArr[indexPath.row]
 
        
        return cell!

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let modelArr = array[section]
        return modelArr.count
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30*LayoutHeightScale
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        let cell:PersonalInfoCell = tableView.cellForRow(at: indexPath) as! PersonalInfoCell
        if let meModel = cell.meModel {
          didSelectRow(meModel:meModel)
        }
    }


}
















