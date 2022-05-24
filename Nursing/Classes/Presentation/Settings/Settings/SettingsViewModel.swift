//
//  SettingsViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import RxSwift
import RxCocoa
import OtterScaleiOS

final class SettingsViewModel {
    lazy var elements = makeElements()
    
    private lazy var activeSubscription = makeActiveSubscription()
    
    private lazy var coursesManager = CoursesManager()
    private lazy var profileManager = ProfileManager()
}

// MARK: Private
private extension SettingsViewModel {
    func makeElements() -> Driver<[SettingsTableElement]> {
        let subscription = makeSubscriptionElement()
        let exam = makeExamElement()
        let study = makeStudyElement()
        
        return Driver
            .combineLatest(subscription, exam, study) { subscription, exam, study -> [SettingsTableElement] in
                var elements = [SettingsTableElement]()
                
                elements.append(contentsOf: [
                    subscription,
                    .offset(30.scale),
                    exam,
                    .offset(30.scale),
                    study,
                    .offset(30.scale),
                    .community,
                    .offset(30.scale),
                    .support,
                    .offset(30.scale)
                ])
                
                return elements
            }
    }
    
    func makeSubscriptionElement() -> Driver<SettingsTableElement> {
        activeSubscription
            .map { activeSubscription -> SettingsTableElement in
                if activeSubscription {
                    let element = SettingsPremium(title: "Settings.Premium.Title1".localized,
                                                  memberSince: OtterScale.shared.getUserSince() ?? "",
                                                  validTill: OtterScale.shared.getAccessValidTill() ?? "")
                    return .premium(element)
                } else {
                    return .unlockPremium
                }
            }
    }
    
    func makeExamElement() -> Driver<SettingsTableElement> {
        let course = makeCourse()
        let examDate = makeExamDate()
        
        return Driver.combineLatest(course, examDate) { course, examDate -> SettingsTableElement in
            let element = SettingsExam(course: course,
                                       examDate: examDate)
            return .exam(element)
        }
    }
    
    func makeCourse() -> Driver<Course?> {
        let initial = profileManager
            .obtainSelectedCourse(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
        
        let updated = ProfileMediator.shared
            .changedCourse
            .map { course -> Course? in
                course
            }
            .asDriver(onErrorJustReturn: nil)
        
        return Driver.merge(initial, updated)
    }
    
    func makeExamDate() -> Driver<Date?> {
        let initial = profileManager
            .obtainDateOfExam(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
        
        let updated = ProfileMediator.shared
            .changedDateOfExam
            .map { examDate -> Date? in
                examDate
            }
            .asDriver(onErrorJustReturn: nil)
        
        return Driver.merge(initial, updated)
    }
    
    func makeStudyElement() -> Driver<SettingsTableElement> {
        let testMode = makeTestMode()
        let vibration = makeVibration()
        
        return Driver.combineLatest(testMode, vibration) { testMode, vibration -> SettingsTableElement in
            let element = SettingsStudy(testMode: testMode,
                                        vibration: vibration)
            return .study(element)
        }
    }
    
    func makeTestMode() -> Driver<TestMode?> {
        let initial = profileManager
            .obtainTestMode(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
        
        let updated = ProfileMediator.shared
            .changedTestMode
            .map { testMode -> TestMode? in
                testMode
            }
            .asDriver(onErrorJustReturn: nil)
        
        return Driver.merge(initial, updated)
    }
    
    func makeVibration() -> Driver<Bool> {
        // TODO: реализовать
        
        return .deferred { .just(true) }
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { SessionManager().hasActiveSubscriptions() }
            .asDriver(onErrorJustReturn: false)
            .startWith(SessionManager().hasActiveSubscriptions())
    }
}
