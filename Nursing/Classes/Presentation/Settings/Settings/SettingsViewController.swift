//
//  SettingsViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit
import RxSwift
import StoreKit

final class SettingsViewController: UIViewController {
    lazy var mainView = SettingsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = SettingsViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared
            .logEvent(name: "Settings Screen", parameters: [:])
        
        viewModel.elements
            .drive(onNext: { [weak self] elements in
                self?.mainView.tableView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension SettingsViewController {
    static func make() -> SettingsViewController {
        let vc = SettingsViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: SettingsTableDelegate
extension SettingsViewController: SettingsTableDelegate {
    func settingsTableDidTappedUnlockPremium() {
        AmplitudeManager.shared
            .logEvent(name: "Settings Tap", parameters: ["what": "unlock premium"])
        
        guard let rootViewController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController else {
            return
        }
        
        rootViewController.present(PaygateViewController.make(), animated: true)
    }
    
    func settingsTableDidTappedCourse() {
        AmplitudeManager.shared
            .logEvent(name: "Settings Tap", parameters: ["what": "select exam"])
        
        guard let rootViewController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController else {
            return
        }
        
        rootViewController.present(CoursesViewController.make(), animated: true)
    }
    
    func settingsTableDidTappedExamDate() {
        
    }
    
    func settingsTableDidTappedResetProgress() {
        
    }
    
    func settingsTableDidTappedTestMode() {
        guard let rootViewController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController else {
            return
        }
        
        let vc = ChangeTestModeViewController.make()
        rootViewController.present(vc, animated: true)
    }
    
    func settingsTableDidChanged(vibration: Bool) {
        
    }
    
    func settingsTableDidTappedTextSize() {
        
    }
    
    func settingsTableDidTappedRateUs() {
        AmplitudeManager.shared
            .logEvent(name: "Rating Request ", parameters: [:])
        AmplitudeManager.shared
            .logEvent(name: "Settings Tap", parameters: ["what": "rate us"])
        
        SKStoreReviewController.requestReview()
    }
    
    func settingsTableDidTappedJoinTheCommunity() {
        
    }
    
    func settingsTableDidTappedShareWithFriend() {
        
    }
    
    func settingsTableDidTappedContactUs() {
        AmplitudeManager.shared
            .logEvent(name: "Settings Tap", parameters: ["what": "contact us"])
        
        open(path: GlobalDefinitions.contactUsUrl)
    }
    
    func settingsTableDidTappedTermsOfUse() {
        AmplitudeManager.shared
            .logEvent(name: "Settings Tap", parameters: ["what": "terms of use"])
        
        open(path: GlobalDefinitions.termsOfServiceUrl)
    }
    
    func settingsTableDidTappedPrivacyPolicy() {
        AmplitudeManager.shared
            .logEvent(name: "Settings Tap", parameters: ["what": "privacy policy"])
        
        open(path: GlobalDefinitions.privacyPolicyUrl)
    }
}

// MARK: Private
private extension SettingsViewController {
    func open(path: String) {
        guard let url = URL(string: path) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
}
