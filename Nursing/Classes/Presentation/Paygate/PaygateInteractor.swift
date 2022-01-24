//
//  PaygateInteractor.swift
//  Nursing
//
//  Created by Андрей Чернышев on 24.01.2022.
//

import RxSwift
import RxCocoa
import OtterScaleiOS

final class PaygateInteractor {
    enum Action {
        case buy(String)
        case restore
    }
    
    enum PurchaseActionResult {
        case cancelled
        case completed(Bool)
    }
    
    private let iapManager = IAPManager()
    private let sessionManager = SessionManagerCore()
    private let profileManager = ProfileManagerCore()
    private let validationObserver = PurchaseValidationObserver.shared
}

// MARK: Public
extension PaygateInteractor {
    func makeActiveSubscription(by action: Action) -> Single<PurchaseActionResult> {
        let result: Single<PurchaseActionResult>
        
        switch action {
        case .buy(let productId):
            result = purchase(productId: productId)
        case .restore:
            result = restore()
        }
        
        return result.flatMap { [weak self] result -> Single<PurchaseActionResult> in
            guard let self = self else {
                return .never()
            }
            
            let otterScaleID = OtterScale.shared.getOtterScaleID()
            
            let complete: Single<Void>
        
            if let cachedToken = self.sessionManager.getSession()?.userToken {
                if cachedToken != otterScaleID {
                    complete = self.profileManager.syncTokens(oldToken: cachedToken, newToken: otterScaleID)
                } else {
                    complete = .deferred { .just(Void()) }
                }
            } else {
                complete = self.profileManager.login(userToken: otterScaleID)
            }
            
            return complete.flatMap { _ -> Single<PurchaseActionResult> in
                let session = Session(userToken: otterScaleID)
                self.sessionManager.store(session: session)
        
                return .deferred { .just(result) }
            }
        }
    }
}

// MARK: Private
private extension PaygateInteractor {
    func purchase(productId: String) -> Single<PurchaseActionResult> {
        iapManager.buyProduct(with: productId)
            .flatMap { [weak self] result in
                guard let self = self else {
                    return .never()
                }
                
                switch result {
                case .cancelled:
                    return .just(.cancelled)
                case .completed:
                    return self.validationObserver
                        .didValidatedWithActiveSubscription
                        .map {
                            let hasActiveSubscriptions = self.sessionManager.hasActiveSubscriptions()
                            return .completed(hasActiveSubscriptions)
                        }
                        .asObservable()
                        .asSingle()
                }
            }
    }
    
    func restore() -> Single<PurchaseActionResult> {
        iapManager.restorePurchases()
            .andThen(validationObserver
                        .didValidatedWithActiveSubscription
                        .asObservable()
                        .asSingle())
            .map { [weak self] _ -> PurchaseActionResult in
                let hasActiveSubscriptions = self?.sessionManager.hasActiveSubscriptions() ?? false
                return .completed(hasActiveSubscriptions)
            }
    }
}
