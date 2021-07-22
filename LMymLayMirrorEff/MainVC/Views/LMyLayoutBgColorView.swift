//
//  LMyLayoutBgColorView.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/15.
//

import UIKit
import RxSwift

class LMyLayoutBgColorView: UIView {
    let disposeBag = DisposeBag()
    var backBtnClickBlock: (()->Void)?
    var collectionColor: UICollectionView!
    var collectionBgImg: UICollectionView!
    var currentSelectItem: NEymEditToolItem?
    var didSelectBgItemBlock:((NEymEditToolItem, _ isPro: Bool)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}
extension LMyLayoutBgColorView {
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
        let layout_c = UICollectionViewFlowLayout()
        layout_c.scrollDirection = .horizontal
        collectionColor = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout_c)
        collectionColor.showsVerticalScrollIndicator = false
        collectionColor.showsHorizontalScrollIndicator = false
        collectionColor.backgroundColor = .clear
        collectionColor.delegate = self
        collectionColor.dataSource = self
        addSubview(collectionColor)
        collectionColor.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(5)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(60)
        }
        collectionColor.register(cellWithClass: LMLayouBgColorImgCell.self)
        
        
        let layout_i = UICollectionViewFlowLayout()
        layout_i.scrollDirection = .horizontal
        collectionBgImg = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout_i)
        collectionBgImg.showsVerticalScrollIndicator = false
        collectionBgImg.showsHorizontalScrollIndicator = false
        collectionBgImg.backgroundColor = .clear
        collectionBgImg.delegate = self
        collectionBgImg.dataSource = self
        addSubview(collectionBgImg)
        collectionBgImg.snp.makeConstraints {
            $0.top.equalTo(collectionColor.snp.bottom).offset(18)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(60)
        }
        collectionBgImg.register(cellWithClass: LMLayouBgColorImgCell.self)
    }
}


extension LMyLayoutBgColorView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var item = LMynARTDataManager.default.bgColorImgList[indexPath.item]
        
        if collectionView == collectionColor {
            item = LMynARTDataManager.default.bgColorList[indexPath.item]
        }
        let cell = collectionView.dequeueReusableCell(withClass: LMLayouBgColorImgCell.self, for: indexPath)
        cell.contentImgV.image = UIImage(named: item.thumbName)
        if currentSelectItem?.thumbName == item.thumbName {
            cell.selectImgV.isHidden = false
        } else {
            cell.selectImgV.isHidden = true
        }
        if item.isPro && !LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbName) {
            cell.vipImgV.isHidden = false
        } else {
            cell.vipImgV.isHidden = true
        }
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionColor {
            return LMynARTDataManager.default.bgColorList.count

        } else {
            return             LMynARTDataManager.default.bgColorImgList.count
            
        }
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LMyLayoutBgColorView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 55, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
}

extension LMyLayoutBgColorView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var item = LMynARTDataManager.default.bgColorImgList[indexPath.item]
        
        if collectionView == collectionColor {
            item = LMynARTDataManager.default.bgColorList[indexPath.item]
        }
        
        var isPro = false
        
        if item.isPro && !LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbName) {
            isPro = true
        } else {
            currentSelectItem = item
            collectionColor.reloadData()
            collectionBgImg.reloadData()
        }
        didSelectBgItemBlock?(item, isPro)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}








class LMLayouBgColorImgCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let selectImgV = UIImageView()
    let vipImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        //
        selectImgV.isHidden = true
        selectImgV.contentMode = .scaleAspectFill
        selectImgV.image = UIImage(named: "edit_ic_choose")
        selectImgV.clipsToBounds = true
        contentView.addSubview(selectImgV)
        selectImgV.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.center.equalToSuperview()
        }
        //
        //
        vipImgV.image = UIImage(named: "watermark_ic_lock")
        vipImgV.contentMode = .scaleAspectFill
        vipImgV.clipsToBounds = true
        contentView.addSubview(vipImgV)
        vipImgV.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(-1)
            $0.width.equalTo(58/2)
            $0.height.equalTo(34/2)
            
        }
    }
}

