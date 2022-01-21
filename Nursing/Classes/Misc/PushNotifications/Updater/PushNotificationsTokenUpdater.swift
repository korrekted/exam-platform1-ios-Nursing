//
//  PushNotificationsTokenUpdater.swift
//  RushSDK
//
//  Created by Andrey Chernyshev on 22.10.2020.
//

import RxSwift

final class PushNotificationsTokenUpdater {
    static let shared = PushNotificationsTokenUpdater()
    
    private let disposeBag = DisposeBag()
    
    private init() {}
}

// MARK: API
extension PushNotificationsTokenUpdater {
    func initialize() {
        PushNotificationsManager.shared.add(observer: self)
    }
}

// MARK: PushNotificationsManagerDelegate
extension PushNotificationsTokenUpdater: PushNotificationsManagerDelegate {
    func pushNotificationsManagerDidReceive(token: String?) {
        // TODO: при миграции с SDKRush на OtterScale отправку пуш-токена отложили. Для того, чтобы пуш-токен отправлять на бэк, реализовать этот метод.
//        guard let pushDeviceToken = token else {
//            return
//        }
//
//        let request: APIRequestBody
//
//        if let userToken = SDKStorage.shared.userToken {
//            request = SendUserPushNotificationsTokenRequest(domain: domain,
//                                                            apiKey: apiKey,
//                                                            pushDeviceToken: pushDeviceToken,
//                                                            userToken: userToken,
//                                                            applicationAnonymousID: SDKStorage.shared.applicationAnonymousID)
//        } else {
//            request = SendAnonymousPushNotificationsTokenRequest(domain: domain,
//                                                                 apiKey: apiKey,
//                                                                 pushDeviceToken: pushDeviceToken,
//                                                                 anonymousId: SDKStorage.shared.applicationAnonymousID)
//        }
//
//        SDKStorage.shared
//            .restApiTransport
//            .callServerApi(requestBody: request)
//            .subscribe()
//            .disposed(by: disposeBag)
    }
}
