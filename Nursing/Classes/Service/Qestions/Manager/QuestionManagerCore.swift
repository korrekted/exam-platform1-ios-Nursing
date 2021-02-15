//
//  QuestionManagerCore.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import RxSwift

final class QuestionManagerCore: QuestionManager {
    
}

extension QuestionManagerCore {
    func retrieve(courseId: Int, testId: Int?) -> Single<Test?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetTestRequest(
            userToken: userToken,
            courseId: courseId,
            testid: testId
        )
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map(GetTestResponseMapper.map(from:))
    }
    
    func retrieveTenSet(courseId: Int) -> Single<Test?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetTenSetRequest(userToken: userToken, courseId: courseId)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map(GetTestResponseMapper.map(from:))
    }
    
    func retrieveFailedSet(courseId: Int) -> Single<Test?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetFailedSetRequest(userToken: userToken, courseId: courseId)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map(GetTestResponseMapper.map(from:))
    }
    
    func retrieveQotd(courseId: Int) -> Single<Test?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetQotdRequest(userToken: userToken, courseId: courseId)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map(GetTestResponseMapper.map(from:))
    }
    
    func retrieveRandomSet(courseId: Int) -> Single<Test?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetRandomSetRequest(userToken: userToken, courseId: courseId)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map(GetTestResponseMapper.map(from:))
    }
    
    func sendAnswer(questionId: Int, userTestId: Int, answerIds: [Int]) -> Single<Bool?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = SendAnswerRequest(
            userToken: userToken,
            questionId: questionId,
            userTestId: userTestId,
            answerIds: answerIds
        )
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map(SendAnswerResponseMapper.map(from:))
    }
}
