//
//  LMyLayoutWaterMarkBar.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit
import RxSwift

class LMyLayoutWaterMarkBar: UIView {
    let disposeBag = DisposeBag()
    var backBtnClickBlock: (()->Void)?
    let textEnterBtn = UIButton(type: .custom)
    let horBtn = UIButton(type: .custom)
    let verBtn = UIButton(type: .custom)
    
    var collection: UICollectionView!
    var list: [String] = []
    var currentWaterItemIndex: Int?
    
    var enterWaterMarkClickBlock: (()->Void)?
    
    var selectWaterMarkClickBlock: ((Int, Bool, String)->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        loadData()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData() {
        list = ["watermark_cancel", "watermark1", "watermark2", "watermark3", "watermark4", "watermark5", "watermark6"]
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
        
        textEnterBtn
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                self.enterWaterMarkClickBlock?()
            })
            .disposed(by: disposeBag)
        textEnterBtn.titleColor(UIColor.black)
        textEnterBtn.title("Please enter your text…")
        textEnterBtn.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 12)
        textEnterBtn.layer.borderWidth = 3
        textEnterBtn.layer.borderColor = UIColor.black.cgColor
        textEnterBtn.layer.cornerRadius = 56/2
        textEnterBtn.contentHorizontalAlignment = .left
        textEnterBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        
        
        addSubview(textEnterBtn)
        textEnterBtn.snp.makeConstraints {
            $0.left.equalTo(30)
            $0.top.equalTo(backBtn.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        //
        
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
            $0.top.equalTo(textEnterBtn.snp.bottom).offset(18)
            $0.height.equalTo(72)
            $0.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: LMLayouWatermarkBarCell.self)
        
        
        
    }
    
    func updateEnterTextStr(textStr: String?) {
        if let text = textStr, text != "" {
            textEnterBtn.setTitle(text, for: .normal)
        } else {
            textEnterBtn.setTitle("Enter Text Here...", for: .normal)
        }
        
    }
    
}

extension LMyLayoutWaterMarkBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: LMLayouWatermarkBarCell.self, for: indexPath)
        let item = list[indexPath.item]
        cell.contentImgV.image = UIImage(named: item)
        if indexPath.item == 0 {
            cell.selectImgV.isHidden = true
        } else {
            if currentWaterItemIndex == indexPath.item {
                cell.selectImgV.isHidden = false
            } else {
                cell.selectImgV.isHidden = true
            }
        }
        
        if indexPath.item < 3 || LMymContentUnlockManager.default.hasUnlock(itemId: item) {
            cell.vipImgV.isHidden = true
        } else {
            cell.vipImgV.isHidden = false
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LMyLayoutWaterMarkBar: UICollectionViewDelegateFlowLayout {
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

extension LMyLayoutWaterMarkBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = list[indexPath.item]
        var isPro = true
        
        if indexPath.item < 3 || LMymContentUnlockManager.default.hasUnlock(itemId: item) {
            currentWaterItemIndex = indexPath.item
            isPro = false
        }
        collectionView.reloadData()
        selectWaterMarkClickBlock?(indexPath.item, isPro, item)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}




class LMLayouWatermarkBarCell: UICollectionViewCell {
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
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        //
        selectImgV.isHidden = true
        selectImgV.contentMode = .scaleAspectFill
        selectImgV.image = UIImage(named: "watermark_ic_choose")
        selectImgV.clipsToBounds = true
        contentView.addSubview(selectImgV)
        selectImgV.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.center.equalToSuperview()
        }
        //
        vipImgV.image = UIImage(named: "watermark_ic_lock")
        vipImgV.contentMode = .scaleAspectFill
        vipImgV.clipsToBounds = true
        contentView.addSubview(vipImgV)
        vipImgV.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(-0.5)
            $0.width.equalTo(58/2)
            $0.height.equalTo(34/2)
            
        }
    }
}


