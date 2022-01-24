//
//  IAPError.swift
//  Nursing
//
//  Created by Андрей Чернышев on 24.01.2022.
//

struct IAPError: Error {
    enum Code {
        case paymentsDisabled
        case paymentFailed
        case cannotRestorePurchases
    }

    let code: Code
    let underlyingError: Error?

    init(_ code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}
