//
//  LMyMirrorEditCanvasView.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit

class LMyMirrorEditCanvasView: UIView {
    var originImg: UIImage
    
    var bgPatternImgV = UIImageView()
    var canvasBgView = UIView()
    var img_1 = UIImageView()
    var img_2 = UIImageView()
    var currentLayoutType: Int = 0
    
    
    init(frame: CGRect, originImg: UIImage) {
        self.originImg = originImg
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension LMyMirrorEditCanvasView {
    func setupView() {
        addSubview(bgPatternImgV)
        bgPatternImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        canvasBgView.layer.masksToBounds = true
        addSubview(canvasBgView)
        canvasBgView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        img_1.image = originImg
        img_1.layer.masksToBounds = true
        img_1.contentMode = .scaleAspectFill
        canvasBgView.addSubview(img_1)
        
        //
        img_2.image = originImg
        img_2.layer.masksToBounds = true
        img_2.contentMode = .scaleAspectFill
        canvasBgView.addSubview(img_2)
        
        updateCanvasImgVLayout(layoutType: 0)
        updateBorder(borderPersent: 0.2)
    }
    
    func updateCanvasImgVLayout(layoutType: Int) {
        currentLayoutType = layoutType
        
        if currentLayoutType == 0 {
            img_1.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
            img_2.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        } else {
            img_1.frame = CGRect(x: 0, y: 0, width: bounds.width/2, height: bounds.height)
            img_2.frame = CGRect(x: bounds.width/2, y: 0, width: bounds.width/2, height: bounds.height)
            
            if currentLayoutType == 1 {
                img_1.transform = CGAffineTransform.identity
                img_2.transform = CGAffineTransform(scaleX: -1, y: 1)
            } else if currentLayoutType == 2 {
                img_1.transform = CGAffineTransform(scaleX: -1, y: 1)
                img_2.transform = CGAffineTransform.identity
            } else if currentLayoutType == 3 {
                img_1.transform = CGAffineTransform(scaleX: -1, y: 1)
                img_2.transform = CGAffineTransform(scaleX: -1, y: 1)
            } else if currentLayoutType == 4 {
                img_1.transform = CGAffineTransform.identity
                img_2.transform = CGAffineTransform(scaleX: 1, y: -1)
            }
        }
    }
    
    func updateBgColor(bgColor: UIColor?, bgPatternImgName: String?) {
        if let bgColor_m = bgColor {
            bgPatternImgV.image = nil
            bgPatternImgV.backgroundColor = bgColor_m
        }
        if let bgPatternImgName_m = bgPatternImgName  {
            bgPatternImgV.image = UIImage(named: bgPatternImgName_m)
        }
    }
    
    func updateBorder(borderPersent: Float) {
        let border = borderPersent
        canvasBgView.transform = CGAffineTransform(scaleX: (1 - border.cgFloat/2), y: 1 - border.cgFloat/2)
    }
    
    func updateCorner(cornerPersent: Float) {
        canvasBgView.layer.cornerRadius = (bounds.width/2 ) * cornerPersent.cgFloat
    }
    
     
}
