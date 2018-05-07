//
//  AppDelegate.swift
//  Flurry Push
//
//  Created by Don Huff on 5/3/18.
//  Copyright © 2018 Retail Success. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let builder = FlurrySessionBuilder()
            .withCrashReporting(true)
            .withLogLevel(FlurryLogLevelCriticalOnly)
        let apiKey = API_KEY_HERE
        Flurry.startSession(apiKey, with: builder)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: authOptions) { (granted, error) in
            guard granted,
                error == nil else {
                    assertionFailure()
                    let message: String
                    if let e = error {
                        message = String(describing: e)
                    } else {
                        message = "unknown"
                    }
                    NSLog("UNUserNotificationCenter authorization failed: \(message).")
                    return
            }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        
        return true
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NSLog("application(_:didReceiveRemoteNotification:fetchCompletionHandler:)")
        // our app saves notification data here
        completionHandler(.noData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let hex = deviceToken.reduce(into: "") { $0.append(String(format:"%02x", $1)) }
        NSLog("Remote notification device token: \(hex)")
        FlurryMessaging.setDeviceToken(deviceToken)
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard FlurryMessaging.isFlurryMsg(response.notification.request.content.userInfo) else {
            assertionFailure()
            return
        }
        
        NSLog("Calling FlurryMessaging.receivedNotificationResponse...")
        FlurryMessaging.receivedNotificationResponse(response) {
            NSLog("FlurryMessaging.receivedNotificationResponse complete.")
            completionHandler()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard FlurryMessaging.isFlurryMsg(notification.request.content.userInfo) else {
            assertionFailure()
            // present as an alert
            completionHandler(.alert)
            return
        }
        
        NSLog("Calling FlurryMessaging.present...")
        FlurryMessaging.present(notification) {
            NSLog("FlurryMessaging.present complete.")
            completionHandler(.alert)
        }
    }
    
}
