//
//  LMyLayoutCanvasView.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/15.
//

import UIKit
import RxSwift

class LMyLayoutCanvasView: UIView {
    var frameRectType: String
    
    let canvasView = UIView()
    var rectSubViews: [LyMmLyoutContentPhotoView] = []
    var selectPhotoBtnClickBlock: ((LyMmLyoutContentPhotoView)->Void)?
    let canvasBgColorImgV = UIImageView()
    
    init(frame: CGRect, frameRectType: String) {
        self.frameRectType = frameRectType
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension LMyLayoutCanvasView {
    func setupView() {
        
        canvasBgColorImgV.backgroundColor = .white
        addSubview(canvasBgColorImgV)
        canvasBgColorImgV.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        //
        let padding: CGFloat = 10
        let canvasWidth: CGFloat = frame.width - padding * 2
        let canvasHeight: CGFloat = frame.height - padding * 2
        //
        canvasView.layer.masksToBounds = true
        addSubview(canvasView)
        canvasView.frame = CGRect(x: padding, y: padding, width: canvasWidth, height: canvasHeight)
        //
        let rectList = LyMmLayoutTypeManager.default.processLayoutFrames(canvasWidth: canvasWidth, canvasHeight: canvasHeight, layoutType: frameRectType)
        
        rectSubViews = []
        
        for itemRect in rectList {
            let rectV = LyMmLyoutContentPhotoView()
            rectV.frame = itemRect
            rectSubViews.append(rectV)
            canvasView.addSubview(rectV)
            rectV.updateViewStatus(isEmpty: true)
            rectV.selectPhotoBtnClickBlock = {
                DispatchQueue.main.async {
                    self.selectPhotoBtnClickBlock?(rectV)
                }
            }
        }
        
        
    }
    
    
    func updateCorner(cornerIndex: Int) {
        var cornerRadius: CGFloat = 0
        if cornerIndex == 0 {
            cornerRadius = 0
        } else if cornerIndex == 1 {
            cornerRadius = canvasView.bounds.size.width / 2
        } else if cornerIndex == 2 {
            cornerRadius = canvasView.bounds.size.width / 4
        } else if cornerIndex == 3 {
            cornerRadius = canvasView.bounds.size.width / 6
        }
        
        canvasView.layer.cornerRadius = cornerRadius
        
    }
    
    func updateBorder(borderIndex: Int) {
        // 0.92 0.85 0.78 0.7
        var borderRadius: CGFloat = 0
        if borderIndex == 0 {
            borderRadius = 1
        } else if borderIndex == 1 {
            borderRadius = 0.92
        } else if borderIndex == 2 {
            borderRadius = 0.85
        } else if borderIndex == 3 {
            borderRadius = 0.78
        } else if borderIndex == 4 {
            borderRadius = 0.7
        }
        canvasView.transform = CGAffineTransform.init(scaleX: borderRadius, y: borderRadius)
    }
    
    func updateBgItem(bgItem: NEymEditToolItem) {
        if bgItem.bigName.contains("#") {
            canvasBgColorImgV.image = nil
            canvasBgColorImgV.backgroundColor = UIColor(hexString: bgItem.bigName)
        } else {
            canvasBgColorImgV.image = UIImage(named: bgItem.bigName)
        }
    }
    
    func updateHorMirror(isHor: Bool) {
        for photoView in rectSubViews {
            photoView.horMirrorAction(isMirror: isHor)
        }
         
    }
    
    func updateVerMirror(isVer: Bool) {
        for photoView in rectSubViews {
            photoView.verMirrorAction(isMirror: isVer)
        }
         
    }
    
}


class LyMmLyoutContentPhotoView: UIView {
    var horMiroorView = UIView()
    var verMiroorView = UIView()
    
    var contentImgV = UIImageView()
    var selectPhotoBtn = UIButton(type: .custom)
    
    let disposeBag = DisposeBag()
    var selectPhotoBtnClickBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        clipsToBounds = true
        //
        addSubview(horMiroorView)
        horMiroorView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        horMiroorView.addSubview(verMiroorView)
        verMiroorView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        
        //
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.backgroundColor = .black
        verMiroorView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        //
        selectPhotoBtn
            .image(UIImage(named: "edit_ic_selectphoto"))
            .adhere(toSuperview: self)
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                self.selectPhotoBtnClickBlock?()
            })
            .disposed(by: disposeBag)
        
        selectPhotoBtn.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
    }
    
    func updateViewStatus(isEmpty: Bool) {
        if isEmpty {
            contentImgV.image = nil
            selectPhotoBtn
                .image(UIImage(named: "edit_ic_selectphoto"))
        } else {
            selectPhotoBtn
                .image(nil)
            
        }
    }
    
    func updateContentImg(img: UIImage?) {
        if let img_r = img {
            contentImgV.image = img_r
            updateViewStatus(isEmpty: false)
        } else {
            updateViewStatus(isEmpty: true)
        }
    }
    
    func horMirrorAction(isMirror: Bool) {
        if isMirror {
            horMiroorView.transform = CGAffineTransform.init(scaleX: -1, y: 1)
        } else {
            horMiroorView.transform = CGAffineTransform.identity
        }
    }
    
    func verMirrorAction(isMirror: Bool) {
        if isMirror {
            verMiroorView.transform = CGAffineTransform.init(scaleX: 1, y: -1)
        } else {
            verMiroorView.transform = CGAffineTransform.identity
        }
    }
    
    
}
