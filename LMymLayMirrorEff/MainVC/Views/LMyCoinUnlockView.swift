//
//  LMyCoinUnlockView.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit
import RxSwift

class LMyCoinUnlockView: UIView {

    let disposeBag = DisposeBag()
    var backBtnClickBlock: (()->Void)?
    var okBtnClickBlock: (()->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        //
        let bgBtn = UIButton(type: .custom)
        bgBtn
            .image(UIImage(named: ""))
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                self.backBtnClickBlock?()
            })
            .disposed(by: disposeBag)
        
        addSubview(bgBtn)
        bgBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        let contentV = UIView()
            .backgroundColor(UIColor.clear)
        addSubview(contentV)
        contentV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.left.equalTo(30)
            $0.height.equalTo((UIScreen.width - 30 * 2) * 572/710 )
        }
        //
        let bgImgV = UIImageView()
            .image("costcoin_background")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: contentV)
        bgImgV.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        //
        let backBtn = UIButton(type: .custom)
        backBtn
            .image(UIImage(named: "ic_close"))
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                self.backBtnClickBlock?()
            })
            .disposed(by: disposeBag)
        
        contentV.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(contentV.snp.top).offset(10)
            $0.left.equalTo(contentV.snp.left).offset(10)
            $0.width.height.equalTo(44)
        }
        //
        
        let titLab = UILabel()
            .text("Paid items will be deducted \(LMymBCartCoinManager.default.coinCostCount) coins.")
            .textAlignment(.center)
            .numberOfLines(0)
            .fontName(22, "Verdana-Bold")
            .color(.white)
            .contentMode(.center)
        
        contentV.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(20)
            $0.left.equalTo(20)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        let okBtn = UIButton(type: .custom)
        okBtn.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 22)
        okBtn.setTitleColor(UIColor.black, for: .normal)
            
        okBtn
            .backgroundImage(UIImage(named: "costcoin_button_background"))
            .title("Continue")
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                self.okBtnClickBlock?()
            })
            .disposed(by: disposeBag)
        
        addSubview(okBtn)
        okBtn.snp.makeConstraints {
            $0.top.equalTo(contentV.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(276)
            $0.height.equalTo(72)
        }
        
//
        
    }
    
}
