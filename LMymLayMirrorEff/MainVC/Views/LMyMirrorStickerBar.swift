//
//  LMyMirrorStickerBar.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit

class LMyMirrorStickerBar: UIView {

    var collection: UICollectionView!
    var currentStickerItem: NEymEditToolItem?
    var clickStickerBlock: ((NEymEditToolItem, Bool)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LMyMirrorStickerBar {
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
        collection.register(cellWithClass: LMyMirrorStickerCell.self)
    }
}

extension LMyMirrorStickerBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: LMyMirrorStickerCell.self, for: indexPath)
        
        let item = LMynARTDataManager.default.stickerItemList[indexPath.item]
        cell.iconImgV.image = UIImage(named: item.thumbName)
        if !item.isPro || LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbName) {
            cell.vipImgV.isHidden = true
        } else {
            cell.vipImgV.isHidden = false
        }
//        if currentStickerItem == item {
//            cell.selectImgV.isHidden = false
//        } else {
//            cell.selectImgV.isHidden = true
//        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LMynARTDataManager.default.stickerItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LMyMirrorStickerBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72, height: 72)
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

extension LMyMirrorStickerBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = LMynARTDataManager.default.stickerItemList[indexPath.item]
        if !item.isPro || LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbName) {
            currentStickerItem = item
            collectionView.reloadData()
            clickStickerBlock?(item, false)
        } else {
            clickStickerBlock?(item, true)
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}







class LMyMirrorStickerCell: UICollectionViewCell {
    
    var iconImgV = UIImageView()
//    var selectImgV = UIImageView()
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
        
//        selectImgV.contentMode = .scaleAspectFit
//        selectImgV.image = UIImage(named: "edit_ic_choose")
//        addSubview(selectImgV)
//        selectImgV.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.width.height.equalTo(24)
//        }
        //
        vipImgV.contentMode = .scaleAspectFit
        vipImgV.image = UIImage(named: "watermark_ic_lock")
        contentView.addSubview(vipImgV)
        vipImgV.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.width.equalTo(28)
            $0.height.equalTo(16)
        }
        
        
    }
    
    
    
}


