//
//  LMySettinVC.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/14.
//

import UIKit
import RxSwift
import MessageUI
import StoreKit
import Defaults
import NoticeObserveKit
import DeviceKit



let AppName: String = "Likesout"
let purchaseUrl = ""
let TermsofuseURLStr = "https://www.app-privacy-policy.com/live.php?token=Jcc2sGL1F9hFmnldAzK9ITRw5UF1VmVs"
let PrivacyPolicyURLStr = "https://www.app-privacy-policy.com/live.php?token=HszzhhaADQ5dvYZRCPFgo47cBRhDKGcY"
let feedbackEmail: String = "ovruj.audn@yandex.com"
let AppAppStoreID: String = ""



class LMySettinVC: UIViewController {

    let disposeBag = DisposeBag()
    let backBtn = UIButton(type: .custom)
    
    let userPlaceIcon = UIImageView(image: UIImage(named: "setting_name_background"))
    let userNameLabel = UILabel()
    let feedbackBtn = SettingContentBtn(frame: .zero, name: "Feedback", iconImage: UIImage(named: "setting_feedback_background"))
    let privacyLinkBtn = SettingContentBtn(frame: .zero, name: "Privacy Policy", iconImage: UIImage(named: "setting_privacy_background"))
    let termsBtn = SettingContentBtn(frame: .zero, name: "Terms of use", iconImage: UIImage(named: "setting_term_background"))
    let logoutBtn = SettingContentBtn(frame: .zero, name: "Log out", iconImage: UIImage(named: "setting_logout_background"))
    let loginBtn = UIButton(type: .custom)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupContentView()
        updateUserAccountStatus()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserAccountStatus()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func setupView() {
        view.backgroundColor = UIColor.black
        backBtn
            .image(UIImage(named: "ic_back"))
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                if self.navigationController != nil {
                    self.navigationController?.popViewController()
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        
        let topTitleLabel = UILabel()
            .fontName(18, "Verdana-Bold")
            .color(UIColor.white)
            .text("Setting")
        view.addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backBtn)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        view.addSubview(userPlaceIcon)
        userPlaceIcon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topTitleLabel.snp.bottom).offset(50)
            $0.left.equalTo(30)
            $0.height.equalTo((UIScreen.width - 30 * 2) * (178 / 354))
        }
        
        //
        userNameLabel.font = UIFont(name: "Verdana-Bold", size: 18)
//        userNameLabel.layer.shadowColor = UIColor(hexString: "#292929")?.cgColor
//        userNameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
//        userNameLabel.layer.shadowRadius = 3
//        userNameLabel.layer.shadowOpacity = 0.8
        userNameLabel.textColor = UIColor(hexString: "#000000")
        userNameLabel.textAlignment = .center
        userNameLabel.text = "Log in"
        view.addSubview(userNameLabel)
        userNameLabel.adjustsFontSizeToFitWidth = true
        userNameLabel.snp.makeConstraints {
            $0.center.equalTo(userPlaceIcon)
            $0.left.equalTo(30)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        
    }
     

    @objc func loginBtnClick(sender: UIButton) {
        self.showLoginVC()
    }
    //
    func setupContentView() {
        view.addSubview(loginBtn)
        loginBtn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
         
        loginBtn.snp.makeConstraints {
            $0.top.bottom.left.right.equalTo(userPlaceIcon)
        }
        
        let btnwidth: CGFloat = (UIScreen.width - 26 - 30 * 2) / 2
        let btnheight: CGFloat = btnwidth * (120/164)
        
        // feedback
        view.addSubview(feedbackBtn)
        feedbackBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.feedback()
        }
        feedbackBtn.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.height.equalTo(btnheight)
            $0.width.equalTo(btnwidth)
            $0.top.equalTo(userPlaceIcon.snp.bottom).offset(12)
            
        }
        
//        if Device.current.diagonal == 4.7 || Device.current.diagonal > 7 {
//            feedbackBtn.snp.makeConstraints {
//                $0.width.equalTo(357)
//                $0.height.equalTo(64)
//                $0.top.equalTo(userNameLabel.snp.bottom).offset(27)
//                $0.centerX.equalToSuperview()
//            }
//        } else {
//            feedbackBtn.snp.makeConstraints {
//                $0.width.equalTo(357)
//                $0.height.equalTo(64)
//                $0.top.equalTo(userNameLabel.snp.bottom).offset(37)
//                $0.centerX.equalToSuperview()
//            }
//        }
        
        // privacy link
        view.addSubview(privacyLinkBtn)
        privacyLinkBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
        }
        privacyLinkBtn.snp.makeConstraints {
            $0.right.equalTo(-30)
            $0.height.equalTo(btnheight)
            $0.width.equalTo(btnwidth)
            $0.top.equalTo(userPlaceIcon.snp.bottom).offset(12)
            
        }
        // terms
        
        view.addSubview(termsBtn)
        termsBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIApplication.shared.openURL(url: TermsofuseURLStr)
        }
        termsBtn.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.height.equalTo(btnheight)
            $0.width.equalTo(btnwidth)
            $0.top.equalTo(feedbackBtn.snp.bottom).offset(26)
            
        }
        
        // logout
        view.addSubview(logoutBtn)
        logoutBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            LoginMNG.shared.logout()
            self.updateUserAccountStatus()
        }
        logoutBtn.snp.makeConstraints {
            $0.right.equalTo(-30)
            $0.height.equalTo(btnheight)
            $0.width.equalTo(btnwidth)
            $0.top.equalTo(feedbackBtn.snp.bottom).offset(26)
            
        }
        
         
        
    }
    
}


extension LMySettinVC {
     
    
    func showLoginVC() {
        if LoginMNG.currentLoginUser() == nil {
            let loginVC = LoginMNG.shared.obtainVC()
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            
            self.present(loginVC, animated: true) {
            }
        }
    }
    func updateUserAccountStatus() {
        if let userModel = LoginMNG.currentLoginUser() {
            let userName  = userModel.userName
            userNameLabel.text = (userName?.count ?? 0) > 0 ? userName : "Sign in With Apple succeeded"
            logoutBtn.isHidden = false
            loginBtn.isHidden = true
//            loginBtn.isUserInteractionEnabled = false
            
        } else {
            userNameLabel.text = "Log in"
            logoutBtn.isHidden = true
            loginBtn.isHidden = false
//            loginBtn.isUserInteractionEnabled = true
            
        }
    }
}

extension LMySettinVC: MFMailComposeViewControllerDelegate {
    func feedback() {
        //首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail(){
            //获取系统版本号
            let systemVersion = UIDevice.current.systemVersion
            let modelName = UIDevice.current.modelName
            
            let infoDic = Bundle.main.infoDictionary
            // 获取App的版本号
            let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
            // 获取App的名称
            let appName = "\(AppName)"

            
            let controller = MFMailComposeViewController()
            //设置代理
            controller.mailComposeDelegate = self
            //设置主题
            controller.setSubject("\(appName) Feedback")
            //设置收件人
            // FIXME: feed back email
            controller.setToRecipients([feedbackEmail])
            //设置邮件正文内容（支持html）
         controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
            
            //打开界面
            self.present(controller, animated: true, completion: nil)
        }else{
            HUD.error("The device doesn't support email")
        }
    }
    
    //发送邮件代理方法
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
 }



class SettingContentBtn: UIButton {
    var clickBlock: (()->Void)?
    var nameTitle: String
    var iconImage: UIImage?
    init(frame: CGRect, name: String, iconImage: UIImage?) {
        self.nameTitle = name
        self.iconImage = iconImage
        super.init(frame: frame)
        setupView()
        addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
    }
    
    @objc func clickAction(sender: UIButton) {
        clickBlock?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .clear
//        self.layer.cornerRadius = 17
//        self.layer.borderWidth = 4
//        self.layer.borderColor = UIColor.black.cgColor
        
        
        //
        let iconImgV = UIImageView(image: iconImage)
        iconImgV.contentMode = .scaleAspectFit
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        //
        let nameLabel = UILabel()
        addSubview(nameLabel)
        nameLabel.text = nameTitle
        nameLabel.textColor = UIColor(hexString: "#000000")
        nameLabel.font = UIFont(name: "Verdana-Bold", size: 18)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines(0)
        nameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.greaterThanOrEqualTo(1)
            $0.left.equalTo(20)
        }
        
         
        
    }
    
}
