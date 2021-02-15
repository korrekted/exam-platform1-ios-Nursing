//
//  StudyViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class StudyViewModel {
    private lazy var courseManager = CoursesManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var questionManager = QuestionManagerCore()
    
    lazy var sections = makeSections()
}

// MARK: Private
private extension StudyViewModel {
    func makeSections() -> Driver<[StudyCollectionSection]> {
        let brief = makeBrief()
        let unlockQuestions = makeUnlockQuestions()
        let takeTest = makeTakeTest()
        let modesTitle = makeTitle(string: "Study.QuizModes".localized)
        let modes = makeModes()
        
        return Driver
            .combineLatest(brief, unlockQuestions, takeTest, modesTitle, modes) { brief, unlockQuestions, takeTest, modesTitle, modes -> [StudyCollectionSection] in
                var result = [StudyCollectionSection]()
                
                result.append(brief)
                if let unlockQuestions = unlockQuestions {
                    result.append(unlockQuestions)
                }
                result.append(takeTest)
                result.append(modesTitle)
                result.append(modes)
                
                return result
            }
    }
    
    // TODO: brief
    func makeBrief() -> Driver<StudyCollectionSection> {
        let course = courseManager.rxGetSelectedCourse()
            .asDriver(onErrorJustReturn: nil)
        
        let brief = Driver<(Int, [SCEBrief.Day])>.deferred {
            var calendar = [SCEBrief.Day]()
            
            for n in 0...7 {
                let date = Calendar.current.date(byAdding: .day, value: -n, to: Date()) ?? Date()
                
                let day = SCEBrief.Day(date: date, activity: n % 2 == 0)
                
                calendar.append(day)
            }
            
            return .just((3, calendar))
        }
        
        return Driver
            .combineLatest(course, brief) { course, brief -> StudyCollectionSection in
                let entity = SCEBrief(courseName: course?.name ?? "",
                                      streakDays: brief.0,
                                      calendar: brief.1)
                let element = StudyCollectionElement.brief(entity)
                return StudyCollectionSection(elements: [element])
            }
    }
    
    func makeUnlockQuestions() -> Driver<StudyCollectionSection?> {
        activeSubscription()
            .map { activeSubscription -> StudyCollectionSection? in
                activeSubscription ? nil : StudyCollectionSection(elements: [.unlockAllQuestions])
            }
    }
    
    func makeTakeTest() -> Driver<StudyCollectionSection> {
        Driver
            .combineLatest(makeTestsConfig(), activeSubscription())
            .map { configs, activeSubscription -> StudyCollectionSection in
                StudyCollectionSection(elements: [.takeTest(activeSubscription: activeSubscription,
                                                            configs: configs)])
            }
    }
    
    func makeTitle(string: String) -> Driver<StudyCollectionSection> {
        Driver<StudyCollectionSection>.deferred {
            let titleElement = StudyCollectionElement.title(string)
            let section = StudyCollectionSection(elements: [titleElement])
            
            return .just(section)
        }
    }
    
    func makeModes() -> Driver<StudyCollectionSection> {
        Driver<StudyCollectionSection>
            .deferred {
                let today = SCEMode(mode: .today,
                                    image: "Study.Mode.Todays",
                                    title: "Study.Mode.TodaysQuestion".localized)
                let todayElement = StudyCollectionElement.mode(today)
                
                let ten = SCEMode(mode: .ten,
                                    image: "Study.Mode.Ten",
                                    title: "Study.Mode.TenQuestions".localized)
                let tenElement = StudyCollectionElement.mode(ten)
                
                let missed = SCEMode(mode: .missed,
                                    image: "Study.Mode.Missed",
                                    title: "Study.Mode.MissedQuestions".localized)
                let missedElement = StudyCollectionElement.mode(missed)
                
                let random = SCEMode(mode: .random,
                                    image: "Study.Mode.Random",
                                    title: "Study.Mode.RandomSet".localized)
                let randomElement = StudyCollectionElement.mode(random)
                
                let section = StudyCollectionSection(elements: [
                    todayElement, tenElement, missedElement, randomElement
                ])
                
                return .just(section)
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
    
    func makeTestsConfig() -> Driver<[TestConfig]> {
        guard let courseId = courseManager.getSelectedCourse()?.id else {
            return .empty()
        }
        
        return questionManager
            .retrieveConfig(courseId: courseId)
            .asDriver(onErrorJustReturn: [])
    }
}
