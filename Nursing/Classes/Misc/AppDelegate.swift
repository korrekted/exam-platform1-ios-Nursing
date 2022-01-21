//
//  AppDelegate.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit
import OtterScaleiOS

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        NumberLaunches().launch()
        
        let vc = SplashViewController.make()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        FirebaseManager.shared.initialize()
        AmplitudeManager.shared.initialize()
        OtterScale.shared.initialize(host: "https://api.otterscale.com", apiKey: "oCrVwRgejQISV560")
        
        PurchaseValidationObserver.shared.startObserve()
        
        PushNotificationsManager.shared.application(didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushNotificationsManager.shared.application(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        PushNotificationsManager.shared.application(didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PushNotificationsManager.shared.application(didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
}
