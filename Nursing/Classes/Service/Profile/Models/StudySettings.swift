//
//  StudySettings.swift
//  Nursing
//
//  Created by Андрей Чернышев on 25.05.2022.
//

struct StudySettings: Codable, Hashable {
    private(set) var vibration: Bool
}

// MARK: Public
extension StudySettings {
    static var `default`: StudySettings {
        StudySettings(vibration: false)
    }
    
    mutating func set(vibration: Bool) {
        self.vibration = vibration
    }
}
