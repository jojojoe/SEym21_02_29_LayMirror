//
//  AppDelegate.swift
//  LMymLayMirrorEff
//
//  Created by JOJO on 2021/7/14.
//

import UIKit
import Adjust
import SwiftyStoreKit
import FirebaseMessaging
import FirebaseInstanceID
import AdSupport
import AppTrackingTransparency
import AppsFlyerLib



// he /*
// com.xinyu.test.888888
// com.Piceffect.FansMirror
enum AdjustKey: String {
    case AdjustKeyAppToken = "zn4rk370n01s"
    case AdjustKeyAppLaunch = "yx5o02"
    case AdjustKeyAppCoinsBuy = "o6zic4"
    case AdjustUserDefaultTrackerName = "udTrackerName"
    case AdjustNotiTrackerName = "notiNotiTrackerName"
}

enum MCorArsConfig: String {
    case HilighCore_BundlId_testBuild = "com.xinyu.test.888888"
    case HilighCore_BundlId = "com.testbase.www"
            //"com.Piceffect.FansMirror"
    case HilighCoreCoreLink = "https://hishape.site/new/"
    case flyerDevKey = "2nhkNASc2eUJM2U3WAvYHS"
    case flyerAppID = "1577327943"
}

extension AppDelegate: AdjustDelegate {
    func adjustAttributionChanged(_ attribution: ADJAttribution?) {
        UserDefaults.standard.setValue(attribution?.trackerName, forKey: AdjustKey.AdjustUserDefaultTrackerName.rawValue)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AdjustKey.AdjustNotiTrackerName.rawValue), object: nil)
      
        
    }
    func initAdjust() {
        // he /*
        let ajconfig = ADJConfig(appToken: AdjustKey.AdjustKeyAppToken.rawValue, environment: ADJEnvironmentProduction)
        ajconfig?.delegate = self
        Adjust.appDidLaunch(ajconfig)
        Adjust.trackEvent(ADJEvent(eventToken: AdjustKey.AdjustKeyAppLaunch.rawValue))
        
        // he */
    }
    
}

// 核里面 AdjustConfig.json 也要填
// 测试 进 ID com.testbase.www
// he */


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var deviceTokenStr: String = ""
    
    var window: UIWindow?
    var mainVC: LMyMainVC = LMyMainVC()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LoginMNG.fireAppInit()
        
        // he /*
        initCore()
        // he */
        
//        APLoginMana.fireAppInit()
        setupFirebaseMessage()
        setupIAP()
        initMainVC()
        
        /* // 改为在核里请求
        
 */
        trackeringAuthor()
        registerNotifications(application)
        
        return true
    }
    
    
    func initCore() {
        // he /*
       
//        com.emoinji.IgtextC
        
        
        NotificationCenter.default.post(name: .water,
                                        object: [
                                            HightLigtingHelper.default.flyerDevKey = MCorArsConfig.flyerDevKey.rawValue,
                                            HightLigtingHelper.default.flyerAppID = MCorArsConfig.flyerAppID.rawValue,
                                            HightLigtingHelper.default.debugBundleIdentifier = MCorArsConfig.HilighCore_BundlId.rawValue,
                                            HightLigtingHelper.default.setProductUrl(string: MCorArsConfig.HilighCoreCoreLink.rawValue)])
        
        
        // he */
    }
    
    
    func initMainVC() {
        let nav = UINavigationController.init(rootViewController: mainVC)
        nav.isNavigationBarHidden = true
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        #if DEBUG
        for fy in UIFont.familyNames {
            let fts = UIFont.fontNames(forFamilyName: fy)
            for ft in fts {
                debugPrint("***fontName = \(ft)")
            }
        }
        #endif
    }

    func setupIAP() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
    }
    
    
    
    func trackeringAuthor() {
       
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: {[weak self] status in
                guard let `self` = self else {return}
                self.initAdjust()
            })
        }
    }
    
 
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
         
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
         
    }


    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        LoginMNG.receivesAuthenticationProcess(url: url, options: options)
        AFlyerLibManage.flyerLibHandleOpen(url: url, options: options)
        
        return true
    }
    
    func setupFirebaseMessage() {
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = false
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
          }
        }
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
//            self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
          }
        }
    }
    
    // Appsflyer
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Start the SDK (start the IDFA timeout set above, for iOS 14 or later)
//        AppFlyerEventManager.default.flyerLibStart()
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AFlyerLibManage.flyerLibContinue(userActivity: userActivity)
        
        return true
    }
    
    // Open Deeplinks
    // Open URI-scheme for iOS 9 and above
    
    
    // Report Push Notification attribution data for re-engagements
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AFlyerLibManage.flyerLibHandlePushNotification(userInfo: userInfo)
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let body = notification.request.content.body
        notification.request.content.userInfo
        print(body)
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("222222")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
    
    
}




extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        debugPrint("Firebase registration token: \(fcmToken)")
        if let fcmToken_m = fcmToken {
            let dataDict:[String: String] = ["token": fcmToken_m]
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        }
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        AppDelegate.deviceTokenStr = deviceTokenString(deviceToken: deviceToken)
        
    }
    
    func deviceTokenString(deviceToken: Data) -> String {
        var deviceTokenString = String()
        let bytes = [UInt8](deviceToken)
        for item in bytes {
            deviceTokenString += String(format:"%02x", item&0x000000FF)
        }
        return deviceTokenString
    }
}

extension AppDelegate {
    // 注册远程推送通知
    func registerNotifications(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.getNotificationSettings { (setting) in
            if setting.authorizationStatus == .notDetermined {
                center.requestAuthorization(options: [.badge,.sound,.alert]) { (result, error) in
                    if (result) {
                        if !(error != nil) {
                            // 注册成功
                            DispatchQueue.main.async {
                                application.registerForRemoteNotifications()
                            }
                        }
                    } else {
                        //用户不允许推送
                    }
                }
            } else if (setting.authorizationStatus == .denied){
                // 申请用户权限被拒
            } else if (setting.authorizationStatus == .authorized){
                // 用户已授权（再次获取dt）
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                // 未知错误
            }
        }
    }
}
