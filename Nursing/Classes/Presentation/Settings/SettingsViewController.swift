//
//  SettingsViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit
import RxSwift

final class SettingsViewController: UIViewController {
    lazy var mainView = SettingsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = SettingsViewModel()
    private lazy var screenOpener = SettingsOpener()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared
            .logEvent(name: "Settings Screen", parameters: [:])
        
        viewModel
            .sections
            .drive(onNext: { [weak self] sections in
                self?.mainView.tableView.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        mainView
            .tableView.tapped
            .subscribe(onNext: { [weak self] value in
                self?.tapped(value)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension SettingsViewController {
    static func make() -> SettingsViewController {
        SettingsViewController()
    }
}

// MARK: Private
private extension SettingsViewController {
    func tapped(_ tapped: SettingsTableView.Tapped) {
        switch tapped {
        case .unlock:
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(PaygateViewController.make(), animated: true)
            
            AmplitudeManager.shared
                .logEvent(name: "Settings Tap", parameters: ["what": "unlock premium"])
        case .course:
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = CoursesViewController.make(howOpen: .root)
            
            AmplitudeManager.shared
                .logEvent(name: "Settings Tap", parameters: ["what": "select exam"])
        case .rateUs:
            RateUs.requestReview()
            
            AmplitudeManager.shared
                .logEvent(name: "Settings Tap", parameters: ["what": "rate us"])
        case .contactUs:
            open(path: GlobalDefinitions.contactUsUrl)
            
            AmplitudeManager.shared
                .logEvent(name: "Settings Tap", parameters: ["what": "contact us"])
        case .termsOfUse:
            open(path: GlobalDefinitions.termsOfServiceUrl)
            
            AmplitudeManager.shared
                .logEvent(name: "Settings Tap", parameters: ["what": "terms of use"])
        case .privacyPoliicy:
            open(path: GlobalDefinitions.privacyPolicyUrl)
            
            AmplitudeManager.shared
                .logEvent(name: "Settings Tap", parameters: ["what": "privacy policy"])
        case .mode(let testMode):
            screenOpener.open(screen: .mode(testMode), from: self)
        case .references:
            screenOpener.open(screen: .references, from: self)
        }
    }
    
    func open(path: String) {
        guard let url = URL(string: path) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
}
