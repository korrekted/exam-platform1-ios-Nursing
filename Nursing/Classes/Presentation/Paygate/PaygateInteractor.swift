//
//  PaygateInteractor.swift
//  NCLEX
//
//  Created by Андрей Чернышев on 03.02.2022.
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
    
    private lazy var iapManager = IAPManager()
    private lazy var sessionManager = SessionManager()
    private lazy var profileManager = ProfileManager()
    private lazy var validationObserver = PurchaseValidationObserver.shared
    
    private lazy var disposables = [Disposable]()
    
    private lazy var callback = PublishRelay<PurchaseActionResult>()
    
    deinit {
        OtterScale.shared.remove(delegate: self)
        
        disposables.forEach { $0.dispose() }
    }
}

// MARK: Public
extension PaygateInteractor {
    func makeActiveSubscription(by action: Action) -> Single<PurchaseActionResult> {
        OtterScale.shared.remove(delegate: self)
        OtterScale.shared.add(delegate: self)
        
        disposables.forEach { $0.dispose() }
        
        let disposable: Disposable
        switch action {
        case .buy(let productId):
            disposable = purchase(productId: productId)
        case .restore:
            disposable = restore()
        }
        
        disposables = [disposable]
        
        return Single<PurchaseActionResult>.create { [weak self] event in
            guard let self = self else {
                return Disposables.create()
            }
            
            let disposable = self.callback.subscribe(onNext: { result in
                event(.success(result))
            })
            
            self.disposables.append(disposable)
            
            return Disposables.create()
        }
    }
}

// MARK: OtterScaleReceiptValidationDelegate
extension PaygateInteractor: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: AppStoreValidateResult?) {
        OtterScale.shared.remove(delegate: self)
        
        let otterScaleID = OtterScale.shared.getInternalID()
        
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
        
        let disposable = complete.subscribe(onSuccess: { [weak self] in
            guard let self = self else {
                return
            }
            
            let session = Session(userToken: otterScaleID)
            self.sessionManager.store(session: session)
            
            let hasActiveSubscriptions = self.sessionManager.hasActiveSubscriptions()
            let result = PurchaseActionResult.completed(hasActiveSubscriptions)
            self.callback.accept(result)
        })
        
        disposables.append(disposable)
    }
}

// MARK: Private
private extension PaygateInteractor {
    func purchase(productId: String) -> Disposable {
        iapManager
            .buyProduct(with: productId)
            .subscribe(onSuccess: { [weak self] result in
                guard let self = self, case .cancelled = result else {
                    return
                }
                
                self.callback.accept(.cancelled)
            })
    }
    
    func restore() -> Disposable {
        iapManager
            .restorePurchases()
            .subscribe()
    }
}
