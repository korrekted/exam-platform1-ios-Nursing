//
//  IAPManager.swift
//  Nursing
//
//  Created by Андрей Чернышев on 24.01.2022.
//

import RxSwift
import SwiftyStoreKit
import StoreKit

final class IAPManager {}

// MARK: Public
extension IAPManager {
    func obtainProducts(ids: [String]) -> Single<[IAPProduct]> {
        Single<[IAPProduct]>.create { event in
            SwiftyStoreKit.retrieveProductsInfo(Set(ids)) { result in
                let products = result.retrievedProducts.map { IAPProduct(original: $0) }
                
                event(.success(products))
            }
            
            return Disposables.create()
        }
    }
    
    func buyProduct(with id: String) -> Single<IAPActionResult> {
        guard SwiftyStoreKit.canMakePayments else {
            return .error(IAPError(.paymentsDisabled))
        }
        
        return Single<IAPActionResult>
            .create { event in
                SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let purchase):
                        if purchase.productId == id {
                            event(.success(.completed(id)))
                        }
                    case .error(let error):
                        if IAPErrorHelper.treatErrorAsCancellation(error) {
                            event(.success(.cancelled))
                        } else if IAPErrorHelper.treatErrorAsSuccess(error) {
                            event(.success(.completed(id)))
                        } else {
                            event(.failure(IAPError(.paymentFailed, underlyingError: error)))
                        }
                    }
                }
                
                return Disposables.create()
            }
    }
    
    func restorePurchases() -> Completable {
        Completable
            .create { event in
                SwiftyStoreKit.restorePurchases { result in
                    if result.restoredPurchases.isEmpty {
                        event(.error(IAPError(.cannotRestorePurchases)))
                    } else {
                        event(.completed)
                    }
                }
                
                return Disposables.create()
            }
    }
}
