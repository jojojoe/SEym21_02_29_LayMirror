//
//  LMyMirrorEffectBar.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit
import RxSwift

class LMyMirrorEffectBar: UIView {

    let mirrorBtn1 = UIButton(type: .custom)
    let mirrorBtn2 = UIButton(type: .custom)
    let mirrorBtn3 = UIButton(type: .custom)
    let mirrorBtn4 = UIButton(type: .custom)
    
    let disposeBag = DisposeBag()
    
    var clickMirrorTypeBlock: ((Int)->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let left: CGFloat = 10
        let btnW: CGFloat = 54
        let btnH: CGFloat = 54
        let padding: CGFloat = (UIScreen.width - left * 2 - btnW * 4) / 5
        
        mirrorBtn1
            .image(UIImage(named: "effect_unselect_1"), .normal)
            .image(UIImage(named: "effect_select_1"), .selected)
            .adhere(toSuperview: self)
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.clickMirrorTypeBlock?(1)
                    self.mirrorBtn1.isSelected = true
                    self.mirrorBtn2.isSelected = false
                    self.mirrorBtn3.isSelected = false
                    self.mirrorBtn4.isSelected = false
                }
            })
            .disposed(by: disposeBag)
        mirrorBtn1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(btnW)
            $0.left.equalTo(left + padding)
        }
        
        
        mirrorBtn2
            .image(UIImage(named: "effect_unselect_2"), .normal)
            .image(UIImage(named: "effect_select_2"), .selected)
            .adhere(toSuperview: self)
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.clickMirrorTypeBlock?(2)
                    self.mirrorBtn1.isSelected = false
                    self.mirrorBtn2.isSelected = true
                    self.mirrorBtn3.isSelected = false
                    self.mirrorBtn4.isSelected = false
                }
            })
            .disposed(by: disposeBag)
        mirrorBtn2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(btnW)
            $0.left.equalTo(mirrorBtn1.snp.right).offset(padding)
        }
        
        mirrorBtn3
            .image(UIImage(named: "effect_unselect_3"), .normal)
            .image(UIImage(named: "effect_select_3"), .selected)
            .adhere(toSuperview: self)
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                
                DispatchQueue.main.async {
                    self.clickMirrorTypeBlock?(3)
                    self.mirrorBtn1.isSelected = false
                    self.mirrorBtn2.isSelected = false
                    self.mirrorBtn3.isSelected = true
                    self.mirrorBtn4.isSelected = false
                }
            })
            .disposed(by: disposeBag)
        mirrorBtn3.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(btnW)
            $0.left.equalTo(mirrorBtn2.snp.right).offset(padding)
        }
        
        mirrorBtn4
            .image(UIImage(named: "effect_unselect_4"), .normal)
            .image(UIImage(named: "effect_select_4"), .selected)
            .adhere(toSuperview: self)
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                
                DispatchQueue.main.async {
                    self.clickMirrorTypeBlock?(4)
                    self.mirrorBtn1.isSelected = false
                    self.mirrorBtn2.isSelected = false
                    self.mirrorBtn3.isSelected = false
                    self.mirrorBtn4.isSelected = true
                }
            })
            .disposed(by: disposeBag)
        mirrorBtn4.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(btnW)
            $0.left.equalTo(mirrorBtn3.snp.right).offset(padding)
        }
        
    }

}
