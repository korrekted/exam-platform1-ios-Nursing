//
//  SplashViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa
import OtterScaleiOS

final class SplashViewModel {
    enum Step {
        case onboarding, course, paygate
    }
    
    lazy var validationComplete = PublishRelay<Void>()
    
    private lazy var coursesManager = CoursesManagerCore()
    private lazy var monetizationManager = MonetizationManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var profileManager = ProfileManagerCore()
    
    func step() -> Driver<Step> {
        handleValidationComplete()
            .flatMap { [weak self] _ -> Single<Void> in
                guard let self = self else {
                    return .never()
                }
                
                return self.library()
            }
            .flatMap { [weak self] _ -> Single<Step> in
                guard let self = self else {
                    return .never()
                }
                
                return self.makeStep()
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    /// Вызывается в методе делегата PaygateViewControllerDelegate для определения, какой экран открыть после закрытия пейгейта. Отличается от makeStep тем, что не учитывает повторное открытие пейгейта.
    func stepAfterPaygateClosed() -> Step {
        guard OnboardingViewController.wasViewed() else {
            return .onboarding
        }
        
        if coursesManager.getSelectedCourse() != nil {
            return .course
        }
        
        return .course
    }
}

// MARK: Private
private extension SplashViewModel {
    func handleValidationComplete() -> Observable<Void> {
        validationComplete.flatMapLatest { [weak self] _ -> Single<Void> in
            guard let self = self else {
                return .never()
            }
            
            let otterScaleID = OtterScale.shared.getOtterScaleID()
            
            let complete: Single<Void>
            
            if let cachedToken = self.sessionManager.getSession()?.userToken {
                if cachedToken != otterScaleID {
                    complete = self.profileManager.syncTokens(oldToken: cachedToken, newToken: otterScaleID)
                } else {
                    complete = .deferred { .just(Void()) }
                }
            } else {
                complete = self.profileManager.login(userToken: otterScaleID)
            }
            
            return complete.flatMap { [weak self] _ -> Single<Void> in
                guard let self = self else {
                    return .never()
                }
                
                let session = Session(userToken: otterScaleID)
                self.sessionManager.store(session: session)
                
                return .deferred { .just(Void()) }
            }
        }
    }
    
    func library() -> Single<Void> {
        Single
            .zip(
                monetizationManager
                    .rxRetrieveMonetizationConfig(forceUpdate: true)
                    .catchAndReturn(nil),
                
                coursesManager
                    .retrieveReferences(forceUpdate: true)
                    .catchAndReturn([])
            ) { _, _ in Void() }
    }
    
    func makeStep() -> Single<Step> {
        coursesManager
            .retrieveSelectedCourse(forceUpdate: true)
            .catchAndReturn(nil)
            .map { [weak self] selectedCourse -> Step in
                guard let self = self else {
                    return .onboarding
                }
                
                if selectedCourse != nil {
                    return .course
                }
                
                guard OnboardingViewController.wasViewed() else {
                    return .onboarding
                }
                
                if self.needPayment() {
                    return .paygate
                }
                
                return .course
            }
    }
    
    func needPayment() -> Bool {
        let activeSubscription = sessionManager.hasActiveSubscriptions()
        return !activeSubscription
    }
}
