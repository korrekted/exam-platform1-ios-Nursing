//
//  MonetizationConfig.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.11.2020.
//

struct MonetizationConfig: Hashable {
    let afterOnboarding: ModeAfterOnboarding
}

// MARK: Codable
extension MonetizationConfig: Codable {}

// MARK: ModeAfterOnboarding
extension MonetizationConfig {
    enum ModeAfterOnboarding: String, Codable {
        case block
        case suggest
    }
}
