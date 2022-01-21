//
//  AmplitudeManager.swift
//  Nursing
//
//  Created by Андрей Чернышев on 21.01.2022.
//

import Amplitude_iOS
import OtterScaleiOS

final class AmplitudeManager {
    enum Constants {
        static let userIdListKey = "amplitude_manager_core_user_id_list_key"
    }
    
    static let shared = AmplitudeManager()
    
    private init() {}
}

// MARK: OtterScaleReceiptValidationDelegate
extension AmplitudeManager: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: PaymentData?) {
        let otterScaleID = OtterScale.shared.getOtterScaleID()
        
        set(userId: otterScaleID)
    }
}

// MARK: Public
extension AmplitudeManager {
    func initialize() {
        Amplitude.instance().initializeApiKey(GlobalDefinitions.amplitudeApiKey)
        
        installFirstLaunchIfNeeded()
    }
    
    func set(userId: String) {
        let logTag = String(format: "%@_%@", GlobalDefinitions.applicationTag, userId)
        
        Amplitude.instance()?.setUserId(logTag)
    }
    
    func logEvent(name: String, parameters: [String: Any] = [:]) {
        var dictionary = parameters
        dictionary["app"] = GlobalDefinitions.applicationTag
        
        Amplitude.instance()?.logEvent(name, withEventProperties: dictionary)
    }
}

// MARK: Private
private extension AmplitudeManager {
    func installFirstLaunchIfNeeded() {
        guard NumberLaunches().isFirstLaunch() else {
            return
        }
        
        logEvent(name: "First Launch")
    }
    
    func syncedUserIdIfNeeded(_ userId: Int) {
        var userIdList = UserDefaults.standard.array(forKey: Constants.userIdListKey) as? [Int] ?? [Int]()
        
        if !userIdList.contains(userId) {
            logEvent(name: "UserIDSynced")
            
            userIdList.append(userId)
            
            UserDefaults.standard.set(userIdList, forKey: Constants.userIdListKey)
        }
    }
}
