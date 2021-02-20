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
    
    var hasSelectedCourse: Bool {
        coursesManager.getSelectedCourse() != nil
    }
    
    var hasActiveSubscription: Bool {
        sessionManager.getSession()?.activeSubscription ?? false
    }
}
