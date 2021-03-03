//
//  OnboardingViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class OnboardingViewModel {
    private lazy var coursesManager = CoursesManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var monetizationManager = MonetizationManagerCore()
    
    var hasSelectedCourse: Bool {
        coursesManager.getSelectedCourse() != nil
    }
    
    func needPayment() -> Bool {
        let hasActiveSubscription = sessionManager.getSession()?.activeSubscription ?? false
        let needPayment = monetizationManager.getMonetizationConfig()?.afterOnboarding ?? false
        
        if hasActiveSubscription {
            return false
        }
        
        return needPayment
    }
}
