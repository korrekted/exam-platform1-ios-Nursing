//
//  ProfileManagerCore.swift
//  FNP
//
//  Created by Andrey Chernyshev on 09.07.2021.
//

import RxSwift

final class ProfileManagerCore: ProfileManager {
    private lazy var restAPITransport = RestAPITransport()
}

// MARK: Study
extension ProfileManagerCore {
    func set(level: Int? = nil,
             assetsPreferences: [Int]? = nil,
             testMode: Int? = nil,
             examDate: String? = nil,
             testMinutes: Int? = nil,
             testNumber: Int? = nil,
             testWhen: [Int]? = nil,
             notificationKey: String? = nil) -> Single<Void> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SetRequest(userToken: userToken,
                                 level: level,
                                 assetsPreferences: assetsPreferences,
                                 testMode: testMode,
                                 examDate: examDate,
                                 testMinutes: testMinutes,
                                 testNumber: testNumber,
                                 testWhen: testWhen,
                                 notificationKey: notificationKey)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .flatMap { [weak self] _ -> Single<Void> in
                guard let self = self else {
                    return .never()
                }
                
                return self.notifyAboutChangedIfNotNil(testMode: testMode)
            }
    }
    
    func syncTokens(oldToken: String, newToken: String) -> Single<Void> {
        let request = SyncTokensRequest(oldToken: oldToken, newToken: newToken)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { _ in Void() }
    }
    
    func login(userToken: String) -> Single<Void> {
        restAPITransport
            .callServerApi(requestBody: LoginRequest(userToken: userToken))
            .map { _ in Void() }
    }
}

// MARK: Test Mode
extension ProfileManagerCore {
    func obtainTestMode() -> Single<TestMode?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetTestModeRequest(userToken: userToken)
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map(GetTestModeResponseMapper.map(from:))
    }
    
    func notifyAboutChangedIfNotNil(testMode: Int?) -> Single<Void> {
        guard
            let testMode = testMode,
            let mode = GetTestModeResponseMapper.map(testModeCode: testMode)
        else {
            return .deferred { .just(Void()) }
        }
        
        ProfileMediator.shared.notifyAboutChanged(testMode: mode)
        
        return .deferred { .just(Void()) }
    }
}
