//
//  PurchaseManager.swift
//  Nursing
//
//  Created by Андрей Чернышев on 21.01.2022.
//

import RxSwift
import SwiftyStoreKit

final class PurchaseManager {
    func obtainProducts(ids: [String]) -> Single<[IAPProduct]> {
        Single<[IAPProduct]>.create { event in
            SwiftyStoreKit.retrieveProductsInfo(Set(ids)) { result in
                let products = result.retrievedProducts.map { IAPProduct(original: $0) }
                
                event(.success(products))
            }
            
            return Disposables.create()
        }
    }
}
