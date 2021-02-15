//
//  QuestionManager.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import RxSwift

protocol QuestionManager: class {
    // MARK: API(Rx)
    func retrieve(courseId: Int, testId: Int?) -> Single<Test?>
    func retrieveTenSet(courseId: Int) -> Single<Test?>
    func retrieveFailedSet(courseId: Int) -> Single<Test?>
    func retrieveQotd(courseId: Int) -> Single<Test?>
    func retrieveRandomSet(courseId: Int) -> Single<Test?>
    func sendAnswer(questionId: Int, userTestId: Int, answerIds: [Int]) -> Single<Bool?>
}
