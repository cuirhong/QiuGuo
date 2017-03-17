//
//  GuessResultRankCell.swift
//  QiuGuo
//
//  Created by cuirhong on 2017/3/15.
//  Copyright © 2017年 qiuyoukeji. All rights reserved.
//

//竞猜结果排名默认字体颜色
private let GuessResultRankDefaultFontColor = UIColor.init(hexString: "#7f7f7f")

//积分的宽度(由于不同的积分宽度不一致)
var userScoreWidth:CGFloat = 240*LayoutWidthScale

class GuessResultRankCell: BaseCollectionViewCell {
    
    //MARK:- 竞猜结果用户
    var guessResultUser:GuessResultUserModel?{
        didSet{
            
            numberLabel.text = String(format: "%02d", (guessResultUser?.resultRankNum)!)
            if (guessResultUser?.resultRankNum)! <= 3{
              crownImageView.isHidden = false
                crownImageView.image = UIImage.getImage(String(format: "crown_%d", (guessResultUser?.resultRankNum)!))
            }else{
              crownImageView.isHidden = true
            }
            
            headImageView.kf_setImage(imageUrlStr: guessResultUser?.UserHeadimgurl)
            nickLabel.text = guessResultUser?.UserName
            
            guessTrueCountLabel.text = "猜对" + (guessResultUser?.RightNum.description)! + "场"
            userScoreLabel.text = (guessResultUser?.IncomeExp.description)! + " 积分"
            
            
            if guessResultUser?.resultRankNum == 1{
              userScoreWidth = userScoreLabel.labelSize(text: userScoreLabel.text!, font: UIFont.font(psFontSize: 40)).width + 5
            
            }

            userScoreLabel.snp.remakeConstraints{ (make) in
                make.right.equalTo(-44*LayoutWidthScale)
                make.centerY.equalTo(userScoreLabel.superview!)
                make.width.equalTo(userScoreWidth)
            }
  
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
    
    
    //MARK:- 布局
    func setupUI(){
        
        addSubview(numberLabel)
        numberLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(32*LayoutWidthScale)
            make.centerY.equalTo(numberLabel.superview!)
        }
        
        
        addSubview(headImageView)
        headImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(headImageView.superview!)
            make.left.equalTo(numberLabel.snp.right).offset(46*LayoutWidthScale)
            make.width.height.equalTo(100*LayoutHeightScale)
        }
        
        addSubview(crownImageView)
        crownImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(headImageView.snp.top)
            make.centerX.equalTo(headImageView.snp.left)
        }
        
        addSubview(userScoreLabel)
        userScoreLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-44*LayoutWidthScale)
            make.centerY.equalTo(userScoreLabel.superview!)
            make.width.equalTo(userScoreWidth)
        }

        addSubview(guessTrueCountLabel)
        guessTrueCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(guessTrueCountLabel.superview!)
            make.right.equalTo(userScoreLabel.snp.left).offset(-38*LayoutWidthScale)
            
        }
        
        
        addSubview(nickLabel)
        nickLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(nickLabel.superview!)
            make.left.equalTo(headImageView.snp.right).offset(15*LayoutWidthScale)
            make.right.lessThanOrEqualTo(guessTrueCountLabel.snp.left)
        }
        
        addSubview(undline)
        undline.snp.makeConstraints { (make) in
            make.top.equalTo(headImageView.snp.bottom).offset(12*LayoutHeightScale)
            make.right.left.equalTo(undline.superview!)
            make.height.equalTo(6*LayoutHeightScale)
        }
    }
    
    
    
    
    
    
    
    //MARK:- 竞猜字体默认颜色
    private lazy var numberLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 48), textColor: GuessResultRankDefaultFontColor)
    
    //MARK:- 头像
    private lazy var headImageView:UIImageView = UIImageView()
    
    //MARK:- 王冠图片 
    private lazy var crownImageView:UIImageView = UIImageView()
    
    //MARK:- 昵称
    private lazy var nickLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 40), textColor: GuessResultRankDefaultFontColor)
    //MARK:- 才对几场
    private lazy var guessTrueCountLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 40), textColor: GuessResultRankDefaultFontColor)
    //MARK:- 用户积分
    private lazy var userScoreLabel:UILabel = UILabel(text: "", font: UIFont.font(psFontSize: 40), textColor: GuessResultRankDefaultFontColor,textAlignment:.right)
    //MARK:- 分割线
    private lazy var undline:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(hexString: "#f2f2f2")
        return label
    }()
    
    
}
