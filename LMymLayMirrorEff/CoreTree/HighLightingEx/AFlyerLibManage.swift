//
//  AFlyerLibManage.swift
//  HighLighting
//
//  Created by 薛忱 on 2021/7/9.
//  Copyright © 2021 Charles. All rights reserved.
//

import UIKit
import AppsFlyerLib

class AFlyerLibManage: NSObject, AppsFlyerLibDelegate {
    
    
    var appsFlyerDevKey = MCorArsConfig.flyerDevKey.rawValue
    var appleAppID = MCorArsConfig.flyerAppID.rawValue
    
    init(appsFlyerDevKey: String, appleAppID: String) {
        super.init()
        
        self.appsFlyerDevKey = appsFlyerDevKey
        self.appleAppID = appleAppID
        
        AppsFlyerLib.shared().appsFlyerDevKey = self.appsFlyerDevKey
        AppsFlyerLib.shared().appleAppID = self.appleAppID
        AppsFlyerLib.shared().delegate = self
        /* Set isDebug to true to see AppsFlyer debug logs */
        if UIApplication.shared.inferredEnvironment == .debug {
            AppsFlyerLib.shared().isDebug = true
        }
        
        if let _ = UserDefaults.standard.dictionary(forKey: "AppsFlyerLib") {
            NotificationCenter.default.post(name: .notificationPostAFlyerLib, object: nil)
        }
        
        AppsFlyerLib.shared().start()
    }
    
    func getAppsFlyerUID() -> String {
        return AppsFlyerLib.shared().getAppsFlyerUID()
    }
    
    @objc func sendLaunch() {
        AppsFlyerLib.shared().start()
    }
    
    static func flyerLibContinue(userActivity: NSUserActivity) {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
    }
    
    static func flyerLibHandleOpen(url: URL, options: [UIApplication.OpenURLOptionsKey : Any]? = [:]) {
        AppsFlyerLib.shared().handleOpen(url, options: options)
    }
    
    static func flyerLibHandlePushNotification(userInfo: [AnyHashable : Any]) {
        AppsFlyerLib.shared().handlePushNotification(userInfo)
    }
    
   // AppsFlyerLibDelegate --
   // Handle Organic/Non-organic installation
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        let source: [String : Any] = installData as? [String : Any] ?? [:]
        print("onConversionDataSuccess data:")
        for (key, value) in installData {
            print(key, ":", value)
        }
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = installData["media_source"],
                   let campaign = installData["campaign"] {
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
            if let is_first_launch = installData["is_first_launch"] as? Bool,
               is_first_launch {
                print("First Launch")
            } else {
                print("Not First Launch")
            }
        }
        
        UserDefaults.standard.setValue(source, forKey: "AppsFlyerLib")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: .notificationPostAFlyerLib, object: nil)
    }
    
    static func getConversionDataSuccess() -> [String: Any] {
        let value = UserDefaults.standard.dictionary(forKey: "AppsFlyerLib")
        return value ?? [:]
    }
    
    func onConversionDataFail(_ error: Error) {
        
        print("onConversionDataFail -- " + error.localizedDescription)

    }
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        print("onAppOpenAttribution -- ")
        print(attributionData)
    }
    func onAppOpenAttributionFailure(_ error: Error) {
        print("onAppOpenAttributionFailure -- " + error.localizedDescription)
    }    
    
    
    // event log
    //成功购买
    static func event_PurchaseSuccessAll(symbolType: String, needMoney: Float, iapId: String) {
        
        AppsFlyerLib.shared().logEvent("pi_purchase",
                                       withValues: [
                                        AFEventParamContent  : symbolType,
                                        AFEventParamRevenue  : needMoney,
                                        AFEventParamContentId: iapId])
    }
    
    static func event_LaunchApp() {
        AppsFlyerLib.shared().logEvent("pi_launch", withValues: nil)
    }
    
    static func event_login_button_1stclick() {
        AppsFlyerLib.shared().logEvent("login_button_1stclick", withValues: nil)
    }
    
    static func event_login_button_click_total() {
        AppsFlyerLib.shared().logEvent("login_button_click_total", withValues: nil)
    }
    
}
