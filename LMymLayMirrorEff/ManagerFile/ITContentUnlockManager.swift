//
//  LMymContentUnlockManager.swift
//  WIymWidgetsforIn
//
//  Created by JOJO on 2021/4/19.
//

import Foundation
import SwiftyJSON


class LMymContentUnlockManager: NSObject {
    static let `default` = LMymContentUnlockManager()
    var k_ud_unlockName = "k_ud_unlockName"
    
    let freeList: [String] = ["muban_img_1_s", "muban_img_2_s", "muban_img_1_m", "muban_img_2_m", "muban_1_l", "muban_2_l"]
    
    func hasUnlock(itemId: String) -> Bool {
        var freeAndUnlockList: [String] = []
        
        
        freeAndUnlockList.append(contentsOf: freeList)
        
        let unlockJsonStr = UserDefaults.standard.value(forKey: k_ud_unlockName) as? String ?? ""
        do {
            let data = try JSON.init(parseJSON: unlockJsonStr).rawData()
            let model = try JSONDecoder().decode([String].self, from: data)
            freeAndUnlockList.append(contentsOf: model)
        } catch {

        }
        
        if freeAndUnlockList.contains(itemId) {
            return true
        }
        return false
    }
    
    
    func unlock(itemId: String, completion: (()->Void)) {
        if let unlockJsonStr = UserDefaults.standard.value(forKey: k_ud_unlockName) as? String {
            do {
                let data = try JSON.init(parseJSON: unlockJsonStr).rawData()
                let model = try JSONDecoder().decode([String].self, from: data)
                var unlockList_m = model
                unlockList_m.append(itemId)
                let jsonStr = unlockList_m.toString
                UserDefaults.standard.setValue(jsonStr, forKey: k_ud_unlockName)
                completion()
            } catch {
                
            }
        } else {
            let jsonStr = [itemId].toString
            UserDefaults.standard.setValue(jsonStr, forKey: k_ud_unlockName)
            completion()
        }   
    }
}
 
