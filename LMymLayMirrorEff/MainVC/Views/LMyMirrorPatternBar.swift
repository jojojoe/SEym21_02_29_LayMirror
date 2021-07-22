//
//  LMyMirrorPatternBar.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit

class LMyMirrorPatternBar: UIView {

    var collection: UICollectionView!
    var currentPatternItem: NEymEditToolItem?
    var clickPatternBlock: ((NEymEditToolItem, Bool)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LMyMirrorPatternBar {
    func setupView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: LMyMirrorPatternCell.self)
    }
}

extension LMyMirrorPatternBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: LMyMirrorPatternCell.self, for: indexPath)
        
        let item = LMynARTDataManager.default.bgColorImgList[indexPath.item]
        cell.iconImgV.image = UIImage(named: item.thumbName)
        if !item.isPro || LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbName) {
            cell.vipImgV.isHidden = true
        } else {
            cell.vipImgV.isHidden = false
        }
        if currentPatternItem == item {
            cell.selectImgV.isHidden = false
        } else {
            cell.selectImgV.isHidden = true
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LMynARTDataManager.default.bgColorImgList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LMyMirrorPatternBar: UICollectionViewDelegateFlowLayout {
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

extension LMyMirrorPatternBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = LMynARTDataManager.default.bgColorImgList[indexPath.item]
        if !item.isPro || LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbName) {
            currentPatternItem = item
            collectionView.reloadData()
            clickPatternBlock?(item, false)
        } else {
            clickPatternBlock?(item, true)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}







class LMyMirrorPatternCell: UICollectionViewCell {
    
    var iconImgV = UIImageView()
    var selectImgV = UIImageView()
    var vipImgV = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        iconImgV.contentMode = .scaleAspectFit
        contentView.addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        selectImgV.contentMode = .scaleAspectFit
        selectImgV.image = UIImage(named: "edit_ic_choose")
        contentView.addSubview(selectImgV)
        selectImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        //
        vipImgV.contentMode = .scaleAspectFit
        vipImgV.image = UIImage(named: "watermark_ic_lock")
        contentView.addSubview(vipImgV)
        vipImgV.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(-2)
            $0.width.equalTo(28)
            $0.height.equalTo(16)
        }
        
        
    }
    
    
    
}


