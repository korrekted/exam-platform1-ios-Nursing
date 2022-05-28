//
//  ReportValidationOverseer.swift
//  Nursing
//
//  Created by Андрей Чернышев on 28.05.2022.
//

final class ReportValidationOverseer {
    private let mainView: ReportView
    
    private var handler: ((Bool) -> Void)?
    
    init(mainView: ReportView) {
        self.mainView = mainView
    }
}

// MARK: 
extension ReportValidationOverseer {
    func startValidation() {
        mainView.emailField.isValid = { [weak self] in
            guard let self = self else {
                return true
            }
            
            let email = self.mainView.emailField.textField.text ?? ""
            return EmailRegex().isValid(email: email)
        }
        
        mainView.confirmEmailField.isValid = { [weak self] in
            guard let self = self else {
                return false
            }
            
            let email = self.mainView.emailField.textField.text ?? ""
            let confirmEmail = self.mainView.confirmEmailField.textField.text ?? ""
            
            let isValidConfirmEmail = EmailRegex().isValid(email: confirmEmail)
            let isEqual = email == confirmEmail
            
            return isValidConfirmEmail && isEqual
        }
    }
}
