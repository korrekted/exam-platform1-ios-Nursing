//
//  FacebookManager.swift
//  NCLEX
//
//  Created by Андрей Чернышев on 03.02.2022.
//

import FBSDKCoreKit
import OtterScaleiOS
import StoreKit

final class FacebookManager: NSObject {
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    static let shared = FacebookManager()
    
    private override init() {
        super.init()
    }
}

// MARK: OtterScaleReceiptValidationDelegate
extension FacebookManager: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: PaymentData?) {
        let otterScaleID = OtterScale.shared.getInternalID()
        
        guard otterScaleID != OtterScale.shared.getAnonymousID() else {
            return
        }
        
        set(userID: otterScaleID)
        
        logEvent(name: "client_user_id_synced")
    }
}

// MARK: SKPaymentTransactionObserver
extension FacebookManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        let purchased = transactions
            .filter { $0.transactionState == .purchased }

        guard !purchased.isEmpty else {
            return
        }

        logEvent(name: "client_subscription_or_purchase")
    }
}

// MARK: Public
extension FacebookManager {
    func initialize(app: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(app, didFinishLaunchingWithOptions: launchOptions)
        
        AppEvents.shared.activateApp()
        
        OtterScale.shared.add(delegate: self)
        SKPaymentQueue.default().add(self)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) {
        ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func set(userID: String) {
        AppEvents.shared.userID = userID
    }
    
    func logEvent(name: String) {
        let eventName = AppEvents.Name(name)
        AppEvents.shared.logEvent(eventName)
    }
}
