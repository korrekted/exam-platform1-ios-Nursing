//
//  SettingsViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    private lazy var coursesManager = CoursesManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    
    lazy var sections = makeSections()
}

// MARK: Private
private extension SettingsViewModel {
    func makeSections() -> Driver<[SettingsTableSection]> {
        let activeSubscription = self.activeSubscription()
        let course = self.course()
        
        return Driver
            .combineLatest(activeSubscription, course) { activeSubscription, course -> [SettingsTableSection] in
                guard activeSubscription else {
                    return [
                        .unlockPremium,
                        .selectedCourse(course),
                        .links
                    ]
                }
                
                return [
                    .selectedCourse(course),
                    .links
                ]
            }
    }
    
    func activeSubscription() -> Driver<Bool> {
        let updated = SDKStorage.shared
            .purchaseMediator
            .rxPurchaseMediatorDidValidateReceipt
            .compactMap { $0?.activeSubscription }
            .asDriver(onErrorJustReturn: false)
        
        let initial = Driver<Bool>
            .deferred { [weak self] in
                guard let this = self else {
                    return .never()
                }
                
                let activeSubscription = this.sessionManager.getSession()?.activeSubscription ?? false
                
                return .just(activeSubscription)
            }
        
        return Driver
            .merge(initial, updated)
    }
    
    func course() -> Driver<Course> {
        coursesManager
            .rxGetSelectedCourse()
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
    }
}
