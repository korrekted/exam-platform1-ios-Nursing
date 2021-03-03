//
//  MonetizationManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.11.2020.
//

import RxSwift

final class MonetizationManagerCore: MonetizationManager {
    struct Constants {
        static let cachedMonetizationConfig = "monetization_manager_core_cached_monetization_config"
    }
}

// MARK: API
extension MonetizationManagerCore {
    func getMonetizationConfig() -> MonetizationConfig? {
        guard let data = UserDefaults.standard.data(forKey: Constants.cachedMonetizationConfig) else {
            return nil
        }
        
        return try? JSONDecoder().decode(MonetizationConfig.self, from: data)
    }
}

// MARK: API(Rx)
extension MonetizationManagerCore {
    func rxRetrieveMonetizationConfig(forceUpdate: Bool) -> Single<MonetizationConfig?> {
        if forceUpdate {
            return loadConfig()
        } else {
            return .deferred { [weak self] in
                guard let this = self else {
                    return .never()
                }
                
                return .just(this.getMonetizationConfig())
            }
        }
    }
}

// MARK: Private
private extension MonetizationManagerCore {
    func loadConfig() -> Single<MonetizationConfig?> {
        let request = GetMonetizationConfigRequest(userToken: SessionManagerCore().getSession()?.userToken,
                                                   version: UIDevice.appVersion ?? "1",
                                                   appAnonymousId: SDKStorage.shared.applicationAnonymousID)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map { GetMonetizationResponseMapper.map(from: $0) }
            .catchAndReturn(nil)
            .do(onSuccess: { [weak self] config in
                guard let config = config else {
                    return
                }
                
                self?.store(config: config)
            })
    }
    
    @discardableResult
    func store(config: MonetizationConfig) -> Bool {
        guard let data = try? JSONEncoder().encode(config) else {
            return false
        }
        
        UserDefaults.standard.setValue(data, forKey: Constants.cachedMonetizationConfig)
        
        return true
    }
}
