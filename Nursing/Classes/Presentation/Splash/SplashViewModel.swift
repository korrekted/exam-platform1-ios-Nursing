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
        case onboarding, course, paygate, courses
    }
    
    lazy var validationComplete = PublishRelay<Void>()
    lazy var courseSelected = PublishRelay<Void>()
    
    private lazy var coursesManager = CoursesManagerCore()
    private lazy var monetizationManager = MonetizationManager()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var profileManager = ProfileManagerCore()
    private lazy var paygateManager = PaygateManager()
    private lazy var questionManager = QuestionManagerCore()
    
    func step() -> Driver<Step> {
        let initial = handleValidationComplete()
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
                
                return self.makeInitialStep()
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let afterCourseSelected = courseSelected
            .compactMap { [weak self] _ -> Step? in
                guard let self = self else {
                    return nil
                }
                
                return self.needPayment() ? .paygate : .course
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return Driver.merge(initial, afterCourseSelected)
    }
    
    func obtainOnboardingSet() -> Driver<Test?> {
        questionManager
            .retrieveOnboardingSet(forceUpdate: true)
            .asDriver(onErrorJustReturn: nil)
    }
}

// MARK: Private
private extension SplashViewModel {
    func handleValidationComplete() -> Observable<Void> {
        validationComplete.flatMapLatest { [weak self] _ -> Single<Void> in
            guard let self = self else {
                return .never()
            }
            
            let otterScaleID = OtterScale.shared.getInternalID()
            
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
                    .catchAndReturn([]),
                
                coursesManager
                    .retrieveCourses(forceUpdate: true)
                    .catchAndReturn([]),
                
                paygateManager
                    .retrievePaygate(forceUpdate: true)
                    .catchAndReturn(nil)
            )
            .map { _ in Void() }
    }
    
    func makeInitialStep() -> Single<Step> {
        coursesManager
            .retrieveSelectedCourse(forceUpdate: true)
            .catchAndReturn(nil)
            .map { [weak self] selectedCourse -> Step in
                guard let self = self else {
                    return .onboarding
                }
                
                // Если у пользователя есть выбранный курс, значит он уже проходил онбординг (в вебе или андроиде, например). Смотрим, есть ли платный доступ и открываем либо пейгейт, либо главный экран.
                if selectedCourse != nil {
                    return self.needPayment() ? .paygate : .course
                }
                
                // Если пользователь не выбирал курс и не проходил онбординг, отправляем его на онбординг.
                if !OnboardingViewController.wasViewed() {
                    return .onboarding
                }
                
                // Если пользователь проходил онбординг, но не имеет выбранный курс, открываем экран для выбора курса.
                return .courses
            }
    }
    
    func needPayment() -> Bool {
        let activeSubscription = sessionManager.hasActiveSubscriptions()
        return !activeSubscription
    }
}
