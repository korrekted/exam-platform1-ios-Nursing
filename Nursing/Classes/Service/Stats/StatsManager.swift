//
//  StatsManager.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 26.01.2021.
//

import RxSwift

protocol StatsManagerProtocol: AnyObject {
    func retrieveStats(courseId: Int) -> Single<Stats?>
    func retrieveBrief(courseId: Int) -> Single<Brief?>
    func resetStats(for courseId: Int) -> Single<Void>
}

final class StatsManager: StatsManagerProtocol {
    private let defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: Public
extension StatsManager {
    func retrieveStats(courseId: Int) -> Single<Stats?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetStatsRequest(userToken: userToken, courseId: courseId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { try GetStatsResponseMapper.map(from: $0) }
            .do(onSuccess: { [weak self] stats in
                self?.store(stats: stats)
            })
    }
    
    func retrieveBrief(courseId: Int) -> Single<Brief?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetBriefRequest(userToken: userToken, courseId: courseId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { try GetBriefResponseMapper.from(response: $0) }
    }
    
    func resetStats(for courseId: Int) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = ResetStatsRequest(userToken: userToken, courseId: courseId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: {
                StatsMediator.shared.notifyAboutResetedStats()
            })
    }
}

// MARK: Private
private extension StatsManager {
    func store(stats: Stats?) {
        guard let stats = stats else {
            return
        }
        
        StatsShareManager.shared.write(stats: stats)
    }
}