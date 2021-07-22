//
//  LMyLayoutWatermarkOverlayer.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/16.
//

import UIKit

class LMyLayoutWatermarkOverlayer: UIView {

    var collection: UICollectionView!
    var currentWaterType: Int = 1
    var currentWaterText: String = "watermark"
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func udpateWaterType(waterType: Int) {
        currentWaterType = waterType
        collection.reloadData()
    }
    
    func udpateWaterText(waterText: String?) {
        if let text = waterText, text != "" {
            currentWaterText = text
        } else {
            currentWaterText = "watermark"
        }
        
        collection.reloadData()
    }
}

extension LMyLayoutWatermarkOverlayer {
    func setupView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
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
        collection.register(cellWithClass: LMyLayoutWatermarkOverlayerCell.self)
    }
    
}

extension LMyLayoutWatermarkOverlayer: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: LMyLayoutWatermarkOverlayerCell.self, for: indexPath)
        cell.contentView.alpha = 0.4
        cell.contentView.removeSubviews()
        
        if currentWaterType == 1 {
            
            let label = UILabel()
                .fontName(13, "Verdana-Bold")
                .numberOfLines(0)
                .color(UIColor.white)
                .textAlignment(.center)
                .text(currentWaterText)
                .adhere(toSuperview: cell.contentView)
            label.adjustsFontSizeToFitWidth = true
            label.snp.makeConstraints {
                $0.left.top.equalToSuperview().offset(4)
                $0.right.bottom.equalToSuperview().offset(-4)
            }
            
            
        } else if currentWaterType == 2 {
            let label = UILabel()
                .fontName(13, "Verdana-Bold")
                .numberOfLines(0)
                .color(UIColor.white)
                .textAlignment(.center)
                .text(currentWaterText)
                .adhere(toSuperview: cell.contentView)
            label.adjustsFontSizeToFitWidth = true
            label.snp.makeConstraints {
                $0.left.top.equalToSuperview().offset(4)
                $0.right.bottom.equalToSuperview().offset(-4)
            }
            label.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
            
        } else if currentWaterType == 3 {
            //
            let bgColorView = UIView()
                .backgroundColor(UIColor.white.withAlphaComponent(0.2))
                .adhere(toSuperview: cell.contentView)
            //
            let label = UILabel()
                .fontName(13, "Verdana-Bold")
                .numberOfLines(0)
                .color(UIColor.white)
                .textAlignment(.center)
                .text(currentWaterText)
                .adhere(toSuperview: cell.contentView)
            label.adjustsFontSizeToFitWidth = true
            label.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.lessThanOrEqualTo(cell.contentView.bounds.width - 20)
                $0.height.lessThanOrEqualTo(cell.contentView.bounds.height - 20)
            }
            
            
            //
            bgColorView.snp.makeConstraints {
                $0.left.top.equalTo(label).offset(-6)
                $0.bottom.right.equalTo(label).offset(6)
            }
            
            
            
        } else if currentWaterType == 4 {
            //
            let bgColorView = UIView()
                .backgroundColor(UIColor.white.withAlphaComponent(0.2))
                .adhere(toSuperview: cell.contentView)
            //
            let label = UILabel()
                .fontName(13, "Verdana-Bold")
                .numberOfLines(0)
                .color(UIColor.white)
                .textAlignment(.center)
                .text(currentWaterText)
                .adhere(toSuperview: cell.contentView)
            label.adjustsFontSizeToFitWidth = true
            label.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.lessThanOrEqualTo(cell.contentView.bounds.width - 20)
                $0.height.lessThanOrEqualTo(cell.contentView.bounds.height - 20)
            }
            label.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
            
            //
            bgColorView.snp.makeConstraints {
                $0.left.top.equalTo(label).offset(-6)
                $0.bottom.right.equalTo(label).offset(6)
            }
            bgColorView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
        } else if currentWaterType == 5 {
            let bgView = UIView()
            cell.contentView.addSubview(bgView)
            bgView.snp.makeConstraints {
                $0.left.top.right.bottom.equalToSuperview()
            }
            //
            let iconImgV = UIImageView(image: UIImage(named: "watermark_ic_1"))
                .contentMode(.scaleAspectFit)
            bgView.addSubview(iconImgV)
            iconImgV.snp.makeConstraints {
                $0.bottom.equalTo(bgView.snp.centerY).offset(-2)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(cell.bounds.width * (1/4))
            }
            //
            let label = UILabel()
                .fontName(13, "Verdana-Bold")
                .numberOfLines(0)
                .color(UIColor.white)
                .textAlignment(.center)
                .text(currentWaterText)
                .adhere(toSuperview: bgView)
            label.adjustsFontSizeToFitWidth = true
            label.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.lessThanOrEqualTo(cell.contentView.bounds.width - 20)
                $0.bottom.lessThanOrEqualTo(bgView.snp.bottom).offset(-5)
                $0.top.equalTo(bgView.snp.centerY).offset(2)
            }
            
        } else if currentWaterType == 6 {
            let bgView = UIView()
            cell.contentView.addSubview(bgView)
            bgView.snp.makeConstraints {
                $0.left.top.right.bottom.equalToSuperview()
            }
            //
            let iconImgV = UIImageView(image: UIImage(named: "watermark_ic_2"))
                .contentMode(.scaleAspectFit)
            bgView.addSubview(iconImgV)
            iconImgV.snp.makeConstraints {
                $0.bottom.equalTo(bgView.snp.centerY).offset(-2)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(cell.bounds.width * (1/4))
            }
            //
            let label = UILabel()
                .fontName(13, "Verdana-Bold")
                .numberOfLines(0)
                .color(UIColor.white)
                .textAlignment(.center)
                .text(currentWaterText)
                .adhere(toSuperview: bgView)
            label.adjustsFontSizeToFitWidth = true
            label.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.lessThanOrEqualTo(bounds.width - 20)
                $0.bottom.lessThanOrEqualTo(bgView.snp.bottom).offset(-5)
                $0.top.equalTo(bgView.snp.centerY).offset(2)
            }
            
            bgView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LMyLayoutWatermarkOverlayer: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (bounds.width - 0.5) / 3
        let height: CGFloat = (bounds.width - 0.5) / 3
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension LMyLayoutWatermarkOverlayer: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}



class LMyLayoutWatermarkOverlayerCell: UICollectionViewCell {
//    let contentImgV = UIImageView()
//    let labelBgView = UIView()
//    let textLabel = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
//        contentImgV.contentMode = .scaleAspectFill
//        contentImgV.clipsToBounds = true
//        contentView.addSubview(contentImgV)
//        contentImgV.snp.makeConstraints {
//            $0.top.right.bottom.left.equalToSuperview()
//        }
        
        
    }
}
