//
//  AmplitudeManager.swift
//  Nursing
//
//  Created by Андрей Чернышев on 21.01.2022.
//

import Amplitude_iOS

final class AmplitudeManager {
    static let shared = AmplitudeManager()
    
    private init() {}
}

// MARK: Public
extension AmplitudeManager {
    func initialize() {
        Amplitude.instance().initializeApiKey(GlobalDefinitions.amplitudeApiKey)
    }
    
    func set(userId: Int) {
        let logTag = String(format: "%@_%i", GlobalDefinitions.applicationTag, userId)
        
        Amplitude.instance()?.setUserId(logTag)
    }
    
    func logEvent(name: String, parameters: [String: Any] = [:]) {
        var dictionary = parameters
        dictionary["app"] = GlobalDefinitions.applicationTag
        
        Amplitude.instance()?.logEvent(name, withEventProperties: dictionary)
    }
}
