//
//  BranchManager.swift
//  NCLEX
//
//  Created by Андрей Чернышев on 03.02.2022.
//

import Branch

final class BranchManager {
    static let shared = BranchManager()
    
    private let installRefParams = InstallRefParams()
    
    private init() {}
}

// MARK: Public
extension BranchManager {
    func initialize(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        Branch.getInstance().initSession(launchOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) {
        Branch.getInstance().application(app, open: url, options: options)
    }
    
    func application(continue userActivity: NSUserActivity) {
        Branch.getInstance().continue(userActivity)
    }
    
    func retrieveInternalUserID(completion: @escaping ((String?) -> Void)) {
        installRefParams.retrieveInternalUserID(completion: completion)
    }
}

private final class InstallRefParams {
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    private var timer: Timer?
    
    private var tick = 0
    
    func retrieveInternalUserID(completion: @escaping ((String?) -> Void)) {
        timer?.invalidate()
        tick = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            let params = Branch.getInstance().getFirstReferringParams()
            let userID = params?["internal_user_id"] as? String
            
            if userID != nil || self.tick > 4 {
                self.timer?.invalidate()
                self.timer = nil
                
                completion(userID)
                
                return
            }
            
            self.tick += 1
        }
    }
}
