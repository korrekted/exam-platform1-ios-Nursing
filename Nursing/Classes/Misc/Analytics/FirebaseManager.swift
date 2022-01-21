//
//  FirebaseManager.swift
//  Nursing
//
//  Created by Андрей Чернышев on 21.01.2022.
//

import Firebase
import OtterScaleiOS

final class FirebaseManager {
    static let shared = FirebaseManager()
    
    private init() {}
}

// MARK: Public
extension FirebaseManager {
    @discardableResult
    func initialize() -> Bool {
        FirebaseApp.configure()
        
        OtterScale.shared.add(delegate: self)
        
        installFirstLaunchIfNeeded()
        
        return true
    }
}

// MARK: OtterScaleReceiptValidationDelegate
extension FirebaseManager: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: PaymentData?) {
        logEvent(name: "start_trial")
    }
}

// MARK: Private
private extension FirebaseManager {
    func logEvent(name: String, parameters: [String: Any] = [:]) {
        var dictionary = parameters
        dictionary["anonymous_id"] = OtterScale.shared.getOtterScaleID
        
        Analytics.logEvent(name, parameters: dictionary)
    }
    
    func installFirstLaunchIfNeeded() {
        guard NumberLaunches().isFirstLaunch() else {
            return
        }
        
        logEvent(name: "install_app")
    }
}
