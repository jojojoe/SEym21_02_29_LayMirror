//
//  LMyMainVC.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/14.
//

import UIKit
import RxSwift
import Photos
import YPImagePicker

class LMyMainVC: UIViewController, UINavigationControllerDelegate {
    let topCoinLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        showLoginVC()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            AFlyerLibManage.event_LaunchApp()
        }
        
        
    }
    func showLoginVC() {
           if LoginMNG.currentLoginUser() == nil {
            let loginVC = LoginMNG.shared.obtainVC()
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            
            self.present(loginVC, animated: true) {
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topCoinLabel.text = "\(LMymBCartCoinManager.default.coinCount)Coins"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}

extension LMyMainVC {
    func setupView() {
        view.backgroundColor = UIColor.black
        //
        let settinBtn = UIButton(type: .custom)
            .image(UIImage(named: "home_ic_setting"), .normal)
        settinBtn.addTarget(self, action: #selector(settinBtnClick(sender:)), for: .touchUpInside)
        view.addSubview(settinBtn)
        settinBtn.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.width.height.equalTo(44)
        }
        //
        //
        topCoinLabel.textAlignment = .right
        topCoinLabel.text = "\(LMymBCartCoinManager.default.coinCount)Coins"
        topCoinLabel.textColor = UIColor(hexString: "#FFFFFF")
        topCoinLabel.font = UIFont(name: "Verdana-Bold", size: 18)
        topCoinLabel.isHidden = true
        view.addSubview(topCoinLabel)
        topCoinLabel.snp.makeConstraints {
            $0.right.equalTo(-20)
            $0.centerY.equalTo(settinBtn)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //home_layout
        let storeVCBtn = UIButton(type: .custom)
            .image(UIImage(named: "home_store"), .normal)
        storeVCBtn.addTarget(self, action: #selector(storeVCBtnClick(sender:)), for: .touchUpInside)
        view.addSubview(storeVCBtn)
        storeVCBtn.snp.makeConstraints {
            $0.right.equalTo(-20)
            $0.centerY.equalTo(settinBtn)
            $0.width.equalTo(172/2)
            $0.height.equalTo(72/2)
            
            
        }
        
        //
        let topNameLabel = UILabel()
            .fontName(24, "Verdana-Bold")
            .color(UIColor.white)
            .text("Insta Grid Layout & Pic Editor")
            .textAlignment(.left)
            .numberOfLines(2)
        view.addSubview(topNameLabel)
        topNameLabel.snp.makeConstraints {
            $0.top.equalTo(settinBtn.snp.bottom).offset(35)
            $0.left.equalTo(28)
            $0.centerX.equalToSuperview()
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        let btnWidth: CGFloat  = (UIScreen.main.bounds.width - 30 * 2 - 18 - 1) / 2
        let btnHeight: CGFloat = (826/336) * btnWidth + 60 + 60 + 20
         
        //
        let layoutBtn = LMyMainHomeBtn(frame: .zero, topName: "Layout", bottomName: "Lots of stitch you can choose", iconName: "home_layout")
        view.addSubview(layoutBtn)
        layoutBtn.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.height.equalTo(btnHeight)
            $0.width.equalTo(btnWidth)
            $0.top.equalTo(topNameLabel.snp.bottom).offset(40)
            
        }
        layoutBtn.addTarget(self, action: #selector(layoutBtnClick(sender:)), for: .touchUpInside)
        
        //
        let mirrorBtn = LMyMainHomeBtn(frame: .zero, topName: "Mirror Effect", bottomName: "Lots of stitch you can choose", iconName: "home_mirror")
        view.addSubview(mirrorBtn)
        mirrorBtn.snp.makeConstraints {
            $0.right.equalTo(-30)
            $0.height.equalTo(btnHeight)
            $0.width.equalTo(btnWidth)
            $0.top.equalTo(layoutBtn.snp.top)
            
        }
        mirrorBtn.addTarget(self, action: #selector(mirrorBtnClick(sender:)), for: .touchUpInside)
        
    }
    
    @objc func settinBtnClick(sender: UIButton) {
        self.navigationController?.pushViewController(LMySettinVC())
    }
    @objc func storeVCBtnClick(sender: UIButton) {
        self.navigationController?.pushViewController(LMyMStoreVC())
    }
    @objc func layoutBtnClick(sender: UIButton) {
        let vc = LMyLayoutTypeSelectVC()
        vc.upVC = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @objc func mirrorBtnClick(sender: UIButton) {
        
        checkAlbumAuthorization()
    }
    
}


extension LMyMainVC: UIImagePickerControllerDelegate {
    
    func checkAlbumAuthorization() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.presentPhotoPickerController()
                    }
                case .limited:
                    DispatchQueue.main.async {
                        self.presentLimitedPhotoPickerController()
                    }
                case .notDetermined:
                    if status == PHAuthorizationStatus.authorized {
                        DispatchQueue.main.async {
                            self.presentPhotoPickerController()
                        }
                    } else if status == PHAuthorizationStatus.limited {
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    }
                case .denied:
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                            DispatchQueue.main.async {
                                let url = URL(string: UIApplication.openSettingsURLString)!
                                UIApplication.shared.open(url, options: [:])
                            }
                        })
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        alert.addAction(confirmAction)
                        alert.addAction(cancelAction)
                        
                        self.present(alert, animated: true)
                    }
                    
                case .restricted:
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                            DispatchQueue.main.async {
                                let url = URL(string: UIApplication.openSettingsURLString)!
                                UIApplication.shared.open(url, options: [:])
                            }
                        })
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        alert.addAction(confirmAction)
                        alert.addAction(cancelAction)
                        
                        self.present(alert, animated: true)
                    }
                default: break
                }
            }
        }
    }
    
    func presentLimitedPhotoPickerController() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.screens = [.library]
        config.library.defaultMultipleSelection = false
        config.library.skipSelectionsGallery = true
        config.showsPhotoFilters = false
        config.library.preselectedItems = nil
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            var imgs: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    if let img = photo.image.scaled(toWidth: 1200) {
                        imgs.append(img)
                    }
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
            if !cancelled {
                if let image = imgs.first {
                    self.showEditVC(image: image)
                }
            }
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        var imgList: [UIImage] = []
//
//        for result in results {
//            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
//                if let image = object as? UIImage {
//                    DispatchQueue.main.async {
//                        // Use UIImage
//                        print("Selected image: \(image)")
//                        imgList.append(image)
//                    }
//                }
//            })
//        }
//        if let image = imgList.first {
//            self.showEditVC(image: image)
//        }
//    }
    
 
    func presentPhotoPickerController() {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = false
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.showEditVC(image: image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showEditVC(image: image)
        }

    }
//
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showEditVC(image: UIImage) {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            let vc = LMyMirrorEffectEditVC(originalImg: image)
            self.navigationController?.pushViewController(vc)
        }

    }

    
    
}



class LMyMainHomeBtn: UIButton {
    
    var topName: String
    var bottomName: String
    var iconName: String
    
    init(frame: CGRect, topName: String, bottomName: String, iconName: String) {
        self.topName = topName
        self.bottomName = bottomName
        self.iconName = iconName
        
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let topLabel = UILabel()
            .fontName(18, "Verdana-Bold")
            .color(UIColor.white)
            .text(topName)
        addSubview(topLabel)
        topLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(0)
            $0.height.width.greaterThanOrEqualTo(1)
        }
        //
        
        let bottomLabel = UILabel()
            .fontName(18, "Verdana-Bold")
            .color(UIColor.white)
            .text(bottomName)
            .textAlignment(.center)
            .numberOfLines(0)
        bottomLabel.isHidden = true
        bottomLabel.adjustsFontSizeToFitWidth = true
        addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.left.equalTo(0)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        let contentIconImgV = UIImageView(image: UIImage(named: iconName))
            .contentMode(.scaleAspectFit)
            .backgroundColor(.clear)
        addSubview(contentIconImgV)
        contentIconImgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topLabel.snp.bottom).offset(10)
            $0.bottom.equalTo(bottomLabel.snp.top).offset(-10)
        }
        
    }
    
    
}


