//
//  StatsViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class StatsViewModel {
    private lazy var statsManager = StatsManagerCore()
    private lazy var courseManager = CoursesManagerCore()
    
    lazy var elements = makeElements()
}

// MARK: Private
private extension StatsViewModel {
    func makeElements() -> Driver<[StatsCellType]> {
        guard let courseId = courseManager.getSelectedCourse()?.id else {
            return .just([])
        }
        
        return statsManager
            .retrieveStats(courseId: courseId)
            .map { stats -> [StatsCellType] in
                guard let stats = stats else { return [] }
                let passRate: StatsCellType = .passRate(stats.passRate)
                let main: StatsCellType = .main(.init(stats: stats))
                
                return stats
                    .courseStats
                    .reduce(into: [passRate, main]) {
                        $0.append(.course(.init(courseStats: $1)))
                    }
            }
            .asDriver(onErrorJustReturn: [])
    }
}
