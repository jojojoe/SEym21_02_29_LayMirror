//
//  LMyLayoutMirrorEffectView.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit
import RxSwift

class LMyLayoutMirrorEffectView: UIView {
    let disposeBag = DisposeBag()
    var backBtnClickBlock: (()->Void)?
    
    var horClickStatusBlock: ((Bool)->Void)?
    var verClickStatusBlock: ((Bool)->Void)?
    
    let horBtn = UIButton(type: .custom)
    let verBtn = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let backBtn = UIButton(type: .custom)
        backBtn
            .image(UIImage(named: "edit_ic_takeback"))
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                self.backBtnClickBlock?()
            })
            .disposed(by: disposeBag)
        
        addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
            $0.left.equalToSuperview()
        }
        //
        horBtn
            .image(UIImage(named: "layout_effect_unselect_2"), .normal)
            .image(UIImage(named: "layout_effect_select_2"), .selected)
            .adhere(toSuperview: self)
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                self.horBtn.isSelected = !self.horBtn.isSelected
                self.horClickStatusBlock?(self.horBtn.isSelected)
            })
            .disposed(by: disposeBag)
        
        horBtn.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(28)
            $0.right.equalTo(snp.centerX).offset(-30)
            $0.width.height.equalTo(54)
        }
        //
        verBtn
            .image(UIImage(named: "layout_effect_unselect_4"), .normal)
            .image(UIImage(named: "layout_effect_select_4"), .selected)
            .adhere(toSuperview: self)
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                self.verBtn.isSelected = !self.verBtn.isSelected
                self.verClickStatusBlock?(self.verBtn.isSelected)
            })
            .disposed(by: disposeBag)
        
        verBtn.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(28)
            $0.left.equalTo(snp.centerX).offset(30)
            $0.width.height.equalTo(54)
        }
        
        
        
    }
    
}
