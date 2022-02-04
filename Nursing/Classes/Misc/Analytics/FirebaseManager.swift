//
//  FirebaseManager.swift
//  NCLEX
//
//  Created by Андрей Чернышев on 03.02.2022.
//

import Firebase
import OtterScaleiOS
import StoreKit

final class FirebaseManager: NSObject {
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    static let shared = FirebaseManager()
    
    private override init() {
        super.init()
    }
}

// MARK: OtterScaleReceiptValidationDelegate
extension FirebaseManager: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: PaymentData?) {
        let otterScaleID = OtterScale.shared.getInternalID()
        set(userId: otterScaleID)
        
        logEvent(name: "[Client] User ID Synced")
    }
}

// MARK: SKPaymentTransactionObserver
extension FirebaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        let purchased = transactions
            .filter { $0.transactionState == .purchased }
        
        guard !purchased.isEmpty else {
            return
        }
        
        logEvent(name: "[Client] Subscription Or Purchase")
    }
}

// MARK: Public
extension FirebaseManager {
    func initialize() {
        FirebaseApp.configure()
        
        OtterScale.shared.add(delegate: self)
        SKPaymentQueue.default().add(self)
        
        installFirstLaunchIfNeeded()
    }
    
    func set(userId: String) {
        Analytics.setUserID(userId)
    }
    
    func logEvent(name: String, parameters: [String: Any] = [:]) {
        Analytics.logEvent(name, parameters: parameters)
    }
}

// MARK: Private
private extension FirebaseManager {
    func installFirstLaunchIfNeeded() {
        guard NumberLaunches().isFirstLaunch() else {
            return
        }
        
        logEvent(name: "[Client] First Launch")
    }
}
