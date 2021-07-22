//
//  LMyLayoutEditVC.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/15.
//

import UIKit
import RxSwift
import Photos
import YPImagePicker

class LMyLayoutEditVC: UIViewController, UINavigationControllerDelegate {

    let disposeBag = DisposeBag()
    let bottomCanvasBgView = UIView()
    let bottomCanvasView = UIView()
    let contentCanvasView = UIView()
    var currentAddPhotoView: LyMmLyoutContentPhotoView?
    var layoutCanvasView: LMyLayoutCanvasView!
    var waterOverlayer: LMyLayoutWatermarkOverlayer!
    let bgToolBar = LMyLayoutBgColorView()
    var borderToolBar = LMyLayoutBorderView()
    var mirrorToolBar = LMyLayoutMirrorEffectView()
    var watermarkToolBar = LMyLayoutWaterMarkBar()
    var watermarkTextFeild = UITextField()
    var watermarkTextFeildToolView: UIView!
    let coinAlertView = LMyCoinUnlockView()
    var layoutType: String
    let hideButton = UIButton()
    var currentUnlockItemStr: String?
    
    
    init(layoutType: String) {
        self.layoutType = layoutType
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#171717")
        setupView()
        setupBottomToolBars()
        setupUnlockAlertView()
    }
    
    func setupUnlockAlertView() {
        
        coinAlertView.alpha = 0
        view.addSubview(coinAlertView)
        coinAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
    }

    func showUnlockCoinAlertView() {
        // show coin alert
        UIView.animate(withDuration: 0.35) {
            self.coinAlertView.alpha = 1
        }
        
        coinAlertView.okBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
            if LMymBCartCoinManager.default.coinCount >= LMymBCartCoinManager.default.coinCostCount {
                DispatchQueue.main.async {
                    if let unlockStr = self.currentUnlockItemStr {
                        LMymBCartCoinManager.default.costCoin(coin: LMymBCartCoinManager.default.coinCostCount)
                        LMymContentUnlockManager.default.unlock(itemId: unlockStr) {
                            DispatchQueue.main.async {
                                [weak self] in
                                guard let `self` = self else {return}
                                self.bgToolBar.collectionColor.reloadData()
                                self.bgToolBar.collectionBgImg.reloadData()
                                self.watermarkToolBar.collection.reloadData()
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Insufficient coins, please buy at the store first !", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.navigationController?.pushViewController(LMyMStoreVC())
                        }
                    }
                }
            }

            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    self.currentUnlockItemStr = nil
                }
            }
        }
        
        
        coinAlertView.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    self.currentUnlockItemStr = nil
                }
            }
        }
        
    }
}

extension LMyLayoutEditVC {
    func setupView() {
        let backBtn = UIButton(type: .custom)
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
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        
        //
        let saveBtn = UIButton(type: .custom)
        saveBtn
            .image(UIImage(named: "ic_save"))
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                self.saveAction()
            })
            .disposed(by: disposeBag)
        
        view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            $0.right.equalTo(-10)
            $0.width.height.equalTo(44)
        }
        //
        
        let bottomBar = UIView()
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.width.equalTo(346)
            $0.height.equalTo(130)
            $0.centerX.equalToSuperview()
        }
        //
        let bgToolBtn = UIButton(type: .custom)
        bgToolBtn
            .image(UIImage(named: "edit_background_background"))
            .adhere(toSuperview: bottomBar)
            .rx.tap
            .subscribe(onNext: {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.bgToolBtnClick()
                }
            })
            .disposed(by: disposeBag)
        bgToolBtn.snp.makeConstraints {
            $0.height.equalTo(130)
            $0.width.equalTo(122)
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        //
        let borderToolBtn = UIButton(type: .custom)
        borderToolBtn
            .image(UIImage(named: "edit_border_background"))
            .adhere(toSuperview: bottomBar)
            .rx.tap
            .subscribe(onNext: {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.borderToolBtnClick()
                }
            })
            .disposed(by: disposeBag)
        
        borderToolBtn.snp.makeConstraints {
            $0.height.equalTo(130)
            $0.width.equalTo(95)
            $0.left.equalTo(bgToolBtn.snp.right).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        //
        //
        let effectToolBtn = UIButton(type: .custom)
        effectToolBtn
            .image(UIImage(named: "edit_effect_background"))
            .adhere(toSuperview: bottomBar)
            .rx.tap
            .subscribe(onNext: {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.effectToolBtnClick()
                }
            })
            .disposed(by: disposeBag)
        effectToolBtn.snp.makeConstraints {
            $0.height.equalTo(61)
            $0.width.equalTo(121)
            $0.left.equalTo(borderToolBtn.snp.right).offset(8)
            $0.top.equalTo(borderToolBtn)
        }
        //
        let watermarkToolBtn = UIButton(type: .custom)
        watermarkToolBtn
            .image(UIImage(named: "edit_watermark_background"))
            .adhere(toSuperview: bottomBar)
            .rx.tap
            .subscribe(onNext: {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.watermarkToolBtnClick()
                }
            })
            .disposed(by: disposeBag)
        watermarkToolBtn.snp.makeConstraints {
            $0.height.equalTo(61)
            $0.width.equalTo(121)
            $0.left.equalTo(borderToolBtn.snp.right).offset(8)
            $0.bottom.equalTo(borderToolBtn.snp.bottom)
        }
        
        //
        let bgNameLabel = UILabel()
            .fontName(14, "Verdana-Bold")
            .color(UIColor.white)
            .text("Background")
            .adhere(toSuperview: bgToolBtn)
        bgNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-25)
            $0.height.width.greaterThanOrEqualTo(1)
        }
        //
        let borderNameLabel = UILabel()
            .fontName(14, "Verdana-Bold")
            .color(UIColor.white)
            .text("Border")
            .adhere(toSuperview: borderToolBtn)
        borderNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-25)
            $0.height.width.greaterThanOrEqualTo(1)
        }
        //
        let effectNameLabel = UILabel()
            .fontName(14, "Verdana-Bold")
            .numberOfLines(2)
            .color(UIColor.white)
            .text("Effect")
            .adhere(toSuperview: effectToolBtn)
        effectNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(12)
            $0.width.lessThanOrEqualTo(50)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        let waterNameLabel = UILabel()
            .fontName(14, "Verdana-Bold")
            .numberOfLines(2)
            .textAlignment(.left)
            .color(UIColor.white)
            .text("Water\nMark")
            .adhere(toSuperview: watermarkToolBtn)
        waterNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(12)
            $0.width.lessThanOrEqualTo(50)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        //
        bottomCanvasBgView
            .adhere(toSuperview: view)
            .backgroundColor(.clear)
        bottomCanvasBgView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.snp.bottom).offset(-250)
        }
        bottomCanvasBgView.isHidden = true
        //
        bottomCanvasView
            .adhere(toSuperview: bottomCanvasBgView)
            .backgroundColor(.white)
        bottomCanvasView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.snp.bottom).offset(100)
        }
        
        
        //
        let contentBgView = UIView()
        view.addSubview(contentBgView)
        contentBgView.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-260)
            $0.left.right.equalToSuperview()
        }
        
        //
        let width: CGFloat = (UIScreen.width - 30 * 2)
        //
        
        
        contentCanvasView.backgroundColor = UIColor.white
        contentBgView.addSubview(contentCanvasView)
        contentCanvasView.snp.makeConstraints {
            $0.width.height.equalTo(width)
            $0.center.equalToSuperview()
        }
        //
        layoutCanvasView = LMyLayoutCanvasView(frame: CGRect(x: 0, y: 0, width: width, height: width), frameRectType: layoutType)
        
        contentCanvasView.addSubview(layoutCanvasView)
        
        layoutCanvasView.selectPhotoBtnClickBlock = {
            [weak self] photoView in
            guard let `self` = self else {return}
            self.currentAddPhotoView = photoView
            self.showPhotoSelect()
        }
        //
        waterOverlayer = LMyLayoutWatermarkOverlayer(frame: CGRect(x: 0, y: 0, width: width, height: width))
        contentCanvasView.addSubview(waterOverlayer)
        waterOverlayer.isUserInteractionEnabled = false
        waterOverlayer.isHidden = true
    }
    
    func setupBottomToolBars() {
        
        bgToolBar
            .adhere(toSuperview: bottomCanvasView)
        bgToolBar.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
        }
        bgToolBar.didSelectBgItemBlock = {
            [weak self] bgItem, isPro in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                if !isPro || LMymContentUnlockManager.default.hasUnlock(itemId: bgItem.thumbName) {
                    
                    self.layoutCanvasView.updateBgItem(bgItem: bgItem)
                } else {
                    self.currentUnlockItemStr = bgItem.thumbName
                    self.showUnlockCoinAlertView()
                }
            }
        }
        bgToolBar.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.hiddenBottomBar()
            }
        }
        //
        borderToolBar
            .adhere(toSuperview: bottomCanvasView)
        borderToolBar.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
        }
        borderToolBar.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.hiddenBottomBar()
            }
        }
        borderToolBar.didSelectBorderIntmBlock = {
            [weak self] itemInt in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.layoutCanvasView.updateBorder(borderIndex: itemInt)
            }
        }
        borderToolBar.didSelectCornerIntBlock = {
            [weak self] itemInt in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.layoutCanvasView.updateCorner(cornerIndex: itemInt)
            }
        }
        //
        
        mirrorToolBar
            .adhere(toSuperview: bottomCanvasView)
        mirrorToolBar.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
        }
        mirrorToolBar.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.hiddenBottomBar()
            }
        }
        mirrorToolBar.horClickStatusBlock = {
            [weak self] isHor in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.layoutCanvasView.updateHorMirror(isHor: isHor)
            }
        }
        mirrorToolBar.verClickStatusBlock = {
            [weak self] isVer in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.layoutCanvasView.updateVerMirror(isVer: isVer)
            }
        }
        //
        watermarkToolBar
            .adhere(toSuperview: bottomCanvasView)
        watermarkToolBar.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
        }
        watermarkToolBar.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.hiddenBottomBar()
            }
        }
        watermarkToolBar.enterWaterMarkClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.resetupTextFeild()
                self.watermarkTextFeild.becomeFirstResponder()
            }
        }
        watermarkToolBar.selectWaterMarkClickBlock = {
            [weak self] watermarkIndex, isPro, watermarkName in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if !isPro || LMymContentUnlockManager.default.hasUnlock(itemId: watermarkName) {
                    self.updateWatermakrContentType(typeIndex: watermarkIndex)
                } else {
                    self.currentUnlockItemStr = watermarkName
                    self.showUnlockCoinAlertView()
                }
            }
        }
        
        
        //
        
        
        //
        
        
    }
    
    func resetupTextFeild() {
        
        //
        watermarkTextFeildToolView = UIView(frame: CGRect(x: 0, y: 100, width: UIScreen.width, height: 50))
        watermarkTextFeildToolView.backgroundColor = .white
        view.addSubview(watermarkTextFeildToolView)
        //
        
        hideButton
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                self.closeKeyboradAction(text: self.watermarkTextFeild.text)
            })
            .disposed(by: disposeBag)
        hideButton.setImage(UIImage(named: ""), for: .normal)
        hideButton.setTitle("Okey", for: .normal)
        hideButton.setTitleColor(UIColor.init(hexString: "#000000"), for: .normal)
        
        watermarkTextFeildToolView.addSubview(hideButton)
        hideButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.greaterThanOrEqualTo(1)
            $0.right.equalTo(-20)
            $0.centerY.equalToSuperview()
        }
        
        //
        watermarkTextFeildToolView.addSubview(watermarkTextFeild)
        watermarkTextFeild.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(30)
            $0.height.equalTo(38)
            $0.right.equalTo(-80)
        }
        watermarkTextFeild.inputAccessoryView =  watermarkTextFeildToolView
        watermarkTextFeild.delegate = self
    }
    
    func showBottomBar(bar: UIView) {
        
        for view in bottomCanvasView.subviews {
            if view == bar {
                view.isHidden = false
            } else {
                view.isHidden = true
            }
        }
        bottomCanvasBgView.isHidden = false
        
        bottomCanvasView.snp.remakeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.snp.bottom).offset(-250)
        }
        UIView.animate(withDuration: 0.3) {
            self.bottomCanvasBgView.layoutIfNeeded()
        } completion: { finished in
            
        }
    }
    
    func hiddenBottomBar() {
        
        bottomCanvasView.snp.remakeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.snp.bottom).offset(100)
        }
        UIView.animate(withDuration: 0.3) {
            self.bottomCanvasBgView.layoutIfNeeded()
        } completion: { finished in
            if finished {
                self.bottomCanvasBgView.isHidden = true
            }
        }
    }
    
}
extension LMyLayoutEditVC {
    func saveAction() {
        for subV in layoutCanvasView.rectSubViews {
            subV.selectPhotoBtn.isHidden = true
        }
        
        if let img = contentCanvasView.screenshot {
            saveToAlbumPhotoAction(images: [img])
        }
        for subV in layoutCanvasView.rectSubViews {
            subV.selectPhotoBtn.isHidden = false
        }
    }
    
    func bgToolBtnClick() {
        showBottomBar(bar: bgToolBar)
    }
    
    func borderToolBtnClick() {
        showBottomBar(bar: borderToolBar)
    }
    
    func effectToolBtnClick() {
        showBottomBar(bar: mirrorToolBar)
    }
    
    func watermarkToolBtnClick() {
        var isFirstShowWatermark: Bool = true
        if isFirstShowWatermark {
            isFirstShowWatermark = false
            updateWatermakrContentType(typeIndex: 1)
            watermarkToolBar.currentWaterItemIndex = 1
            watermarkToolBar.collection.reloadData()
        }
        
        showBottomBar(bar: watermarkToolBar)
    }
    
    func showPhotoSelect() {
        checkAlbumAuthorization()
    }
    
    func updateWatermark(textStr: String?) {
        // update watermark preview content
        waterOverlayer.udpateWaterText(waterText: textStr)
    }
    func updateWatermakrContentType(typeIndex: Int) {
        if typeIndex == 0 {
            waterOverlayer.isHidden = true
        } else {
            waterOverlayer.isHidden = false
            waterOverlayer.udpateWaterType(waterType: typeIndex)
        }
    }
    func closeKeyboradAction(text: String?) {
        self.watermarkTextFeild.endEditing(true)
//        self.watermarkTextFeild.resignFirstResponder()
        self.watermarkToolBar.updateEnterTextStr(textStr: text)
    }
}




extension LMyLayoutEditVC: UIImagePickerControllerDelegate {
    
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
        self.currentAddPhotoView?.updateContentImg(img: image)
    }

    
    
}



extension LMyLayoutEditVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        debugPrint("textFieldDidEndEditing")
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateWatermark(textStr: textField.text)
        
        debugPrint("did Changeing")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        updateWatermark(textStr: textField.text)
        
        if string == "" {
            
        } else {
//            TaskDelay.default.taskDelay(afterTime: 0.8) {[weak self] in
//                guard let `self` = self else {return}
//            }
        }
        debugPrint("shouldChangeCharactersIn")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        closeKeyboradAction(text: textField.text)
         
        
        return true
    }
    
    
}

extension LMyLayoutEditVC {
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
            }) { (finish, error) in
                if finish {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        self.showSaveSuccessAlert()
//                        if self.shouldCostCoin {
//                            LMymBCartCoinManager.default.costCoin(coin: LMymBCartCoinManager.default.coinCostCount)
//                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        if error != nil {
                            let auth = PHPhotoLibrary.authorizationStatus()
                            if auth != .authorized {
                                self.showDenideAlert()
                            }
                        }
                    }
                }
            }
        })
    }
    
    func showSaveSuccessAlert() {
        HUD.success("Photo save successful.")
    }
    
    func showDenideAlert() {
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
    }
    
}
