//
//  PushNotificationsManagerCore.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 22.10.2020.
//

import FirebaseMessaging

final class PushNotificationsManager: NSObject {
    static let shared = PushNotificationsManager()
    
    private let notificationsCenter = UNUserNotificationCenter.current()
    
    private var delegates = [Weak<PushNotificationsManagerDelegate>]()
    
    private override init() {}
}

// MARK: UNUserNotificationCenterDelegate
extension PushNotificationsManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        received(userInfo: response.notification.request.content.userInfo)
    }
}

// MARK: PushNotificationsManager(API)
extension PushNotificationsManager {
    @discardableResult
    func initialize() -> Bool {
        notificationsCenter.delegate = self
        
        return true
    }
    
    func retriveAuthorizationStatus(handler: ((PushNotificationsAuthorizationStatus) -> Void)?) {
        notificationsCenter.getNotificationSettings { settings in
            DispatchQueue.main.async { [weak self] in
                let result: PushNotificationsAuthorizationStatus
                
                switch settings.authorizationStatus {
                case .authorized:
                    result = .authorized
                case .notDetermined:
                    result = .notDetermined
                default:
                    result = .denied
                }
                
                handler?(result)
                self?.delegates.forEach { $0.weak?.pushNotificationsManagerDidReceive(authorizationStatus: result) }
            }
        }
    }
    
    func requestAuthorization() {
        notificationsCenter.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    self.delegates.forEach { $0.weak?.pushNotificationsManagerDidReceive(token: nil) }
                }
            }
        }
    }
}

// MARK: PushNotificationsManager(AppDelegate triggers)
extension PushNotificationsManager {
    func application(didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {}
    
    func application(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        received(pushToken: deviceToken, error: nil)
    }
    
    func application(didFailToRegisterForRemoteNotificationsWithError error: Error) {
        received(pushToken: nil, error: error)
    }
    
    func application(didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        received(userInfo: userInfo)
        
        completionHandler(.noData)
    }
}

// MARK: PushNotificationsManager(Observer)
extension PushNotificationsManager {
    func add(observer: PushNotificationsManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<PushNotificationsManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: PushNotificationsManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}

// MARK: Private
private extension PushNotificationsManager {
    func received(pushToken: Data?, error: Error?) {
        Messaging.messaging().apnsToken = pushToken
        
        DispatchQueue.main.async { [weak self] in
            if error == nil, let token = Messaging.messaging().fcmToken {
                self?.delegates.forEach { $0.weak?.pushNotificationsManagerDidReceive(token: token) }
            } else {
                self?.delegates.forEach { $0.weak?.pushNotificationsManagerDidReceive(token: nil) }
            }
        }
    }
    
    func received(userInfo: [AnyHashable : Any]) {
        let model = PushNotificationsModel(userInfo: userInfo)
        
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach { $0.weak?.pushNotificationsManagerDidReceive(model: model) }
        }
    }
}
