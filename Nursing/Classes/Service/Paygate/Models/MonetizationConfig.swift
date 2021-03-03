//
//  MonetizationConfig.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.11.2020.
//

struct MonetizationConfig: Hashable {
    let afterOnboarding: Bool
}

// MARK: Codable
extension MonetizationConfig: Codable {}
