//
//  SplashViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class SplashViewModel {
    enum Step {
        case onboarding, courses, course
    }
    
    private lazy var coursesManager = CoursesManagerCore()
    private let monetizationManager = MonetizationManagerCore()
    
    func step() -> Driver<Step> {
        library()
            .andThen(makeStep())
            .asDriver(onErrorDriveWith: .empty())
    }
}

// MARK: Private
private extension SplashViewModel {
    func library() -> Completable {
        monetizationManager
            .rxRetrieveMonetizationConfig(forceUpdate: true)
            .catchAndReturn(nil)
            .asCompletable()
    }
    func makeStep() -> Observable<Step> {
        guard OnboardingViewController.wasViewed() else {
            return .deferred { .just(.onboarding) }
        }
        
        if coursesManager.getSelectedCourse() != nil {
            return .deferred { .just(.course) }
        }
        
        return .deferred { .just(.courses) }
    }
}
