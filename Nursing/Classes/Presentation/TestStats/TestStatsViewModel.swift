//
//  TestStatsViewModel.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 11.02.2021.
//

import RxSwift
import RxCocoa

final class TestStatsViewModel {
    lazy var userTestId = BehaviorRelay<Int?>(value: nil)
    lazy var filterRelay = PublishRelay<TestStatsFilter>()
    
    lazy var elements = makeElements()
    
    private lazy var testStatsManager = TestStatsManagerCore()
}

// MARK: Private
private extension TestStatsViewModel {
    func makeElements() -> Driver<[TestStatsCellType]> {
        
        let stats = userTestId
            .compactMap { $0 }
            .flatMapLatest { [weak self] userTestId -> Observable<TestStats?> in
                guard let self = self else { return .empty() }
                
                return self.testStatsManager
                    .retrieve(userTestId: userTestId)
                    .asObservable()
                    .catchAndReturn(nil)
            }
            .asObservable()
        
        return Observable
            .combineLatest(stats, filterRelay.asObservable())
            .map { element, filter -> [TestStatsCellType] in
                guard let stats = element else { return [] }
                
                let initial: [TestStatsCellType] = [
                    .progress(.init(stats: stats)),
                    .description(.init(stats: stats)),
                    .filter(filter)
                ]
                
                return stats.questions
                    .reduce(into: initial) { old, question in
                        switch filter {
                        case .all:
                            old.append(.answer(.init(answer: question)))
                        case .incorrect:
                            if !question.correct {
                                old.append(.answer(.init(answer: question)))
                            } else {
                                break
                            }
                        case .correct:
                            if question.correct {
                                old.append(.answer(.init(answer: question)))
                            } else {
                                break
                            }
                        }
                    }
            }
            .asDriver(onErrorJustReturn: [])
    }
}


