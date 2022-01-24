//
//  TestStatsManagerCore.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import RxSwift

final class TestStatsManagerCore: TestStatsManager {
    private lazy var restAPITransport = RestAPITransport()
}


extension TestStatsManagerCore {
    func retrieve(userTestId: Int) -> Single<TestStats?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetTestStatsRequest(userToken: userToken, userTestId: userTestId)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map(GetTestStatsResponseMapper.map(from:))
    }
}
