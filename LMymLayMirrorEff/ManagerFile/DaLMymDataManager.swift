//
//  DaLMymDataManager.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/14.
//

import Foundation
import UIKit



class LMynARTDataManager {
    var layoutTypeList: [NEymEditToolItem] = []
    
    var bgColorList: [NEymEditToolItem] = []
    var bgColorImgList: [NEymEditToolItem] = []
    var stickerItemList: [NEymEditToolItem] = []
     

    static let `default` = LMynARTDataManager()
    
    init() {
        loadData()
    }
    
    func loadData() {
        
        bgColorList = loadJson([NEymEditToolItem].self, name: "bgColor") ?? []
        bgColorImgList = loadJson([NEymEditToolItem].self, name: "bgColorImg") ?? []
        stickerItemList = loadJson([NEymEditToolItem].self, name: "mirrorSticker") ?? []
        layoutTypeList = loadJson([NEymEditToolItem].self, name: "layoutStyleList") ?? []
        
    }
    
    
}


extension LMynARTDataManager {
    func loadJson<T: Codable>(_:T.Type, name: String, type: String = "json") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return try! JSONDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
        return nil
    }
    
    func loadJson<T: Codable>(_:T.Type, path:String) -> T? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            do {
                return try PropertyListDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func loadPlist<T: Codable>(_:T.Type, name:String, type:String = "plist") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            return loadJson(T.self, path: path)
        }
        return nil
    }
    
}



struct NEymEditToolItem: Codable, Hashable {
    static func == (lhs: NEymEditToolItem, rhs: NEymEditToolItem) -> Bool {
        return lhs.thumbName == rhs.thumbName
    }
    var thumbName: String = ""
    var bigName: String = ""
    var isPro: Bool = false
     
}

class GCPaintItem: Codable {
    let previewImageName : String
    let StrokeType : String
    let gradualColorOne : String
    let gradualColorTwo : String
    let isDashLine : Bool
    
    
}

//
//
//struct ShapeItem: Codable, Identifiable, Hashable {
//    static func == (lhs: ShapeItem, rhs: ShapeItem) -> Bool {
//        return lhs.id == rhs.id
//    }
//    var id: Int = 0
//    var thumbName: String = ""
//    var bigName: String = ""
//    var isPro: Bool = false
//
//}
//
//struct StickerItem: Codable, Identifiable, Hashable {
//    static func == (lhs: StickerItem, rhs: StickerItem) -> Bool {
//        return lhs.id == rhs.id
//    }
//    var id: Int = 0
//    var thumbName: String = ""
//    var bigName: String = ""
//    var isPro: Bool = false
//
//}
//
//struct BackgroundItem: Codable, Identifiable, Hashable {
//    static func == (lhs: BackgroundItem, rhs: BackgroundItem) -> Bool {
//        return lhs.id == rhs.id
//    }
//    var id: Int = 0
//    var thumbName: String = ""
//    var bigName: String = ""
//    var isPro: Bool = false
//
//}
//
//
