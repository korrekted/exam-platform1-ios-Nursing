//
//  CoursesManagerCore.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift

final class CoursesManagerCore: CoursesManager {
    struct Constants {
        static let cachedCoursesKey = "courses_manager_core_cached_courses_key"
    }
}

// MARK: API
extension CoursesManagerCore {
    func select(course: Course) {
        
    }
    
    func getSelectedCourse() -> Course? {
        nil
    }
}

// MARK: API(Rx)
extension CoursesManagerCore {
    func retrieveCourses(forceUpdate: Bool) -> Single<[Course]> {
        .never()
    }
    
    func rxSelect(course: Course) -> Completable {
        .never()
    }
    
    func rxGetSelectedCourse() -> Single<Course?> {
        .never()
    }
}
