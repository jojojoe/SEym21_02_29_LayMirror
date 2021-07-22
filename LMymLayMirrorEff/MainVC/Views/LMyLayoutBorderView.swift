//
//  LMyLayoutBorderView.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit
import RxSwift


class LMyLayoutBorderView: UIView {
    let disposeBag = DisposeBag()
    var backBtnClickBlock: (()->Void)?
    var collectionCorner: UICollectionView!
    var collectionBorder: UICollectionView!
    var currentBorder: Int = 0
    var currentCorner: Int = 0
    
    var borderList_nor: [String] = []
    var borderList_sel: [String] = []
    var cornerList_nor: [String] = []
    var cornerList_sel: [String] = []
    
    var didSelectBorderIntmBlock: ((Int)->Void)?
    var didSelectCornerIntBlock: ((Int)->Void)?
    
    
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
        borderList_nor = ["border_ic_no", "border_unselect_1", "border_unselect_2", "border_unselect_3", "border_unselect_4"]
        borderList_sel = ["border_ic_no", "border_select_1", "border_select_2", "border_select_3", "border_select_4"]
        cornerList_nor = ["border_ic_no", "corner_unselect_1", "corner_unselect_2", "corner_unselect_3"]
        cornerList_sel = ["border_ic_no", "corner_select_1", "corner_select_2", "corner_select_3"]
        
    }
}


extension LMyLayoutBorderView {
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
        let layout_b = UICollectionViewFlowLayout()
        layout_b.scrollDirection = .horizontal
        collectionBorder = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout_b)
        collectionBorder.showsVerticalScrollIndicator = false
        collectionBorder.showsHorizontalScrollIndicator = false
        collectionBorder.backgroundColor = .clear
        collectionBorder.delegate = self
        collectionBorder.dataSource = self
        addSubview(collectionBorder)
        collectionBorder.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(5)
            $0.right.equalToSuperview()
            $0.left.equalTo(92)
            $0.height.equalTo(60)
        }
        collectionBorder.register(cellWithClass: LMLayouBorderCell.self)
        
        //collectionCorner
        let layout_c = UICollectionViewFlowLayout()
        layout_c.scrollDirection = .horizontal
        collectionCorner = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout_c)
        collectionCorner.showsVerticalScrollIndicator = false
        collectionCorner.showsHorizontalScrollIndicator = false
        collectionCorner.backgroundColor = .clear
        collectionCorner.delegate = self
        collectionCorner.dataSource = self
        addSubview(collectionCorner)
        collectionCorner.snp.makeConstraints {
            $0.top.equalTo(collectionBorder.snp.bottom).offset(18)
            $0.right.equalToSuperview()
            $0.left.equalTo(92)
            $0.height.equalTo(60)
        }
        collectionCorner.register(cellWithClass: LMLayouBorderCell.self)
        //
        let borderLabel = UILabel()
            .fontName(14, "Verdana-Bold")
            .color(UIColor.black)
            .text("Border")
            .adhere(toSuperview: self)
            .textAlignment(.left)
        borderLabel.adjustsFontSizeToFitWidth = true
        borderLabel.snp.makeConstraints {
            $0.centerY.equalTo(collectionBorder.snp.centerY)
            $0.left.equalTo(30)
            $0.width.equalTo(60)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        let cornerLabel = UILabel()
            .fontName(14, "Verdana-Bold")
            .color(UIColor.black)
            .text("Corner")
            .adhere(toSuperview: self)
            .textAlignment(.left)
        cornerLabel.adjustsFontSizeToFitWidth = true
        cornerLabel.snp.makeConstraints {
            $0.centerY.equalTo(collectionCorner.snp.centerY)
            $0.left.equalTo(30)
            $0.width.equalTo(60)
            $0.height.greaterThanOrEqualTo(1)
        }
    }

}


extension LMyLayoutBorderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionBorder {
            let cell = collectionView.dequeueReusableCell(withClass: LMLayouBorderCell.self, for: indexPath)
            
            var item = borderList_nor[indexPath.item]
            if currentBorder == indexPath.item {
                item = borderList_sel[indexPath.item]
            }
            cell.contentImgV.image = UIImage(named: item)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withClass: LMLayouBorderCell.self, for: indexPath)
            
            var item = cornerList_nor[indexPath.item]
            if currentCorner == indexPath.item {
                item = cornerList_sel[indexPath.item]
            }
            cell.contentImgV.image = UIImage(named: item)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionBorder {
            return borderList_nor.count
        } else {
            return cornerList_nor.count
        }
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LMyLayoutBorderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 54, height: 54)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
}

extension LMyLayoutBorderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionBorder {
            currentBorder = indexPath.item
            didSelectBorderIntmBlock?(currentBorder)
            
        } else {
            currentCorner = indexPath.item
            didSelectCornerIntBlock?(currentCorner)
        }
        
        collectionBorder.reloadData()
        collectionCorner.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}





class LMLayouBorderCell: UICollectionViewCell {
    let contentImgV = UIImageView()
//    let selectImgV = UIImageView()
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
//        //
//        selectImgV.isHidden = true
//        selectImgV.contentMode = .scaleAspectFill
//        selectImgV.image = UIImage(named: "edit_ic_choose")
//        selectImgV.clipsToBounds = true
//        contentView.addSubview(selectImgV)
//        selectImgV.snp.makeConstraints {
//            $0.width.height.equalTo(24)
//            $0.center.equalToSuperview()
//        }
//        //
    }
}
