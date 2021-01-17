//
//  CoursesManager.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift

protocol CoursesManager: class {
    // MARK: API
    func select(course: Course)
    func getSelectedCourse() -> Course?
    
    // MARK: API(Rx)
    func retrieveCourses(forceUpdate: Bool) -> Single<[Course]>
    func rxSelect(course: Course) -> Completable
    func rxGetSelectedCourse() -> Single<Course?>
}
